package com.companieaerienne.services;

import com.companieaerienne.entities.FacturePub;
import com.companieaerienne.entities.FacturePubLigne;
import com.companieaerienne.entities.PaiementPub;
import com.companieaerienne.entities.PaiementPubAffectation;
import com.companieaerienne.entities.Societe;
import com.companieaerienne.entities.TarifDiffusionPub;
import com.companieaerienne.entities.VolProgrammation;
import com.companieaerienne.repositories.DiffusionPubRepository;
import com.companieaerienne.repositories.FacturePubLigneRepository;
import com.companieaerienne.repositories.FacturePubRepository;
import com.companieaerienne.repositories.PaiementPubAffectationRepository;
import com.companieaerienne.repositories.PaiementPubRepository;
import com.companieaerienne.repositories.TarifDiffusionPubRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

@Service
@RequiredArgsConstructor
public class FacturationPubService {

    private final FacturePubRepository facturePubRepository;
    private final FacturePubLigneRepository facturePubLigneRepository;
    private final PaiementPubRepository paiementPubRepository;
    private final PaiementPubAffectationRepository paiementPubAffectationRepository;
    private final DiffusionPubRepository diffusionPubRepository;
    private final TarifDiffusionPubRepository tarifDiffusionPubRepository;

    @Transactional
    public FacturePub genererOuMettreAJourFactureMensuelle(Societe societe, int annee, int mois) {
        if (societe == null) {
            throw new IllegalArgumentException("Société invalide.");
        }
        if (mois < 1 || mois > 12) {
            throw new IllegalArgumentException("Mois invalide.");
        }

        FacturePub facture = facturePubRepository
                .findBySocieteAndAnneeAndMois(societe, annee, mois)
                .orElse(null);

        if (facture == null) {
            facture = new FacturePub();
            facture.setSociete(societe);
            facture.setAnnee(annee);
            facture.setMois(mois);
            facture.setDateCreation(LocalDate.now());
            facture.setTotalTheorique(BigDecimal.ZERO);
            facture.setTotalPaye(BigDecimal.ZERO);
            facture = facturePubRepository.save(facture);
        }

        // Si déjà payé partiellement, on bloque la régénération automatique pour éviter d'incohérences.
        if (facture.getTotalPaye() != null && facture.getTotalPaye().compareTo(BigDecimal.ZERO) > 0) {
            return facture;
        }

        // Rebuild des lignes (uniquement si aucun paiement)
        List<FacturePubLigne> existantes = facturePubLigneRepository.findByFacturePubOrderByIdAsc(facture);
        if (existantes != null && !existantes.isEmpty()) {
            facturePubLigneRepository.deleteAll(existantes);
        }

        LocalDate debut = LocalDate.of(annee, mois, 1);
        LocalDate fin = debut.plusMonths(1);
        LocalDateTime start = debut.atStartOfDay();
        LocalDateTime end = fin.atStartOfDay();

        List<Object[]> rows = diffusionPubRepository.sumNombreDiffusionsBySocieteAndVolBetween(societe, start, end);
        BigDecimal total = BigDecimal.ZERO;
        if (rows != null) {
            for (Object[] r : rows) {
                VolProgrammation vp = (VolProgrammation) r[0];
                int nb = 0;
                if (r[1] instanceof Number) {
                    nb = ((Number) r[1]).intValue();
                }
                if (vp == null || vp.getDateHeure() == null || nb <= 0) continue;

                LocalDate dateVol = vp.getDateHeure().toLocalDate();
                TarifDiffusionPub tdp = tarifDiffusionPubRepository.findTarifActifPourDate(dateVol)
                        .orElseThrow(() -> new IllegalStateException("Aucun tarif diffusion pub actif pour " + dateVol));

                if (tdp.getMontant() == null) {
                    throw new IllegalStateException("Tarif diffusion pub invalide (montant null)");
                }

                BigDecimal prix = tdp.getMontant();
                BigDecimal montant = prix.multiply(BigDecimal.valueOf(nb));

                FacturePubLigne l = new FacturePubLigne();
                l.setFacturePub(facture);
                l.setVolProgrammation(vp);
                l.setNbDiffusions(nb);
                l.setPrixUnitaire(prix);
                l.setMontantTheorique(montant);
                l.setMontantPaye(BigDecimal.ZERO);
                facturePubLigneRepository.save(l);

                total = total.add(montant);
            }
        }

        facture.setTotalTheorique(total);
        facture.setTotalPaye(BigDecimal.ZERO);
        return facturePubRepository.save(facture);
    }

    @Transactional
    public PaiementPub enregistrerPaiementEtAffecter(FacturePub facture, LocalDate datePaiement, BigDecimal montant) {
        if (facture == null || facture.getId() == null) {
            throw new IllegalArgumentException("Facture invalide.");
        }
        if (datePaiement == null) {
            throw new IllegalArgumentException("Date de paiement invalide.");
        }
        if (montant == null || montant.compareTo(BigDecimal.ZERO) <= 0) {
            throw new IllegalArgumentException("Le montant doit être supérieur à 0.");
        }

        List<FacturePubLigne> lignes = facturePubLigneRepository.findByFacturePubOrderByIdAsc(facture);
        if (lignes == null || lignes.isEmpty()) {
            throw new IllegalStateException("Aucune ligne à facturer pour cette période.");
        }

        BigDecimal resteTotal = BigDecimal.ZERO;
        List<FacturePubLigneReste> restes = new ArrayList<>();
        for (FacturePubLigne l : lignes) {
            BigDecimal theorique = l.getMontantTheorique() != null ? l.getMontantTheorique() : BigDecimal.ZERO;
            BigDecimal paye = l.getMontantPaye() != null ? l.getMontantPaye() : BigDecimal.ZERO;
            BigDecimal reste = theorique.subtract(paye);
            if (reste.compareTo(BigDecimal.ZERO) > 0) {
                resteTotal = resteTotal.add(reste);
                restes.add(new FacturePubLigneReste(l, reste));
            }
        }

        if (resteTotal.compareTo(BigDecimal.ZERO) <= 0) {
            throw new IllegalStateException("Facture déjà totalement payée.");
        }

        if (montant.compareTo(resteTotal) > 0) {
            throw new IllegalArgumentException("Surpaiement interdit. Reste à payer: " + resteTotal + " Ar");
        }

        // Crée le paiement
        PaiementPub paiement = new PaiementPub();
        paiement.setSociete(facture.getSociete());
        paiement.setFacturePub(facture);
        paiement.setDatePaiement(datePaiement);
        paiement.setMontant(montant);
        paiement = paiementPubRepository.save(paiement);

        // Affectation prorata sur les restes
        // taux = montant / resteTotal
        BigDecimal taux = montant.divide(resteTotal, 10, RoundingMode.HALF_UP);

        // Trier par reste décroissant pour mettre la correction d'arrondi sur la plus grosse ligne
        restes.sort(Comparator.comparing(FacturePubLigneReste::reste).reversed());

        BigDecimal sommeAffectee = BigDecimal.ZERO;
        List<AffectTemp> temps = new ArrayList<>();
        for (FacturePubLigneReste rr : restes) {
            BigDecimal affect = rr.reste.multiply(taux).setScale(2, RoundingMode.HALF_UP);
            if (affect.compareTo(BigDecimal.ZERO) < 0) affect = BigDecimal.ZERO;
            temps.add(new AffectTemp(rr.ligne, affect));
            sommeAffectee = sommeAffectee.add(affect);
        }

        // Ajustement d'arrondi pour que somme == montant
        BigDecimal delta = montant.subtract(sommeAffectee);
        if (!temps.isEmpty() && delta.compareTo(BigDecimal.ZERO) != 0) {
            AffectTemp first = temps.get(0);
            first.montant = first.montant.add(delta);
        }

        // Persist affectations + maj lignes/facture
        BigDecimal totalPayeFacture = facture.getTotalPaye() != null ? facture.getTotalPaye() : BigDecimal.ZERO;
        for (AffectTemp t : temps) {
            if (t.montant.compareTo(BigDecimal.ZERO) <= 0) continue;

            FacturePubLigne ligne = t.ligne;
            BigDecimal payeAvant = ligne.getMontantPaye() != null ? ligne.getMontantPaye() : BigDecimal.ZERO;
            ligne.setMontantPaye(payeAvant.add(t.montant));
            facturePubLigneRepository.save(ligne);

            PaiementPubAffectation a = new PaiementPubAffectation();
            a.setPaiementPub(paiement);
            a.setFacturePubLigne(ligne);
            a.setMontantAffecte(t.montant);
            paiementPubAffectationRepository.save(a);

            totalPayeFacture = totalPayeFacture.add(t.montant);
        }

        facture.setTotalPaye(totalPayeFacture);
        facturePubRepository.save(facture);

        return paiement;
    }

    private record FacturePubLigneReste(FacturePubLigne ligne, BigDecimal reste) {
    }

    private static class AffectTemp {
        private final FacturePubLigne ligne;
        private BigDecimal montant;

        private AffectTemp(FacturePubLigne ligne, BigDecimal montant) {
            this.ligne = ligne;
            this.montant = montant;
        }
    }
}
