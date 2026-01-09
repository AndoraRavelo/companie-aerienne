package com.companieaerienne.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class HomeController {

    @GetMapping({"/", "/home"})
    public ModelAndView home() {
        ModelAndView mv = new ModelAndView("layout");
        mv.addObject("pageTitle", "Accueil");
        mv.addObject("contentView", "/WEB-INF/jsp/home/index.jsp");
        return mv;
    }
}
