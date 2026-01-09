package com.companieaerienne.entities;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "vol_avion")
public class VolAvion {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(optional = false)
    @JoinColumn(name = "vol_programme_id")
    private VolProgramme volProgramme;

    @ManyToOne(optional = false)
    @JoinColumn(name = "avion_id")
    private Avion avion;
}
