package com.companieaerienne.controllers;

import com.companieaerienne.services.VolService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequiredArgsConstructor
public class VolController {

    private final VolService volService;

    @GetMapping("/vols")
    public ModelAndView listVols() {
        ModelAndView mv = new ModelAndView("layout");
        mv.addObject("pageTitle", "Vols");
        mv.addObject("contentView", "/WEB-INF/jsp/vols/list.jsp");
        mv.addObject("vols", volService.getAll());
        return mv;
    }
}
