package com.companieaerienne.repositories;

import com.companieaerienne.entities.Classe;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface ClasseRepository extends JpaRepository<Classe, Integer> {

    Optional<Classe> findByNomIgnoreCase(String nom);
}
