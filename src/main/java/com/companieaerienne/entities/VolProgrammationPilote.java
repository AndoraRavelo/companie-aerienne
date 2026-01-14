package com.companieaerienne.entities;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "vol_programmation_pilote")
@IdClass(VolProgrammationPiloteId.class)
public class VolProgrammationPilote {
    @Id
    @ManyToOne
    @JoinColumn(name = "id_vol_programmation")
    private VolProgrammation volProgrammation;

    @Id
    @ManyToOne
    @JoinColumn(name = "id_pilote")
    private Pilote pilote;

    @Column(name = "role", length = 30)
    private String role;
}
