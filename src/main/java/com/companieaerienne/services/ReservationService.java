package com.companieaerienne.services;

import com.companieaerienne.entities.*;
import com.companieaerienne.repositories.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class ReservationService {
    private final ReservationRepository reservationRepository;
    private final VolProgrammationService volProgrammationService;
    private final VolProgrammationRepository volProgrammationRepository;
    private final ClientRepository clientRepository;
    private final ClasseRepository classeRepository;
    private final ClassePlaceRepository classePlaceRepository;
    private final ReservationPlaceRepository reservationPlaceRepository;
    private final CategorieTypeRepository categorieTypeRepository;

    @Transactional
    public Optional<Reservation> createReservation(Integer volProgrammationId, Integer clientId, Integer classeId, int nombrePlaces, int nombreEnfants) {
        VolProgrammation vp = volProgrammationRepository.findById(volProgrammationId).orElse(null);
        Client client = clientRepository.findById(clientId).orElse(null);
        Classe classe = classeRepository.findById(classeId).orElse(null);
        if (vp == null || client == null || classe == null) return Optional.empty();

        if (nombreEnfants < 0 || nombreEnfants > nombrePlaces) return Optional.empty();

        CategorieType adulte = categorieTypeRepository.findByCode("ADULTE").orElse(null);
        CategorieType enfant = categorieTypeRepository.findByCode("ENFANT").orElse(null);
        if (adulte == null || enfant == null) return Optional.empty();

        int restante = volProgrammationService.capaciteTotale(vp) - volProgrammationService.siegesReserves(vp);
        if (nombrePlaces > restante) return Optional.empty();

        Reservation res = new Reservation();
        res.setVolProgrammation(vp);
        res.setClient(client);
        res.setNombrePlaces(nombrePlaces);
        // Optionnel: garder une date en mémoire si nécessaire
        res.setDateResa(Instant.now());
        reservationRepository.save(res);

        // Auto-attribution de places dans la plage de la classe choisie
        Optional<ClassePlace> cpOpt = classePlaceRepository.findByClasseAndAvion(classe, vp.getAvion());
        if (cpOpt.isPresent()) {
            ClassePlace cp = cpOpt.get();
            int assigned = 0;
            for (int seat = cp.getPlaceDebut(); seat <= cp.getPlaceFin() && assigned < nombrePlaces; seat++) {
                boolean taken = reservationPlaceRepository.existsByVolProgrammationAndPlace(vp, seat);
                if (!taken) {
                    ReservationPlace rp = new ReservationPlace();
                    rp.setVolProgrammation(vp);
                    rp.setPlace(seat);
                    rp.setReservation(res);
                    rp.setClasse(classe);
                    rp.setCategorieType(assigned < nombreEnfants ? enfant : adulte);
                    reservationPlaceRepository.save(rp);
                    assigned++;
                }
            }
            if (assigned < nombrePlaces) {
                // rollback en cas d'impossibilité d'assigner toutes les places dans la classe
                throw new IllegalStateException("Places insuffisantes dans la classe sélectionnée");
            }
        }

        return Optional.of(res);
    }

    @Transactional
    public Optional<Reservation> createReservationMulti(Integer volProgrammationId,
                                                        Integer clientId,
                                                        Map<Integer, Integer> placesByClasseId,
                                                        Map<Integer, Integer> enfantsByClasseId) {
        VolProgrammation vp = volProgrammationRepository.findById(volProgrammationId).orElse(null);
        Client client = clientRepository.findById(clientId).orElse(null);
        if (vp == null || client == null) return Optional.empty();

        Map<Integer, Integer> safePlaces = placesByClasseId != null ? new LinkedHashMap<>(placesByClasseId) : new LinkedHashMap<>();
        Map<Integer, Integer> safeEnfants = enfantsByClasseId != null ? new LinkedHashMap<>(enfantsByClasseId) : new LinkedHashMap<>();

        int totalPlaces = 0;
        for (Map.Entry<Integer, Integer> e : safePlaces.entrySet()) {
            int qty = e.getValue() != null ? e.getValue() : 0;
            if (qty < 0) return Optional.empty();
            totalPlaces += qty;
        }
        if (totalPlaces <= 0) return Optional.empty();

        for (Map.Entry<Integer, Integer> e : safeEnfants.entrySet()) {
            int enfants = e.getValue() != null ? e.getValue() : 0;
            if (enfants < 0) return Optional.empty();
            int places = safePlaces.getOrDefault(e.getKey(), 0);
            if (enfants > places) return Optional.empty();
        }

        CategorieType adulte = categorieTypeRepository.findByCode("ADULTE").orElse(null);
        CategorieType enfant = categorieTypeRepository.findByCode("ENFANT").orElse(null);
        if (adulte == null || enfant == null) return Optional.empty();

        int restante = volProgrammationService.capaciteTotale(vp) - volProgrammationService.siegesReserves(vp);
        if (totalPlaces > restante) return Optional.empty();

        Reservation res = new Reservation();
        res.setVolProgrammation(vp);
        res.setClient(client);
        res.setNombrePlaces(totalPlaces);
        res.setDateResa(Instant.now());
        reservationRepository.save(res);

        for (Map.Entry<Integer, Integer> e : safePlaces.entrySet()) {
            Integer classeId = e.getKey();
            int qty = e.getValue() != null ? e.getValue() : 0;
            if (qty <= 0) continue;

            Classe classe = classeRepository.findById(classeId).orElse(null);
            if (classe == null) {
                throw new IllegalArgumentException("Classe invalide");
            }

            int nbEnfants = safeEnfants.getOrDefault(classeId, 0);

            Optional<ClassePlace> cpOpt = classePlaceRepository.findByClasseAndAvion(classe, vp.getAvion());
            if (cpOpt.isEmpty()) {
                throw new IllegalStateException("Plage de sièges introuvable pour la classe sélectionnée");
            }
            ClassePlace cp = cpOpt.get();

            int assigned = 0;
            for (int seat = cp.getPlaceDebut(); seat <= cp.getPlaceFin() && assigned < qty; seat++) {
                boolean taken = reservationPlaceRepository.existsByVolProgrammationAndPlace(vp, seat);
                if (!taken) {
                    ReservationPlace rp = new ReservationPlace();
                    rp.setVolProgrammation(vp);
                    rp.setPlace(seat);
                    rp.setReservation(res);
                    rp.setClasse(classe);
                    rp.setCategorieType(assigned < nbEnfants ? enfant : adulte);
                    reservationPlaceRepository.save(rp);
                    assigned++;
                }
            }

            if (assigned < qty) {
                throw new IllegalStateException("Places insuffisantes dans la classe sélectionnée");
            }
        }

        return Optional.of(res);
    }

    @Transactional
    public Optional<Reservation> createReservationMultiWithCategories(Integer volProgrammationId,
                                                                      Integer clientId,
                                                                      Map<Integer, Integer> placesByClasseId,
                                                                      Map<Integer, Map<String, Integer>> quantitesParCategorieParClasseId) {
        VolProgrammation vp = volProgrammationRepository.findById(volProgrammationId).orElse(null);
        Client client = clientRepository.findById(clientId).orElse(null);
        if (vp == null || client == null) return Optional.empty();

        Map<Integer, Integer> safePlaces = placesByClasseId != null ? new LinkedHashMap<>(placesByClasseId) : new LinkedHashMap<>();
        Map<Integer, Map<String, Integer>> safeCats = quantitesParCategorieParClasseId != null
                ? new LinkedHashMap<>(quantitesParCategorieParClasseId)
                : new LinkedHashMap<>();

        int totalPlaces = 0;
        for (Map.Entry<Integer, Integer> e : safePlaces.entrySet()) {
            int qty = e.getValue() != null ? e.getValue() : 0;
            if (qty < 0) return Optional.empty();
            totalPlaces += qty;
        }
        if (totalPlaces <= 0) return Optional.empty();

        CategorieType adulte = categorieTypeRepository.findByCode("ADULTE").orElse(null);
        if (adulte == null) return Optional.empty();

        int restante = volProgrammationService.capaciteTotale(vp) - volProgrammationService.siegesReserves(vp);
        if (totalPlaces > restante) return Optional.empty();

        Reservation res = new Reservation();
        res.setVolProgrammation(vp);
        res.setClient(client);
        res.setNombrePlaces(totalPlaces);
        res.setDateResa(Instant.now());
        reservationRepository.save(res);

        for (Map.Entry<Integer, Integer> e : safePlaces.entrySet()) {
            Integer classeId = e.getKey();
            int qty = e.getValue() != null ? e.getValue() : 0;
            if (qty <= 0) continue;

            Classe classe = classeRepository.findById(classeId).orElse(null);
            if (classe == null) {
                throw new IllegalArgumentException("Classe invalide");
            }

            Optional<ClassePlace> cpOpt = classePlaceRepository.findByClasseAndAvion(classe, vp.getAvion());
            if (cpOpt.isEmpty()) {
                throw new IllegalStateException("Plage de sièges introuvable pour la classe sélectionnée");
            }
            ClassePlace cp = cpOpt.get();

            Map<String, Integer> perClasse = safeCats.getOrDefault(classeId, new LinkedHashMap<>());
            int autres = 0;
            Map<CategorieType, Integer> resolved = new LinkedHashMap<>();
            for (Map.Entry<String, Integer> ce : perClasse.entrySet()) {
                String code = ce.getKey();
                int count = ce.getValue() != null ? ce.getValue() : 0;
                if (count <= 0) continue;
                if (code == null || code.isBlank()) continue;
                CategorieType ct = categorieTypeRepository.findByCode(code.trim()).orElse(null);
                if (ct == null) return Optional.empty();
                resolved.put(ct, count);
                autres += count;
            }
            if (autres > qty) return Optional.empty();
            int nbAdultes = Math.max(0, qty - autres);

            int assigned = 0;
            int assignedInCat = 0;
            CategorieType currentCat = null;
            int currentCatTarget = 0;

            java.util.Iterator<Map.Entry<CategorieType, Integer>> it = resolved.entrySet().iterator();
            if (it.hasNext()) {
                Map.Entry<CategorieType, Integer> first = it.next();
                currentCat = first.getKey();
                currentCatTarget = first.getValue();
            } else {
                currentCat = adulte;
                currentCatTarget = nbAdultes;
            }

            for (int seat = cp.getPlaceDebut(); seat <= cp.getPlaceFin() && assigned < qty; seat++) {
                boolean taken = reservationPlaceRepository.existsByVolProgrammationAndPlace(vp, seat);
                if (taken) continue;

                if (assignedInCat >= currentCatTarget) {
                    assignedInCat = 0;
                    if (it.hasNext()) {
                        Map.Entry<CategorieType, Integer> next = it.next();
                        currentCat = next.getKey();
                        currentCatTarget = next.getValue();
                    } else {
                        currentCat = adulte;
                        currentCatTarget = nbAdultes;
                    }
                }

                ReservationPlace rp = new ReservationPlace();
                rp.setVolProgrammation(vp);
                rp.setPlace(seat);
                rp.setReservation(res);
                rp.setClasse(classe);
                rp.setCategorieType(currentCat);
                reservationPlaceRepository.save(rp);
                assigned++;
                assignedInCat++;
            }

            if (assigned < qty) {
                throw new IllegalStateException("Places insuffisantes dans la classe sélectionnée");
            }
        }

        return Optional.of(res);
    }

}
