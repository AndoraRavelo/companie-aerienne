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
@Table(name = "status_vol")
public class StatusVol {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(optional = false)
    @JoinColumn(name = "vol_programme_id")
    private VolProgramme volProgramme;

    @Column(length = 50, nullable = false)
    private String libelle;  // créé, embarquement, annulé, etc.

    @Column(name = "date_statut")
    private Instant dateStatut;
}
