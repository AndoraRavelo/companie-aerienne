package com.companieaerienne.entities;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "equipage")
public class Equipage {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "nom_complet", nullable = false, length = 100)
    private String nomComplet;

    @Column(nullable = false, length = 30)
    private String role;

    @Column(length = 20)
    private String licence;

    @Column(name = "heures_vol")
    private Integer heuresVol;
}
