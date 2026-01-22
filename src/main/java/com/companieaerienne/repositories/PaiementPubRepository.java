package com.companieaerienne.repositories;

import com.companieaerienne.entities.PaiementPub;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDate;
import java.util.List;

public interface PaiementPubRepository extends JpaRepository<PaiementPub, Integer> {

    @Query("SELECT p.societe.nom, COALESCE(SUM(p.montant), 0) " +
            "FROM PaiementPub p " +
            "WHERE p.datePaiement >= :start AND p.datePaiement < :end " +
            "GROUP BY p.societe.nom " +
            "ORDER BY p.societe.nom")
    List<Object[]> sumMontantBySocieteBetween(@Param("start") LocalDate start, @Param("end") LocalDate end);
}
