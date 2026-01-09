package com.companieaerienne.services;

import com.companieaerienne.entities.Equipage;
import com.companieaerienne.repositories.EquipageRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class EquipageService {
    private final EquipageRepository equipageRepository;

    public List<Equipage> getAll() {
        return equipageRepository.findAll();
    }
}
