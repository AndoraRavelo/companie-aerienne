package com.companieaerienne.controllers;

import com.companieaerienne.services.EquipageService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequiredArgsConstructor
public class EquipageController {

    private final EquipageService equipageService;

    @GetMapping("/equipages")
    public ModelAndView listEquipages() {
        ModelAndView mv = new ModelAndView("layout");
        mv.addObject("pageTitle", "Equipages");
        mv.addObject("contentView", "/WEB-INF/jsp/equipages/list.jsp");
        mv.addObject("equipages", equipageService.getAll());
        return mv;
    }
}
