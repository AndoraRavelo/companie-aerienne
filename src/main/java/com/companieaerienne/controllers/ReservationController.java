package com.companieaerienne.controllers;

import com.companieaerienne.entities.Client;
import com.companieaerienne.entities.Reservation;
import com.companieaerienne.entities.VolProgrammation;
import com.companieaerienne.repositories.ClientRepository;
import com.companieaerienne.repositories.TarifVolRepository;
import com.companieaerienne.repositories.VolProgrammationRepository;
import com.companieaerienne.services.ReservationService;
import com.companieaerienne.services.VolProgrammationService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Set;
import java.util.TreeSet;
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
        java.util.List<com.companieaerienne.entities.ClassePlace> ranges = classePlaceRepository.findByAvion(vp.getAvion());
        java.util.List<com.companieaerienne.entities.Classe> classes = ranges.stream()
                .map(com.companieaerienne.entities.ClassePlace::getClasse).toList();
        java.util.List<com.companieaerienne.entities.TarifVol> tarifs = tarifVolRepository.findByVolProgrammation(vp);

        Map<String, Integer> seatCounts = new LinkedHashMap<>();
        int totalSeats = 0;
        for (com.companieaerienne.entities.ClassePlace cp : ranges) {
            int start = cp.getPlaceDebut() != null ? cp.getPlaceDebut() : 0;
            int end = cp.getPlaceFin() != null ? cp.getPlaceFin() : -1;
            int count = end >= start ? (end - start + 1) : 0;
            String className = cp.getClasse() != null ? cp.getClasse().getNom() : "(inconnu)";
            seatCounts.put(className, seatCounts.getOrDefault(className, 0) + count);
            totalSeats += count;
        }

        BigDecimal maxRevenue = BigDecimal.ZERO;
        for (com.companieaerienne.entities.TarifVol tv : tarifs) {
            if (tv.getClasse() == null || tv.getTarif() == null) continue;
            String className = tv.getClasse().getNom();
            int seatsInClass = seatCounts.getOrDefault(className, 0);
            if (seatsInClass > 0) {
                maxRevenue = maxRevenue.add(tv.getTarif().multiply(BigDecimal.valueOf(seatsInClass)));
            }
        }

        Set<Integer> takenSeats = new TreeSet<>();
        for (com.companieaerienne.entities.ReservationPlace rp : reservationPlaceRepository.findByVolProgrammation(vp)) {
            if (rp.getPlace() != null) takenSeats.add(rp.getPlace());
        }

        Map<String, Integer> remainingSeatsByClass = new LinkedHashMap<>();
        if (ranges != null && !ranges.isEmpty()) {
            Map<String, Integer> takenSeatsByClass = new LinkedHashMap<>();
            for (com.companieaerienne.entities.ClassePlace cp : ranges) {
                String className = cp.getClasse() != null ? cp.getClasse().getNom() : "(inconnu)";
                takenSeatsByClass.putIfAbsent(className, 0);
                remainingSeatsByClass.putIfAbsent(className, 0);
            }
            for (Integer seat : takenSeats) {
                if (seat == null) continue;
                for (com.companieaerienne.entities.ClassePlace cp : ranges) {
                    Integer startObj = cp.getPlaceDebut();
                    Integer endObj = cp.getPlaceFin();
                    if (startObj == null || endObj == null) continue;
                    int start = startObj;
                    int end = endObj;
                    if (seat >= start && seat <= end) {
                        String className = cp.getClasse() != null ? cp.getClasse().getNom() : "(inconnu)";
                        takenSeatsByClass.put(className, takenSeatsByClass.getOrDefault(className, 0) + 1);
                        break;
                    }
                }
            }
            for (Map.Entry<String, Integer> e : seatCounts.entrySet()) {
                String className = e.getKey();
                int capacity = e.getValue() != null ? e.getValue() : 0;
                int taken = takenSeatsByClass.getOrDefault(className, 0);
                int remaining = Math.max(0, capacity - taken);
                remainingSeatsByClass.put(className, remaining);
            }
        }

        ModelAndView mv = new ModelAndView("layout");
        mv.addObject("pageTitle", "Réservation");
        mv.addObject("contentView", "/WEB-INF/jsp/reservations/form.jsp");
        mv.addObject("vp", vp);
        mv.addObject("restants", restants);
        mv.addObject("passagers", passagers);
        mv.addObject("classes", classes);
        mv.addObject("tarifs", tarifs);
        mv.addObject("seatCounts", seatCounts);
        mv.addObject("remainingSeatsByClass", remainingSeatsByClass);
        mv.addObject("totalSeats", totalSeats);
        mv.addObject("maxRevenue", maxRevenue);
        mv.addObject("takenSeats", takenSeats);
        return mv;
    }

    @GetMapping("/reservations")
    public ModelAndView listReservations(
            @RequestParam(value = "vpId", required = false) Integer vpId,
            @RequestParam(value = "route", required = false) String route,
            @RequestParam(value = "date", required = false) String date,
            @RequestParam(value = "time", required = false) String time
    ) {
        java.util.List<com.companieaerienne.entities.VolProgrammation> vols = volProgrammationRepository.findAll();
        vols.sort((a, b) -> {
            String aDep = a.getVol() != null && a.getVol().getAeroportDepart() != null ? a.getVol().getAeroportDepart().getNom() : "";
            String aArr = a.getVol() != null && a.getVol().getAeroportArrivee() != null ? a.getVol().getAeroportArrivee().getNom() : "";
            String bDep = b.getVol() != null && b.getVol().getAeroportDepart() != null ? b.getVol().getAeroportDepart().getNom() : "";
            String bArr = b.getVol() != null && b.getVol().getAeroportArrivee() != null ? b.getVol().getAeroportArrivee().getNom() : "";

            String aRoute = aDep + "->" + aArr;
            String bRoute = bDep + "->" + bArr;

            int routeCmp = aRoute.compareToIgnoreCase(bRoute);
            if (routeCmp != 0) return routeCmp;

            if (a.getDateHeure() == null && b.getDateHeure() == null) return 0;
            if (a.getDateHeure() == null) return 1;
            if (b.getDateHeure() == null) return -1;
            return a.getDateHeure().compareTo(b.getDateHeure());
        });

        // Options de filtre ergonomique: route + date + heure
        Map<String, String> routeOptions = new LinkedHashMap<>();
        for (com.companieaerienne.entities.VolProgrammation v : vols) {
            if (v.getVol() == null || v.getVol().getAeroportDepart() == null || v.getVol().getAeroportArrivee() == null) continue;
            if (v.getVol().getAeroportDepart().getId() == null || v.getVol().getAeroportArrivee().getId() == null) continue;
            String key = v.getVol().getAeroportDepart().getId() + "-" + v.getVol().getAeroportArrivee().getId();
            String label = v.getVol().getAeroportDepart().getNom() + " -> " + v.getVol().getAeroportArrivee().getNom();
            routeOptions.putIfAbsent(key, label);
        }

        LocalDate selectedDate = null;
        if (date != null && !date.isBlank()) {
            try {
                selectedDate = LocalDate.parse(date);
            } catch (Exception ignored) {
                selectedDate = null;
            }
        }

        LocalTime selectedTime = null;
        if (time != null && !time.isBlank()) {
            try {
                selectedTime = LocalTime.parse(time);
            } catch (Exception ignored) {
                selectedTime = null;
            }
        }

        Set<String> timeOptions = new TreeSet<>();
        if (route != null && !route.isBlank() && selectedDate != null) {
            DateTimeFormatter timeFmt = DateTimeFormatter.ofPattern("HH:mm");
            for (com.companieaerienne.entities.VolProgrammation v : vols) {
                if (v.getDateHeure() == null || v.getVol() == null || v.getVol().getAeroportDepart() == null || v.getVol().getAeroportArrivee() == null) continue;
                if (!v.getDateHeure().toLocalDate().equals(selectedDate)) continue;
                String vRoute = v.getVol().getAeroportDepart().getId() + "-" + v.getVol().getAeroportArrivee().getId();
                if (!route.equals(vRoute)) continue;
                timeOptions.add(v.getDateHeure().toLocalTime().format(timeFmt));
            }
        }

        // Si vpId n'est pas fourni, on essaye de le déduire depuis route+date+heure
        if (vpId == null && route != null && !route.isBlank() && selectedDate != null && selectedTime != null) {
            for (com.companieaerienne.entities.VolProgrammation v : vols) {
                if (v.getDateHeure() == null || v.getVol() == null || v.getVol().getAeroportDepart() == null || v.getVol().getAeroportArrivee() == null) continue;
                String vRoute = v.getVol().getAeroportDepart().getId() + "-" + v.getVol().getAeroportArrivee().getId();
                if (!route.equals(vRoute)) continue;
                if (!v.getDateHeure().toLocalDate().equals(selectedDate)) continue;
                if (!v.getDateHeure().toLocalTime().equals(selectedTime)) continue;
                vpId = v.getId();
                break;
            }
        }

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

                Map<String, Integer> seatCounts = new LinkedHashMap<>();
                int totalSeats = 0;
                for (com.companieaerienne.entities.ClassePlace cp : ranges) {
                    int start = cp.getPlaceDebut() != null ? cp.getPlaceDebut() : 0;
                    int end = cp.getPlaceFin() != null ? cp.getPlaceFin() : -1;
                    int count = end >= start ? (end - start + 1) : 0;
                    String className = cp.getClasse() != null ? cp.getClasse().getNom() : "(inconnu)";
                    seatCounts.put(className, seatCounts.getOrDefault(className, 0) + count);
                    totalSeats += count;
                }

                java.math.BigDecimal maxRevenue = java.math.BigDecimal.ZERO;
                for (com.companieaerienne.entities.TarifVol tv : tarifVolRepository.findByVolProgrammation(selected)) {
                    if (tv.getClasse() == null || tv.getTarif() == null) continue;
                    String className = tv.getClasse().getNom();
                    int seatsInClass = seatCounts.getOrDefault(className, 0);
                    if (seatsInClass > 0) {
                        maxRevenue = maxRevenue.add(tv.getTarif().multiply(java.math.BigDecimal.valueOf(seatsInClass)));
                    }
                }
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
                                lines.add(classeForSeat.getNom() + " : " + price);
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
                mv.addObject("seatCounts", seatCounts);
                mv.addObject("totalSeats", totalSeats);
                mv.addObject("maxRevenue", maxRevenue);
                mv.addObject("routeOptions", routeOptions);
                mv.addObject("selectedRoute", route);
                mv.addObject("selectedDate", selectedDate != null ? selectedDate.toString() : "");
                mv.addObject("timeOptions", timeOptions);
                mv.addObject("selectedTime", selectedTime != null ? selectedTime.toString() : "");
                return mv;
            }
        }
        ModelAndView mv = new ModelAndView("layout");
        mv.addObject("pageTitle", "Liste réservations");
        mv.addObject("contentView", "/WEB-INF/jsp/reservations/list.jsp");
        mv.addObject("vols", vols);
        mv.addObject("reservations", resList);
        mv.addObject("selectedVp", selected);
        mv.addObject("routeOptions", routeOptions);
        mv.addObject("selectedRoute", route);
        mv.addObject("selectedDate", selectedDate != null ? selectedDate.toString() : "");
        mv.addObject("timeOptions", timeOptions);
        mv.addObject("selectedTime", selectedTime != null ? selectedTime.toString() : "");
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
