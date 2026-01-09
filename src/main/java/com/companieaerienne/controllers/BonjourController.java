package com.companieaerienne.controllers;

import com.companieaerienne.services.BonjourService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequestMapping("/bonjour")
@RequiredArgsConstructor
public class BonjourController {
    private final BonjourService bonjourService;
    @GetMapping("/liste")
    public ModelAndView showBonjour(){
        ModelAndView mv= new ModelAndView("bonjour/liste");
        mv.addObject("bonjours",bonjourService.getAll());
        return mv;
    }
}
