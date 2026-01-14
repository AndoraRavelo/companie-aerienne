package com.companieaerienne.services;

import com.companieaerienne.entities.VolProgrammation;
import com.companieaerienne.repositories.ReservationRepository;
import com.companieaerienne.repositories.VolProgrammationRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class VolProgrammationService {
    private final VolProgrammationRepository volProgrammationRepository;
    private final ReservationRepository reservationRepository;

    public List<VolProgrammation> findAll() {
        return volProgrammationRepository.findAll();
    }

    public int capaciteTotale(VolProgrammation vp) {
        return vp.getAvion() != null && vp.getAvion().getCapacite() != null ? vp.getAvion().getCapacite() : 0;
    }

    public int siegesReserves(VolProgrammation vp) {
        Integer sum = reservationRepository.sumPlacesByVolProgrammation(vp);
        return sum != null ? sum : 0;
    }
}
