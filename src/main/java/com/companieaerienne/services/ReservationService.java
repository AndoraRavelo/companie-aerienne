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

    @Transactional
    public Optional<Reservation> createReservation(Integer volProgrammationId, Integer clientId, int nombrePlaces) {
        VolProgrammation vp = volProgrammationRepository.findById(volProgrammationId).orElse(null);
        Client client = clientRepository.findById(clientId).orElse(null);
        if (vp == null || client == null) return Optional.empty();

        int restante = volProgrammationService.capaciteTotale(vp) - volProgrammationService.siegesReserves(vp);
        if (nombrePlaces > restante) return Optional.empty();

        Reservation res = new Reservation();
        res.setVolProgrammation(vp);
        res.setClient(client);
        res.setNombrePlaces(nombrePlaces);
        // Optionnel: garder une date en mémoire si nécessaire
        res.setDateResa(Instant.now());
        reservationRepository.save(res);

        return Optional.of(res);
    }

}
