package com.companieaerienne.repositories;

import com.companieaerienne.entities.TarifDiffusionPub;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDate;
import java.util.Optional;

public interface TarifDiffusionPubRepository extends JpaRepository<TarifDiffusionPub, Integer> {

    @Query("SELECT t FROM TarifDiffusionPub t WHERE t.dateDebut <= :date AND (t.dateFin IS NULL OR t.dateFin >= :date) ORDER BY t.dateDebut DESC")
    java.util.List<TarifDiffusionPub> findActifsPourDate(@Param("date") LocalDate date);

    default Optional<TarifDiffusionPub> findTarifActifPourDate(LocalDate date) {
        java.util.List<TarifDiffusionPub> tarifs = findActifsPourDate(date);
        return tarifs == null || tarifs.isEmpty() ? Optional.empty() : Optional.of(tarifs.get(0));
    }
}
