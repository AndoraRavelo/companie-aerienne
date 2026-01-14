package com.companieaerienne.services;

import com.companieaerienne.entities.VolProgramme;
import com.companieaerienne.repositories.VolAvionRepository;
import com.companieaerienne.repositories.VolProgrammeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class VolProgrammeService {
    private final VolProgrammeRepository volProgrammeRepository;
    private final VolAvionRepository volAvionRepository;

    public List<VolProgramme> findAll() {
        return volProgrammeRepository.findAll();
    }

    public int capaciteTotale(VolProgramme vp) {
        return volAvionRepository.findByVolProgramme(vp)
                .stream()
                .mapToInt(va -> va.getAvion().getCapacite())
                .sum();
    }

    public int siegesReserves(VolProgramme vp) {
        // Service legacy basé sur VolProgramme: la réservation est désormais gérée via VolProgrammation.
        // Pour compatibilité transitoire, on retourne 0 ici.
        return 0;
    }
}
