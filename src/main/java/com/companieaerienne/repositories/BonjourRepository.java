package com.companieaerienne.repositories;

import com.companieaerienne.entities.Bonjour;
import org.springframework.data.jpa.repository.JpaRepository;

public interface BonjourRepository extends JpaRepository<Bonjour, Integer> {
}