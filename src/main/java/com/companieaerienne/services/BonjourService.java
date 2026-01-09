package com.companieaerienne.services;

import com.companieaerienne.entities.Bonjour;
import com.companieaerienne.repositories.BonjourRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class BonjourService {
    private final BonjourRepository bonjourRepository;
    public List<Bonjour> getAll(){
        return  bonjourRepository.findAll();
    }
}
