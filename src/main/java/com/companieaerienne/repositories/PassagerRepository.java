package com.companieaerienne.repositories;

import com.companieaerienne.entities.Passager;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PassagerRepository extends JpaRepository<Passager, Integer> {
}
