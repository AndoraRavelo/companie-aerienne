package com.companieaerienne.services;

import com.companieaerienne.entities.CategorieType;
import com.companieaerienne.entities.Classe;
import com.companieaerienne.entities.TarifDiffusionPub;
import com.companieaerienne.entities.TarifVol;
import com.companieaerienne.entities.VolProgrammation;
import com.companieaerienne.repositories.AchatExtraLigneRepository;
import com.companieaerienne.repositories.CategorieTypeRepository;
import com.companieaerienne.repositories.ClasseRepository;
import com.companieaerienne.repositories.DiffusionPubRepository;
import com.companieaerienne.repositories.FacturePubLigneRepository;
import com.companieaerienne.repositories.ReservationRepository;
import com.companieaerienne.repositories.TarifDiffusionPubRepository;
import com.companieaerienne.repositories.TarifVolRepository;
import com.companieaerienne.repositories.VolProgrammationRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class ChiffreAffairesVolService {

    private final VolProgrammationRepository volProgrammationRepository;
    private final ReservationRepository reservationRepository;
    private final DiffusionPubRepository diffusionPubRepository;
    private final FacturePubLigneRepository facturePubLigneRepository;
    private final AchatExtraLigneRepository achatExtraLigneRepository;
    private final TarifDiffusionPubRepository tarifDiffusionPubRepository;
    private final TarifVolRepository tarifVolRepository;
    private final ClasseRepository classeRepository;
    private final CategorieTypeRepository categorieTypeRepository;

    public record LigneCaVol(VolProgrammation vp,
                             BigDecimal montantBillets,
                             BigDecimal montantPublicites,
                             BigDecimal montantExtras,
                             BigDecimal montantTotal,
                             Integer billetsVendus,
                             Integer diffusions,
                             String dateDepart,
                             String heureDepart,
                             BigDecimal montantPublicitesPayee,
                             BigDecimal restePublicites) {
    }

    public List<LigneCaVol> rapportParRoute(String departNom, String arriveNom) {
        if (departNom == null || departNom.isBlank() || arriveNom == null || arriveNom.isBlank()) {
            return java.util.Collections.emptyList();
        }

        List<VolProgrammation> vols = volProgrammationRepository.findByRouteNoms(departNom.trim(), arriveNom.trim());
        List<LigneCaVol> lignes = new ArrayList<>();

        Classe eco = classeRepository.findByNomIgnoreCase("Economique").orElse(null);
        if (eco == null) {
            throw new IllegalStateException("Classe 'Economique' introuvable");
        }
        CategorieType adulte = categorieTypeRepository.findByCode("ADULTE").orElse(null);
        if (adulte == null) {
            throw new IllegalStateException("CategorieType 'ADULTE' introuvable");
        }

        for (VolProgrammation vp : vols) {
            if (vp == null || vp.getDateHeure() == null) continue;

            Integer billets = reservationRepository.sumPlacesByVolProgrammation(vp);
            int nbBillets = billets != null ? billets : 0;

            BigDecimal tarifBillet = BigDecimal.ZERO;
            TarifVol tv = tarifVolRepository.findByVolProgrammationAndClasseAndCategorieType(vp, eco, adulte).orElse(null);
            if (tv != null && tv.getTarif() != null) {
                tarifBillet = tv.getTarif();
            }

            BigDecimal caBillets = tarifBillet.multiply(BigDecimal.valueOf(nbBillets));

            Integer diffs = diffusionPubRepository.sumNombreDiffusionsByVolProgrammation(vp);
            int nbDiffs = diffs != null ? diffs : 0;

            BigDecimal tarifDiff = BigDecimal.ZERO;
            LocalDate date = vp.getDateHeure().toLocalDate();
            TarifDiffusionPub tdp = tarifDiffusionPubRepository.findTarifActifPourDate(date).orElse(null);
            if (tdp != null && tdp.getMontant() != null) {
                tarifDiff = tdp.getMontant();
            }

            BigDecimal caPubs = tarifDiff.multiply(BigDecimal.valueOf(nbDiffs));

            BigDecimal caExtras = BigDecimal.ZERO;
            BigDecimal sumExtras = achatExtraLigneRepository.sumSousTotalByVolProgrammation(vp);
            if (sumExtras != null) {
                caExtras = sumExtras;
            }

            BigDecimal total = caBillets.add(caPubs).add(caExtras);

            BigDecimal pubsPayees = BigDecimal.ZERO;
            BigDecimal sumPaye = facturePubLigneRepository.sumMontantPayeByVolProgrammation(vp);
            if (sumPaye != null) {
                pubsPayees = sumPaye;
            }
            BigDecimal restePubs = caPubs.subtract(pubsPayees);
            if (restePubs.compareTo(BigDecimal.ZERO) < 0) {
                restePubs = BigDecimal.ZERO;
            }

            String dateDepart = vp.getDateHeure().toLocalDate().format(DateTimeFormatter.ISO_LOCAL_DATE);
            String heureDepart = vp.getDateHeure().toLocalTime().format(DateTimeFormatter.ofPattern("HH:mm"));

            lignes.add(new LigneCaVol(vp, caBillets, caPubs, caExtras, total, nbBillets, nbDiffs, dateDepart, heureDepart, pubsPayees, restePubs));
        }

        return lignes;
    }
}
