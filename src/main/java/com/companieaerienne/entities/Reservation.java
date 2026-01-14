package com.companieaerienne.entities;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.Instant;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "reservation")
public class Reservation {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(optional = false)
    @JoinColumn(name = "id_vol_programmation")
    private VolProgrammation volProgrammation;

    @ManyToOne(optional = false)
    @JoinColumn(name = "id_client")
    private Client client;

    @Column(name = "nombre_places", nullable = false)
    private Integer nombrePlaces;

    // Optionnel: conserver une date de création côté application
    @Transient
    private Instant dateResa;
}
