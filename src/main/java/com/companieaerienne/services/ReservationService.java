package com.companieaerienne.services;

import com.companieaerienne.entities.*;
import com.companieaerienne.repositories.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
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

    @Transactional
    public Optional<Reservation> createReservation(Integer volProgrammationId, Integer clientId, Integer classeId, int nombrePlaces) {
        VolProgrammation vp = volProgrammationRepository.findById(volProgrammationId).orElse(null);
        Client client = clientRepository.findById(clientId).orElse(null);
        Classe classe = classeRepository.findById(classeId).orElse(null);
        if (vp == null || client == null || classe == null) return Optional.empty();

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

}
