package com.companieaerienne.controllers;

import com.companieaerienne.entities.Client;
import com.companieaerienne.entities.ProduitExtra;
import com.companieaerienne.entities.VolProgrammation;
import com.companieaerienne.repositories.ProduitExtraRepository;
import com.companieaerienne.repositories.VolProgrammationRepository;
import com.companieaerienne.services.AchatExtraService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

@Controller
@RequiredArgsConstructor
public class AchatExtraController {

    private final VolProgrammationRepository volProgrammationRepository;
    private final ProduitExtraRepository produitExtraRepository;
    private final AchatExtraService achatExtraService;

    public record VpOption(Integer id, String label) {
    }

    @GetMapping("/extras/achats/new")
    public ModelAndView form(@RequestParam(value = "vpId", required = false) Integer vpId) {
        ModelAndView mv = new ModelAndView("layout");
        mv.addObject("pageTitle", "Achat produits extra");
        mv.addObject("contentView", "/WEB-INF/jsp/extras/achats/new.jsp");

        List<VolProgrammation> vps = volProgrammationRepository.findAll();
        vps.sort((a, b) -> {
            if (a == null && b == null) return 0;
            if (a == null) return 1;
            if (b == null) return -1;
            if (a.getDateHeure() == null && b.getDateHeure() == null) return 0;
            if (a.getDateHeure() == null) return 1;
            if (b.getDateHeure() == null) return -1;
            return a.getDateHeure().compareTo(b.getDateHeure());
        });

        DateTimeFormatter df = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
        List<VpOption> vpOptions = new ArrayList<>();
        for (VolProgrammation vp : vps) {
            if (vp == null || vp.getId() == null) continue;
            String dep = vp.getVol() != null && vp.getVol().getAeroportDepart() != null ? vp.getVol().getAeroportDepart().getNom() : "?";
            String arr = vp.getVol() != null && vp.getVol().getAeroportArrivee() != null ? vp.getVol().getAeroportArrivee().getNom() : "?";
            String date = vp.getDateHeure() != null ? vp.getDateHeure().format(df) : "(sans date)";
            vpOptions.add(new VpOption(vp.getId(), dep + " -> " + arr + " | " + date));
        }
        mv.addObject("vpOptions", vpOptions);
        mv.addObject("vpId", vpId);

        VolProgrammation selectedVp = null;
        if (vpId != null) {
            selectedVp = volProgrammationRepository.findById(vpId).orElse(null);
        }
        mv.addObject("selectedVp", selectedVp);

        if (selectedVp != null) {
            List<Client> clients = achatExtraService.tousLesClients();
            mv.addObject("clients", clients);

            List<ProduitExtra> produits = produitExtraRepository.findByActifTrueOrderByLibelleAsc();
            mv.addObject("produits", produits);
        }

        return mv;
    }

    @PostMapping("/extras/achats")
    public ModelAndView create(@RequestParam("vpId") Integer vpId,
                               @RequestParam("clientId") Integer clientId,
                               @RequestParam(value = "produitId", required = false) List<Integer> produitIds,
                               @RequestParam(value = "quantite", required = false) List<Integer> quantites) {
        try {
            achatExtraService.creerAchat(vpId, clientId, produitIds, quantites);
            return new ModelAndView("redirect:/extras/achats/new?vpId=" + vpId);
        } catch (Exception e) {
            ModelAndView mv = form(vpId);
            mv.addObject("error", e.getMessage());
            return mv;
        }
    }
}
