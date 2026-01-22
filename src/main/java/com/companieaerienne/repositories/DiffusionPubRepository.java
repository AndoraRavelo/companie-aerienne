package com.companieaerienne.repositories;

import com.companieaerienne.entities.DiffusionPub;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDateTime;
import java.util.List;

public interface DiffusionPubRepository extends JpaRepository<DiffusionPub, Integer> {

    @Query("SELECT COALESCE(SUM(d.nombreDiffusions), 0) FROM DiffusionPub d WHERE d.volProgrammation.dateHeure >= :start AND d.volProgrammation.dateHeure < :end")
    Integer sumNombreDiffusionsBetween(@Param("start") LocalDateTime start, @Param("end") LocalDateTime end);

    @Query("SELECT d.videoPublicitaire.societe.nom, COALESCE(SUM(d.nombreDiffusions), 0) " +
            "FROM DiffusionPub d " +
            "WHERE d.volProgrammation.dateHeure >= :start AND d.volProgrammation.dateHeure < :end " +
            "GROUP BY d.videoPublicitaire.societe.nom " +
            "ORDER BY d.videoPublicitaire.societe.nom")
    List<Object[]> sumNombreDiffusionsBySocieteBetween(@Param("start") LocalDateTime start, @Param("end") LocalDateTime end);
}
