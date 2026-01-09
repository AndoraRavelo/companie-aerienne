package com.companieaerienne.repositories;

import com.companieaerienne.entities.Vol;
import org.springframework.data.jpa.repository.JpaRepository;

public interface VolRepository extends JpaRepository<Vol, Integer> {
}
