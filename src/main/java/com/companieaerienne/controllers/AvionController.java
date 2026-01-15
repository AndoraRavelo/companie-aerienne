package com.companieaerienne.controllers;

import com.companieaerienne.services.AvionService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequiredArgsConstructor

//TODO : rajouter un filtre par avion
public class AvionController {

    private final AvionService avionService;

    /**
     * Affiche la liste des avions.
     */
    @GetMapping("/avions")
    public ModelAndView listAvions() {
        ModelAndView mv = new ModelAndView("layout");
        mv.addObject("pageTitle", "Avions");
        mv.addObject("contentView", "/WEB-INF/jsp/avions/list.jsp");
        mv.addObject("avions", avionService.getAll());
        return mv;
    }
}
