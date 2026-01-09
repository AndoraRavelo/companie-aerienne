package com.companieaerienne.services;

import com.companieaerienne.entities.*;
import com.companieaerienne.repositories.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class ReservationService {
    private final ReservationRepository reservationRepository;
    private final VolProgrammeService volProgrammeService;
    private final VolProgrammeRepository volProgrammeRepository;
    private final PassagerRepository passagerRepository;
    private final StatusReservationRepository statusReservationRepository;

    @Transactional
    public Optional<Reservation> createReservation(Integer volProgrammeId, Integer passagerId, int sieges, BigDecimal prix) {
        VolProgramme vp = volProgrammeRepository.findById(volProgrammeId).orElse(null);
        Passager passager = passagerRepository.findById(passagerId).orElse(null);
        if (vp == null || passager == null) return Optional.empty();

        int restante = volProgrammeService.capaciteTotale(vp) - volProgrammeService.siegesReserves(vp);
        if (sieges > restante) return Optional.empty();

        Reservation res = new Reservation();
        res.setCodeResa(generateCode());
        res.setVolProgramme(vp);
        res.setPassager(passager);
        res.setSieges(sieges);
        res.setPrix(prix);
        res.setDateResa(Instant.now());
        reservationRepository.save(res);

        // historique
        StatusReservation h = new StatusReservation();
        h.setReservation(res);
        h.setLibelle("confirmée");
        h.setDateStatut(Instant.now());
        statusReservationRepository.save(h);

        return Optional.of(res);
    }

    private String generateCode() {
        return "R" + System.currentTimeMillis() % 1_000_000;
    }
}
