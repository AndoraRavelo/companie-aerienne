package com.companieaerienne.repositories;

import com.companieaerienne.entities.ReservationPlace;
import com.companieaerienne.entities.ReservationPlaceId;
import com.companieaerienne.entities.VolProgrammation;
import com.companieaerienne.entities.Reservation;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ReservationPlaceRepository extends JpaRepository<ReservationPlace, ReservationPlaceId> {
    List<ReservationPlace> findByVolProgrammation(VolProgrammation volProgrammation);
    boolean existsByVolProgrammationAndPlace(VolProgrammation volProgrammation, Integer place);
    List<ReservationPlace> findByReservation(Reservation reservation);
}
