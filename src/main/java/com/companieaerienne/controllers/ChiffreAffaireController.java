package com.companieaerienne.controllers;

import com.companieaerienne.entities.Aeroport;
import com.companieaerienne.repositories.AeroportRepository;
import com.companieaerienne.repositories.FacturePubLigneRepository;
import com.companieaerienne.services.ChiffreAffairesVolService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@Controller
@RequiredArgsConstructor
public class ChiffreAffaireController {

    private final AeroportRepository aeroportRepository;
    private final ChiffreAffairesVolService chiffreAffairesVolService;
    private final FacturePubLigneRepository facturePubLigneRepository;

    public record PaiementSociete(String societe, BigDecimal montant) {
    }

    public record TotauxTable(Integer billetsVendus,
                              BigDecimal caBillets,
                              Integer diffusionsPubs,
                              BigDecimal caPubs,
                              BigDecimal caExtras,
                              BigDecimal pubsPayees,
                              BigDecimal restePubs,
                              BigDecimal caTotal) {
    }

    @GetMapping("/chiffre-affaire")
    public ModelAndView chiffreAffaire(@RequestParam(value = "depart", required = false) String depart,
                                       @RequestParam(value = "arrivee", required = false) String arrivee) {
        ModelAndView mv = new ModelAndView("layout");
        mv.addObject("pageTitle", "Chiffre d'affaire");
        mv.addObject("contentView", "/WEB-INF/jsp/chiffreaffaire/vols.jsp");

        List<Aeroport> aeroports = aeroportRepository.findAll();
        aeroports.sort((a, b) -> {
            String an = a != null && a.getNom() != null ? a.getNom() : "";
            String bn = b != null && b.getNom() != null ? b.getNom() : "";
            return an.compareToIgnoreCase(bn);
        });
        mv.addObject("aeroports", aeroports);

        mv.addObject("depart", depart != null ? depart : "");
        mv.addObject("arrivee", arrivee != null ? arrivee : "");

        if (depart != null && !depart.isBlank() && arrivee != null && !arrivee.isBlank()) {
            try {
                List<ChiffreAffairesVolService.LigneCaVol> lignes = chiffreAffairesVolService.rapportParRoute(depart, arrivee);
                mv.addObject("lignes", lignes);

                if (lignes != null && !lignes.isEmpty()) {
                    int totalBilletsVendus = 0;
                    int totalDiffusionsPubs = 0;
                    BigDecimal totalCaBillets = BigDecimal.ZERO;
                    BigDecimal totalCaPubs = BigDecimal.ZERO;
                    BigDecimal totalCaExtras = BigDecimal.ZERO;
                    BigDecimal totalPubsPayees = BigDecimal.ZERO;
                    BigDecimal totalRestePubs = BigDecimal.ZERO;
                    BigDecimal totalCaTotal = BigDecimal.ZERO;

                    BigDecimal caBilletsTotal = BigDecimal.ZERO;
                    BigDecimal caPubsTotal = BigDecimal.ZERO;
                    BigDecimal caExtrasTotal = BigDecimal.ZERO;

                    List<com.companieaerienne.entities.VolProgrammation> vols = new ArrayList<>();

                    for (ChiffreAffairesVolService.LigneCaVol l : lignes) {
                        if (l == null || l.vp() == null || l.vp().getDateHeure() == null) continue;

                        vols.add(l.vp());

                        if (l.montantBillets() != null) {
                            caBilletsTotal = caBilletsTotal.add(l.montantBillets());
                            totalCaBillets = totalCaBillets.add(l.montantBillets());
                        }
                        if (l.montantPublicites() != null) {
                            caPubsTotal = caPubsTotal.add(l.montantPublicites());
                            totalCaPubs = totalCaPubs.add(l.montantPublicites());
                        }
                        if (l.montantExtras() != null) {
                            caExtrasTotal = caExtrasTotal.add(l.montantExtras());
                            totalCaExtras = totalCaExtras.add(l.montantExtras());
                        }

                        if (l.billetsVendus() != null) {
                            totalBilletsVendus += l.billetsVendus();
                        }
                        if (l.diffusions() != null) {
                            totalDiffusionsPubs += l.diffusions();
                        }
                        if (l.montantPublicitesPayee() != null) {
                            totalPubsPayees = totalPubsPayees.add(l.montantPublicitesPayee());
                        }
                        if (l.restePublicites() != null) {
                            totalRestePubs = totalRestePubs.add(l.restePublicites());
                        }
                        if (l.montantTotal() != null) {
                            totalCaTotal = totalCaTotal.add(l.montantTotal());
                        }
                    }

                    mv.addObject("totauxTable", new TotauxTable(
                            totalBilletsVendus,
                            totalCaBillets,
                            totalDiffusionsPubs,
                            totalCaPubs,
                            totalCaExtras,
                            totalPubsPayees,
                            totalRestePubs,
                            totalCaTotal
                    ));

                    // IMPORTANT: le payé pubs ne dépend pas de date_paiement mais des affectations enregistrées.
                    // On lit donc facture_pub_ligne.montant_paye.
                    BigDecimal pubsPayees = BigDecimal.ZERO;
                    List<PaiementSociete> paiements = new ArrayList<>();
                    if (!vols.isEmpty()) {
                        for (com.companieaerienne.entities.VolProgrammation vp : vols) {
                            BigDecimal payeVp = facturePubLigneRepository.sumMontantPayeByVolProgrammation(vp);
                            if (payeVp != null) {
                                pubsPayees = pubsPayees.add(payeVp);
                            }
                        }

                        List<Object[]> rows = facturePubLigneRepository.sumMontantPayeBySocieteAndVolProgrammations(vols);
                        if (rows != null) {
                            for (Object[] r : rows) {
                                String societe = r[0] != null ? r[0].toString() : "(inconnue)";
                                BigDecimal montant = BigDecimal.ZERO;
                                if (r[1] instanceof BigDecimal) {
                                    montant = (BigDecimal) r[1];
                                } else if (r[1] instanceof Number) {
                                    montant = BigDecimal.valueOf(((Number) r[1]).doubleValue());
                                }
                                paiements.add(new PaiementSociete(societe, montant));
                            }
                        }
                    }

                    BigDecimal caTheorique = caBilletsTotal.add(caPubsTotal).add(caExtrasTotal);
                    BigDecimal caPaye = caBilletsTotal.add(pubsPayees).add(caExtrasTotal);
                    BigDecimal resteAPayer = caTheorique.subtract(caPaye);

                    mv.addObject("caBilletsTotal", caBilletsTotal);
                    mv.addObject("caDiffusionsTheorique", caPubsTotal);
                    mv.addObject("caExtrasTotal", caExtrasTotal);
                    mv.addObject("caTheorique", caTheorique);
                    mv.addObject("caPaye", caPaye);
                    mv.addObject("resteAPayer", resteAPayer);
                    mv.addObject("paiementsPubs", paiements);
                }
            } catch (Exception e) {
                mv.addObject("error", e.getMessage());
            }
        }

        return mv;
    }
}
