package com.companieaerienne.entities;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * Aéroport (IATA 3 lettres).
 */
@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "aeroport")
public class Aeroport {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "code_iata", length = 3, nullable = false, unique = true)
    private String codeIata;

    @Column(nullable = false, length = 100)
    private String nom;

    @Column(nullable = false, length = 100)
    private String ville;

    @Column(nullable = false, length = 100)
    private String pays;
}
