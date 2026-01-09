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

    @Column(name = "immatriculation", length = 10, nullable = false, unique = true)
    private String immatriculation;

    @Column(name = "modele", length = 50, nullable = false)
    private String modele;

    @Column(name = "capacite", nullable = false)
    private Integer capacite;

    @Column(name = "statut", length = 30, nullable = false)
    private String statut = "operationnel";
}
