package com.companieaerienne.repositories;

import com.companieaerienne.entities.Societe;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface SocieteRepository extends JpaRepository<Societe, Integer> {
    Optional<Societe> findByNomIgnoreCase(String nom);
}
