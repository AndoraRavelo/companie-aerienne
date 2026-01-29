package com.companieaerienne.services;

import com.companieaerienne.entities.TarifDiffusionPub;
import com.companieaerienne.repositories.FacturePubRepository;
import com.companieaerienne.repositories.DiffusionPubRepository;
import com.companieaerienne.repositories.TarifDiffusionPubRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class PubliciteService {

    private final DiffusionPubRepository diffusionPubRepository;
    private final TarifDiffusionPubRepository tarifDiffusionPubRepository;
    private final FacturePubRepository facturePubRepository;

    public record LigneCaPublicite(String societe,
                                  int nombreDiffusions,
                                  BigDecimal prixUnitaire,
                                  BigDecimal montant,
                                  BigDecimal montantPaye,
                                  BigDecimal resteAPayer) {
    }

    public record RapportCaPublicite(int annee,
                                     int mois,
                                     BigDecimal prixUnitaire,
                                     List<LigneCaPublicite> lignes,
                                     BigDecimal total,
                                     BigDecimal totalPaye,
                                     BigDecimal totalReste) {
    }

    public BigDecimal chiffreAffairesMensuel(int annee, int mois) {
        LocalDate debut = LocalDate.of(annee, mois, 1);
        LocalDate fin = debut.plusMonths(1);

        LocalDateTime start = debut.atStartOfDay();
        LocalDateTime end = fin.atStartOfDay();

        Integer nbDiffusions = diffusionPubRepository.sumNombreDiffusionsBetween(start, end);
        int n = nbDiffusions != null ? nbDiffusions : 0;

        TarifDiffusionPub tarif = tarifDiffusionPubRepository
                .findTarifActifPourDate(debut)
                .orElseThrow(() -> new IllegalStateException("Aucun tarif de diffusion pub actif pour " + debut));

        if (tarif.getMontant() == null) {
            throw new IllegalStateException("Tarif diffusion pub invalide (montant null)");
        }

        return tarif.getMontant().multiply(BigDecimal.valueOf(n));
    }

    public RapportCaPublicite rapportMensuel(int annee, int mois) {
        LocalDate debut = LocalDate.of(annee, mois, 1);
        LocalDate fin = debut.plusMonths(1);

        LocalDateTime start = debut.atStartOfDay();
        LocalDateTime end = fin.atStartOfDay();

        // IMPORTANT: avec la facturation mensuelle, un paiement peut être effectué en dehors du mois facturé.
        // On doit donc calculer le 'payé' à partir des factures du mois (facture_pub.total_paye), pas via date_paiement.
        Map<String, BigDecimal> payesParSociete = new HashMap<>();
        List<com.companieaerienne.entities.FacturePub> factures = facturePubRepository.findByAnneeAndMois(annee, mois);
        if (factures != null) {
            for (com.companieaerienne.entities.FacturePub f : factures) {
                if (f == null || f.getSociete() == null || f.getSociete().getNom() == null) continue;
                BigDecimal paye = f.getTotalPaye() != null ? f.getTotalPaye() : BigDecimal.ZERO;
                payesParSociete.put(f.getSociete().getNom(), paye);
            }
        }

        TarifDiffusionPub tarif = tarifDiffusionPubRepository
                .findTarifActifPourDate(debut)
                .orElseThrow(() -> new IllegalStateException("Aucun tarif de diffusion pub actif pour " + debut));

        if (tarif.getMontant() == null) {
            throw new IllegalStateException("Tarif diffusion pub invalide (montant null)");
        }

        BigDecimal prix = tarif.getMontant();

        List<Object[]> rows = diffusionPubRepository.sumNombreDiffusionsBySocieteBetween(start, end);
        List<LigneCaPublicite> lignes = new ArrayList<>();
        BigDecimal total = BigDecimal.ZERO;
        BigDecimal totalPaye = BigDecimal.ZERO;
        BigDecimal totalReste = BigDecimal.ZERO;
        if (rows != null) {
            for (Object[] r : rows) {
                String societe = r[0] != null ? r[0].toString() : "(inconnu)";
                int nb = 0;
                if (r[1] instanceof Number) {
                    nb = ((Number) r[1]).intValue();
                }
                BigDecimal montant = prix.multiply(BigDecimal.valueOf(nb));

                BigDecimal paye = payesParSociete.getOrDefault(societe, BigDecimal.ZERO);
                BigDecimal reste = montant.subtract(paye);
                lignes.add(new LigneCaPublicite(societe, nb, prix, montant, paye, reste));
                total = total.add(montant);
                totalPaye = totalPaye.add(paye);
                totalReste = totalReste.add(reste);
            }
        }

        return new RapportCaPublicite(annee, mois, prix, lignes, total, totalPaye, totalReste);
    }
}
