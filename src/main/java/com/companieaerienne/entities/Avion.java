package com.companieaerienne.entities;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * Représente un aéronef de la flotte.
 */
@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "avion")
public class Avion {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;

    @Column(name = "matricule", length = 50)
    private String matricule;

    @Column(name = "capacite")
    private Integer capacite;
}
