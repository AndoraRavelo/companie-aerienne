package com.companieaerienne.repositories;

import com.companieaerienne.entities.Reservation;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface ReservationRepository extends JpaRepository<Reservation, Integer> {

    @Query("SELECT COALESCE(SUM(r.sieges),0) FROM Reservation r WHERE r.volProgramme = :vp")
    Integer sumSiegesByVolProgramme(@Param("vp") com.companieaerienne.entities.VolProgramme vp);

}
