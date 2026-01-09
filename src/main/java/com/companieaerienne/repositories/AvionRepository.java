package com.companieaerienne.repositories;

import com.companieaerienne.entities.Avion;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AvionRepository extends JpaRepository<Avion, Integer> {
}
