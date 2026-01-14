package com.companieaerienne.controllers;

import com.companieaerienne.entities.Client;
import com.companieaerienne.entities.Reservation;
import com.companieaerienne.entities.VolProgrammation;
import com.companieaerienne.repositories.ClientRepository;
import com.companieaerienne.services.ReservationService;
import com.companieaerienne.services.VolProgrammationService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.ModelAndView;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

@Controller
@RequiredArgsConstructor
public class ReservationController {
    private final VolProgrammationService volProgrammationService;
    private final ClientRepository clientRepository;
    private final ReservationService reservationService;
    private final com.companieaerienne.repositories.VolProgrammationRepository volProgrammationRepository;
    private final com.companieaerienne.repositories.ReservationRepository reservationRepository;
    private final com.companieaerienne.repositories.ClassePlaceRepository classePlaceRepository;
    private final com.companieaerienne.repositories.TarifVolRepository tarifVolRepository;
    private final com.companieaerienne.repositories.ClasseRepository classeRepository;

    @GetMapping("/reservation/new")
    public ModelAndView showForm(@RequestParam("vpId") Integer vpId) {
        VolProgrammation vp = volProgrammationRepository.findById(vpId).orElse(null);
        if (vp == null) return new ModelAndView("redirect:/volsprogrammations");

        int restants = volProgrammationService.capaciteTotale(vp) - volProgrammationService.siegesReserves(vp);
        List<Client> passagers = clientRepository.findAll();
        java.util.List<com.companieaerienne.entities.Classe> classes = classePlaceRepository.findByAvion(vp.getAvion())
                .stream().map(com.companieaerienne.entities.ClassePlace::getClasse).toList();

        ModelAndView mv = new ModelAndView("layout");
        mv.addObject("pageTitle", "Réservation");
        mv.addObject("contentView", "/WEB-INF/jsp/reservations/form.jsp");
        mv.addObject("vp", vp);
        mv.addObject("restants", restants);
        mv.addObject("passagers", passagers);
        mv.addObject("classes", classes);
        return mv;
    }

    @GetMapping("/reservations")
    public ModelAndView listReservations(@RequestParam(value = "vpId", required = false) Integer vpId) {
        java.util.List<com.companieaerienne.entities.VolProgrammation> vols = volProgrammationRepository.findAll();
        java.util.List<com.companieaerienne.entities.Reservation> resList = java.util.Collections.emptyList();
        com.companieaerienne.entities.VolProgrammation selected = null;
        if (vpId != null) {
            selected = volProgrammationRepository.findById(vpId).orElse(null);
            if (selected != null) {
                resList = reservationRepository.findByVolProgrammation(selected);
            }
        }
        ModelAndView mv = new ModelAndView("layout");
        mv.addObject("pageTitle", "Liste réservations");
        mv.addObject("contentView", "/WEB-INF/jsp/reservations/list.jsp");
        mv.addObject("vols", vols);
        mv.addObject("reservations", resList);
        mv.addObject("selectedVp", selected);
        return mv;
    }

    @PostMapping("/reservation/create")
    public ModelAndView createReservation(@RequestParam Integer vpId,
                                          @RequestParam Integer clientId,
                                          @RequestParam Integer classeId,
                                          @RequestParam Integer nombrePlaces) {
        VolProgrammation vp = volProgrammationRepository.findById(vpId).orElse(null);
        if (vp == null) return new ModelAndView("redirect:/volsprogrammations");

        // Vérifier le tarif pour la classe sélectionnée
        com.companieaerienne.entities.Classe classe = classeRepository.findById(classeId).orElse(null);
        if (classe == null) {
            ModelAndView err = new ModelAndView("layout");
            err.addObject("pageTitle", "Erreur");
            err.addObject("contentView", "/WEB-INF/jsp/reservations/error.jsp");
            return err;
        }
        java.util.Optional<com.companieaerienne.entities.TarifVol> tv = tarifVolRepository.findByVolProgrammationAndClasse(vp, classe);
        if (tv.isEmpty()) {
            ModelAndView err = new ModelAndView("layout");
            err.addObject("pageTitle", "Tarif indisponible");
            err.addObject("contentView", "/WEB-INF/jsp/reservations/error.jsp");
            return err;
        }

        BigDecimal total = tv.get().getTarif().multiply(BigDecimal.valueOf(nombrePlaces));
        Optional<Reservation> created = reservationService.createReservation(vpId, clientId, nombrePlaces);

        ModelAndView mv = new ModelAndView("layout");
        if (created.isPresent()) {
            mv.addObject("pageTitle", "Confirmation");
            mv.addObject("contentView", "/WEB-INF/jsp/reservations/confirm.jsp");
            mv.addObject("reservation", created.get());
            mv.addObject("tarif", tv.get().getTarif());
            mv.addObject("total", total);
        } else {
            mv.addObject("pageTitle", "Erreur");
            mv.addObject("contentView", "/WEB-INF/jsp/reservations/error.jsp");
        }
        return mv;
    }
}
