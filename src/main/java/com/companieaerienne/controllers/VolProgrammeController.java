package com.companieaerienne.controllers;

import com.companieaerienne.entities.VolProgramme;
import com.companieaerienne.services.VolProgrammeService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestParam;
import com.companieaerienne.repositories.TrajetRepository;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.servlet.ModelAndView;

import java.util.List;
import java.util.stream.Collectors;

@Controller
@RequiredArgsConstructor
public class VolProgrammeController {

    private final VolProgrammeService volProgrammeService;
    private final TrajetRepository trajetRepository;

    @GetMapping("/volsprogrammes")
    public ModelAndView listVolsProgrammes(@RequestParam(value = "trajetId", required = false) Integer trajetId) {
                java.util.List<com.companieaerienne.entities.VolProgramme> source = volProgrammeService.findAll();
        if (trajetId != null) {
            source = source.stream().filter(vp -> vp.getTrajet().getId().equals(trajetId)).toList();
        }
        List<VolProgrammeInfo> infos = source
                .stream()
                .map(vp -> new VolProgrammeInfo(
                        vp,
                        volProgrammeService.capaciteTotale(vp),
                        volProgrammeService.siegesReserves(vp)))
                .collect(Collectors.toList());
        ModelAndView mv = new ModelAndView("layout");
        mv.addObject("pageTitle", "Vols programmés");
        mv.addObject("contentView", "/WEB-INF/jsp/volsprogrammes/list.jsp");
        mv.addObject("volsInfos", infos);
        mv.addObject("trajets", trajetRepository.findAll());
        return mv;
    }

    // DTO pour la vue
    public record VolProgrammeInfo(VolProgramme volProgramme, int capacite, int siegesReserves) {
        public int siegesRestants() {return capacite - siegesReserves;}
    }
}
