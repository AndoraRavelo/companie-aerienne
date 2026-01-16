package com.companieaerienne.entities;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "reservation_place")
@IdClass(ReservationPlaceId.class)
public class ReservationPlace {
    @Id
    @ManyToOne
    @JoinColumn(name = "id_vol_programmation")
    private VolProgrammation volProgrammation;

    @Id
    @Column(name = "place")
    private Integer place;

    @ManyToOne
    @JoinColumn(name = "id_reservation")
    private Reservation reservation;

    @ManyToOne(optional = false)
    @JoinColumn(name = "id_categorie_type")
    private CategorieType categorieType;
}
