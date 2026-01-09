package com.companieaerienne.repositories;

import com.companieaerienne.entities.StatusReservation;
import org.springframework.data.jpa.repository.JpaRepository;

public interface StatusReservationRepository extends JpaRepository<StatusReservation, Integer> {
}
