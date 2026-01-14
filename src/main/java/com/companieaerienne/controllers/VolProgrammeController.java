package com.companieaerienne.controllers;

import com.companieaerienne.entities.VolProgrammation;
import com.companieaerienne.services.VolProgrammationService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.servlet.ModelAndView;

import java.util.List;

@Controller
@RequiredArgsConstructor
public class VolProgrammeController {

    private final VolProgrammationService volProgrammationService;
    private final com.companieaerienne.repositories.VolProgrammationRepository volProgrammationRepository;

    @GetMapping("/volsprogrammes")
    public ModelAndView listVolsProgrammes() {
        List<VolProgrammation> source = volProgrammationRepository.findAll();
        List<VolProgrammationInfo> infos = source.stream()
                .map(vp -> new VolProgrammationInfo(
                        vp,
                        volProgrammationService.capaciteTotale(vp),
                        volProgrammationService.siegesReserves(vp)))
                .toList();
        ModelAndView mv = new ModelAndView("layout");
        mv.addObject("pageTitle", "Vols programmés");
        mv.addObject("contentView", "/WEB-INF/jsp/volsprogrammes/list.jsp");
        mv.addObject("volsInfos", infos);
        return mv;
    }

    // DTO pour la vue
    public record VolProgrammationInfo(VolProgrammation vp, int capacite, int siegesReserves) {
        public int restants() {return capacite - siegesReserves;}
    }
}
