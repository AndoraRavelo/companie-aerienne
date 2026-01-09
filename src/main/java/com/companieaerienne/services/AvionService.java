package com.companieaerienne.services;

import com.companieaerienne.entities.Avion;
import com.companieaerienne.repositories.AvionRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class AvionService {
    private final AvionRepository avionRepository;

    public List<Avion> getAll() {
        return avionRepository.findAll();
    }
}
