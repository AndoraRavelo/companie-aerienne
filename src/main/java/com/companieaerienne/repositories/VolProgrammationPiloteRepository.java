package com.companieaerienne.repositories;

import com.companieaerienne.entities.VolProgrammationPilote;
import com.companieaerienne.entities.VolProgrammationPiloteId;
import org.springframework.data.jpa.repository.JpaRepository;

public interface VolProgrammationPiloteRepository extends JpaRepository<VolProgrammationPilote, VolProgrammationPiloteId> {
}
