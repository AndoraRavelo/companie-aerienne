package com.companieaerienne.repositories;

import com.companieaerienne.entities.VolProgrammation;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface VolProgrammationRepository extends JpaRepository<VolProgrammation, Integer> {

    @Query("SELECT vp FROM VolProgrammation vp " +
            "WHERE vp.vol.aeroportDepart.nom = :dep " +
            "AND vp.vol.aeroportArrivee.nom = :arr " +
            "ORDER BY vp.dateHeure")
    List<VolProgrammation> findByRouteNoms(@Param("dep") String departNom, @Param("arr") String arriveNom);
}
