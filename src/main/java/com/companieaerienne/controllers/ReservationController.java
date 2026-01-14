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
    private final com.companieaerienne.repositories.ReservationPlaceRepository reservationPlaceRepository;

    @GetMapping("/reservation/new")
    public ModelAndView showForm(@RequestParam("vpId") Integer vpId) {
        VolProgrammation vp = volProgrammationRepository.findById(vpId).orElse(null);
        if (vp == null) return new ModelAndView("redirect:/volsprogrammations");

        int restants = volProgrammationService.capaciteTotale(vp) - volProgrammationService.siegesReserves(vp);
        List<Client> passagers = clientRepository.findAll();
        java.util.List<com.companieaerienne.entities.Classe> classes = classePlaceRepository.findByAvion(vp.getAvion())
                .stream().map(com.companieaerienne.entities.ClassePlace::getClasse).toList();
        java.util.List<com.companieaerienne.entities.TarifVol> tarifs = tarifVolRepository.findByVolProgrammation(vp);

        ModelAndView mv = new ModelAndView("layout");
        mv.addObject("pageTitle", "Réservation");
        mv.addObject("contentView", "/WEB-INF/jsp/reservations/form.jsp");
        mv.addObject("vp", vp);
        mv.addObject("restants", restants);
        mv.addObject("passagers", passagers);
        mv.addObject("classes", classes);
        mv.addObject("tarifs", tarifs);
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
                // Calcul de la recette totale: somme des tarifs par place réservée
                java.math.BigDecimal total = java.math.BigDecimal.ZERO;
                java.util.Map<Integer, java.util.List<String>> details = new java.util.HashMap<>();
                java.util.Map<Integer, java.math.BigDecimal> subtotals = new java.util.HashMap<>();
                java.util.List<com.companieaerienne.entities.ClassePlace> ranges =
                        classePlaceRepository.findByAvion(selected.getAvion());
                for (com.companieaerienne.entities.Reservation r : resList) {
                    java.util.List<String> lines = new java.util.ArrayList<>();
                    java.math.BigDecimal sub = java.math.BigDecimal.ZERO;
                    java.util.List<com.companieaerienne.entities.ReservationPlace> places =
                            reservationPlaceRepository.findByReservation(r);
                    for (com.companieaerienne.entities.ReservationPlace rp : places) {
                        // Trouver la classe correspondant à la place
                        com.companieaerienne.entities.Classe classeForSeat = null;
                        for (com.companieaerienne.entities.ClassePlace cp : ranges) {
                            if (rp.getPlace() >= cp.getPlaceDebut() && rp.getPlace() <= cp.getPlaceFin()) {
                                classeForSeat = cp.getClasse();
                                break;
                            }
                        }
                        if (classeForSeat != null) {
                            java.util.Optional<com.companieaerienne.entities.TarifVol> tvOpt =
                                    tarifVolRepository.findByVolProgrammationAndClasse(selected, classeForSeat);
                            if (tvOpt.isPresent()) {
                                java.math.BigDecimal price = tvOpt.get().getTarif();
                                total = total.add(price);
                                sub = sub.add(price);
                                lines.add("Place " + rp.getPlace() + " (" + classeForSeat.getNom() + ") : " + price);
                            }
                        }
                    }
                    details.put(r.getId(), lines);
                    subtotals.put(r.getId(), sub);
                }
                // Ajoute au modèle
                // (Affiché dans la vue s'il est présent)
                // Note: si aucune place n'est réservée, total = 0
                //       si certaines places n'ont pas de tarif trouvé, elles sont ignorées.
                //       On peut logguer ces cas si besoin.
                //
                // mv est créé plus bas, on stockera 'total' à ce moment.
                // Pour y accéder, on utilisera mv.addObject plus loin.
                // On passe par une variable finale pour le scope.
                java.math.BigDecimal computedTotal = total;
                // Crée la vue et injecte 'total' plus bas
                ModelAndView mv = new ModelAndView("layout");
                mv.addObject("pageTitle", "Liste réservations");
                mv.addObject("contentView", "/WEB-INF/jsp/reservations/list.jsp");
                mv.addObject("vols", vols);
                mv.addObject("reservations", resList);
                mv.addObject("selectedVp", selected);
                mv.addObject("total", computedTotal);
                mv.addObject("details", details);
                mv.addObject("subtotals", subtotals);
                return mv;
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
        Optional<Reservation> created = reservationService.createReservation(vpId, clientId, classeId, nombrePlaces);

        ModelAndView mv = new ModelAndView("layout");
        if (created.isPresent()) {
            mv.addObject("pageTitle", "Confirmation");
            mv.addObject("contentView", "/WEB-INF/jsp/reservations/confirm.jsp");
            mv.addObject("reservation", created.get());
            mv.addObject("tarif", tv.get().getTarif());
            mv.addObject("total", total);
            java.util.List<com.companieaerienne.entities.ReservationPlace> places =
                    reservationPlaceRepository.findByReservation(created.get());
            mv.addObject("places", places);
        } else {
            mv.addObject("pageTitle", "Erreur");
            mv.addObject("contentView", "/WEB-INF/jsp/reservations/error.jsp");
        }
        return mv;
    }
}
