package com.companieaerienne.controllers;

import com.companieaerienne.services.PubliciteService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import java.time.LocalDate;

@Controller
@RequiredArgsConstructor
public class PubliciteController {

    private final PubliciteService publiciteService;

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
}
