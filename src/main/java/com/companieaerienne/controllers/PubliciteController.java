package com.companieaerienne.controllers;

import com.companieaerienne.entities.Societe;
import com.companieaerienne.repositories.SocieteRepository;
import com.companieaerienne.services.PubliciteService;
import com.companieaerienne.services.FacturationPubService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@Controller
@RequiredArgsConstructor
public class PubliciteController {

    private final PubliciteService publiciteService;
    private final SocieteRepository societeRepository;
    private final FacturationPubService facturationPubService;

    @GetMapping("/publicites/ca")
    public ModelAndView chiffreAffaires(@RequestParam(value = "annee", required = false) Integer annee,
                                        @RequestParam(value = "mois", required = false) Integer mois) {
        LocalDate now = LocalDate.now();
        int y = annee != null ? annee : now.getYear();
        int m = mois != null ? mois : now.getMonthValue();

        ModelAndView mv = new ModelAndView("layout");
        mv.addObject("pageTitle", "Publicités - Chiffre d'affaires");
        mv.addObject("contentView", "/WEB-INF/jsp/publicites/ca.jsp");
        mv.addObject("annee", y);
        mv.addObject("mois", m);

        if (annee != null && mois != null) {
            try {
                PubliciteService.RapportCaPublicite rapport = publiciteService.rapportMensuel(y, m);
                mv.addObject("rapport", rapport);
                mv.addObject("lignes", rapport.lignes());
                mv.addObject("ca", rapport.total());
                mv.addObject("prixUnitaire", rapport.prixUnitaire());
            } catch (Exception e) {
                mv.addObject("error", e.getMessage());
            }
        }

        return mv;
    }

    @GetMapping("/publicites/paiements/new")
    public ModelAndView newPaiementPub(@RequestParam(value = "success", required = false) String success,
                                       @RequestParam(value = "annee", required = false) Integer annee,
                                       @RequestParam(value = "mois", required = false) Integer mois) {
        ModelAndView mv = new ModelAndView("layout");
        mv.addObject("pageTitle", "Publicités - Paiement");
        mv.addObject("contentView", "/WEB-INF/jsp/publicites/paiement_form.jsp");

        List<Societe> societes = societeRepository.findAll();
        societes.sort((a, b) -> {
            String an = a != null && a.getNom() != null ? a.getNom() : "";
            String bn = b != null && b.getNom() != null ? b.getNom() : "";
            return an.compareToIgnoreCase(bn);
        });
        mv.addObject("societes", societes);

        LocalDate now = LocalDate.now();
        mv.addObject("datePaiement", now.toString());
        mv.addObject("annee", annee != null ? annee : now.getYear());
        mv.addObject("mois", mois != null ? mois : now.getMonthValue());

        if (success != null) {
            mv.addObject("success", "Paiement enregistré avec succès.");
        }
        return mv;
    }

    @PostMapping("/publicites/paiements/create")
    public ModelAndView createPaiementPub(@RequestParam("societeId") Integer societeId,
                                          @RequestParam("annee") Integer annee,
                                          @RequestParam("mois") Integer mois,
                                          @RequestParam("datePaiement") String datePaiement,
                                          @RequestParam("montant") String montant) {
        ModelAndView mv = new ModelAndView("layout");
        mv.addObject("pageTitle", "Publicités - Paiement");
        mv.addObject("contentView", "/WEB-INF/jsp/publicites/paiement_form.jsp");

        List<Societe> societes = societeRepository.findAll();
        societes.sort((a, b) -> {
            String an = a != null && a.getNom() != null ? a.getNom() : "";
            String bn = b != null && b.getNom() != null ? b.getNom() : "";
            return an.compareToIgnoreCase(bn);
        });
        mv.addObject("societes", societes);

        mv.addObject("societeId", societeId);
        mv.addObject("annee", annee);
        mv.addObject("mois", mois);
        mv.addObject("datePaiement", datePaiement);
        mv.addObject("montant", montant);

        Societe societe = societeId != null ? societeRepository.findById(societeId).orElse(null) : null;
        if (societe == null) {
            mv.addObject("error", "Société invalide.");
            return mv;
        }

        LocalDate dp;
        try {
            dp = LocalDate.parse(datePaiement);
        } catch (Exception e) {
            mv.addObject("error", "Date de paiement invalide.");
            return mv;
        }

        if (annee == null || annee < 2000 || annee > 2100) {
            mv.addObject("error", "Année invalide.");
            return mv;
        }
        if (mois == null || mois < 1 || mois > 12) {
            mv.addObject("error", "Mois invalide.");
            return mv;
        }

        BigDecimal m;
        try {
            String normalized = montant != null ? montant.trim().replace(',', '.') : "";
            m = new BigDecimal(normalized);
        } catch (Exception e) {
            mv.addObject("error", "Montant invalide.");
            return mv;
        }

        if (m.compareTo(BigDecimal.ZERO) <= 0) {
            mv.addObject("error", "Le montant doit être supérieur à 0.");
            return mv;
        }

        try {
            // Génère ou charge la facture mensuelle (si aucun paiement, elle est (re)générée à partir des diffusions)
            com.companieaerienne.entities.FacturePub facture = facturationPubService
                    .genererOuMettreAJourFactureMensuelle(societe, annee, mois);

            facturationPubService.enregistrerPaiementEtAffecter(facture, dp, m);
        } catch (Exception e) {
            mv.addObject("error", e.getMessage());
            return mv;
        }

        return new ModelAndView("redirect:/publicites/paiements/new?success=1&annee=" + annee + "&mois=" + mois);
    }
}
