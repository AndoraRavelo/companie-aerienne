package com.companieaerienne.controllers;

import com.companieaerienne.entities.Passager;
import com.companieaerienne.entities.Reservation;
import com.companieaerienne.entities.VolProgramme;
import com.companieaerienne.repositories.PassagerRepository;
import com.companieaerienne.services.ReservationService;
import com.companieaerienne.services.VolProgrammeService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.ModelAndView;
import java.util.List;
import java.util.Optional;

@Controller
@RequiredArgsConstructor
public class ReservationController {
    private final VolProgrammeService volProgrammeService;
    private final PassagerRepository passagerRepository;
    private final ReservationService reservationService;
    private final com.companieaerienne.repositories.VolProgrammeRepository volProgrammeRepository;
    private final com.companieaerienne.repositories.ReservationRepository reservationRepository;

    

    @GetMapping("/reservation/new")
    public ModelAndView showForm(@RequestParam("vpId") Integer vpId) {
        VolProgramme vp = volProgrammeService.findAll().stream()
                .filter(v -> v.getId().equals(vpId)).findFirst().orElse(null);
        if (vp == null) return new ModelAndView("redirect:/volsprogrammes");

        int restants = volProgrammeService.capaciteTotale(vp) - volProgrammeService.siegesReserves(vp);
        List<Passager> passagers = passagerRepository.findAll();

        ModelAndView mv = new ModelAndView("layout");
        mv.addObject("pageTitle", "Réservation");
        mv.addObject("contentView", "/WEB-INF/jsp/reservations/form.jsp");
        mv.addObject("vp", vp);
        mv.addObject("restants", restants);
        mv.addObject("passagers", passagers);
        return mv;
    }

    @GetMapping("/reservations")
    public ModelAndView listReservations(@RequestParam(value = "vpId", required = false) Integer vpId) {
        java.util.List<com.companieaerienne.entities.VolProgramme> vols = volProgrammeRepository.findAll();
        java.util.List<com.companieaerienne.entities.Reservation> resList = java.util.Collections.emptyList();
        java.math.BigDecimal total = java.math.BigDecimal.ZERO;
        com.companieaerienne.entities.VolProgramme selected = null;
        if (vpId != null) {
            selected = volProgrammeRepository.findById(vpId).orElse(null);
            if (selected != null) {
                resList = reservationRepository.findByVolProgramme(selected);
                total = reservationRepository.sumPrixByVolProgramme(selected);
            }
        }
        ModelAndView mv = new ModelAndView("layout");
        mv.addObject("pageTitle", "Liste réservations");
        mv.addObject("contentView", "/WEB-INF/jsp/reservations/list.jsp");
        mv.addObject("vols", vols);
        mv.addObject("reservations", resList);
        mv.addObject("total", total);
        mv.addObject("selectedVp", selected);
        return mv;
    }

    @PostMapping("/reservation/create")
    public ModelAndView createReservation(@RequestParam Integer vpId,
                                          @RequestParam Integer passagerId,
                                          @RequestParam Integer sieges) {
        VolProgramme vp = volProgrammeService.findAll().stream()
                .filter(v -> v.getId().equals(vpId)).findFirst().orElse(null);
        if (vp == null) return new ModelAndView("redirect:/volsprogrammes");

        Optional<Reservation> created = reservationService.createReservation(vpId, passagerId, sieges);

        ModelAndView mv = new ModelAndView("layout");
        if (created.isPresent()) {
            mv.addObject("pageTitle", "Confirmation");
            mv.addObject("contentView", "/WEB-INF/jsp/reservations/confirm.jsp");
            mv.addObject("reservation", created.get());
        } else {
            mv.addObject("pageTitle", "Erreur");
            mv.addObject("contentView", "/WEB-INF/jsp/reservations/error.jsp");
        }
        return mv;
    }
}
