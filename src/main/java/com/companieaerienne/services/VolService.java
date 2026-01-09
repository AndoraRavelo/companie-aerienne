package com.companieaerienne.services;

import com.companieaerienne.entities.Vol;
import com.companieaerienne.repositories.VolRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class VolService {
    private final VolRepository volRepository;

    public List<Vol> getAll() {
        return volRepository.findAll();
    }
}
