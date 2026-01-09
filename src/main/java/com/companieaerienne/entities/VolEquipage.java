package com.companieaerienne.entities;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "vol_equipage")
public class VolEquipage {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(optional = false)
    @JoinColumn(name = "vol_programme_id")
    private VolProgramme volProgramme;

    @ManyToOne(optional = false)
    @JoinColumn(name = "equipage_id")
    private Equipage equipage;

    @Column(name = "role_sur_vol", length = 30, nullable = false)
    private String roleSurVol;
}
