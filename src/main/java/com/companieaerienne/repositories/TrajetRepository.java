package com.companieaerienne.repositories;

import com.companieaerienne.entities.Trajet;
import org.springframework.data.jpa.repository.JpaRepository;

public interface TrajetRepository extends JpaRepository<Trajet, Integer> {
}
