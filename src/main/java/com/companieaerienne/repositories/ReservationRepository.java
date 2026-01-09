package com.companieaerienne.repositories;

import com.companieaerienne.entities.Reservation;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface ReservationRepository extends JpaRepository<Reservation, Integer> {
    @Query("SELECT COALESCE(SUM(r.sieges),0) FROM Reservation r WHERE r.volProgramme = :vp")
    Integer sumSiegesByVolProgramme(@Param("vp") com.companieaerienne.entities.VolProgramme vp);

    java.util.Optional<Reservation> findByCodeResa(String codeResa);

    java.util.List<Reservation> findByVolProgramme(com.companieaerienne.entities.VolProgramme volProgramme);

    @Query("SELECT COALESCE(SUM(r.prix),0) FROM Reservation r WHERE r.volProgramme = :vp")
    java.math.BigDecimal sumPrixByVolProgramme(@Param("vp") com.companieaerienne.entities.VolProgramme vp);

}
