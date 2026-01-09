package com.companieaerienne.repositories;

import com.companieaerienne.entities.Aeroport;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AeroportRepository extends JpaRepository<Aeroport, Integer> {
}
