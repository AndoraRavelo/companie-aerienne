package com.companieaerienne.repositories;

import com.companieaerienne.entities.FacturePub;
import com.companieaerienne.entities.Societe;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface FacturePubRepository extends JpaRepository<FacturePub, Integer> {
    Optional<FacturePub> findBySocieteAndAnneeAndMois(Societe societe, Integer annee, Integer mois);

    List<FacturePub> findByAnneeAndMois(Integer annee, Integer mois);
}
