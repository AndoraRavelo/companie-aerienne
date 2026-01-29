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

    @Query("SELECT COALESCE(SUM(d.nombreDiffusions), 0) FROM DiffusionPub d WHERE d.volProgrammation = :vp")
    Integer sumNombreDiffusionsByVolProgrammation(@Param("vp") com.companieaerienne.entities.VolProgrammation vp);

    @Query("SELECT d.videoPublicitaire.societe.nom, COALESCE(SUM(d.nombreDiffusions), 0) " +
            "FROM DiffusionPub d " +
            "WHERE d.volProgrammation.dateHeure >= :start AND d.volProgrammation.dateHeure < :end " +
            "GROUP BY d.videoPublicitaire.societe.nom " +
            "ORDER BY d.videoPublicitaire.societe.nom")
    List<Object[]> sumNombreDiffusionsBySocieteBetween(@Param("start") LocalDateTime start, @Param("end") LocalDateTime end);

    @Query("SELECT d.volProgrammation, COALESCE(SUM(d.nombreDiffusions), 0) " +
            "FROM DiffusionPub d " +
            "WHERE d.videoPublicitaire.societe = :societe " +
            "AND d.volProgrammation.dateHeure >= :start AND d.volProgrammation.dateHeure < :end " +
            "GROUP BY d.volProgrammation " +
            "ORDER BY d.volProgrammation.dateHeure")
    List<Object[]> sumNombreDiffusionsBySocieteAndVolBetween(@Param("societe") com.companieaerienne.entities.Societe societe,
                                                            @Param("start") LocalDateTime start,
                                                            @Param("end") LocalDateTime end);
}
