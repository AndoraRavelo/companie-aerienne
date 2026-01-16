package com.companieaerienne.entities;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "categorie_type")
public class CategorieType {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "code", length = 30, nullable = false, unique = true)
    private String code;

    @Column(name = "nom", length = 50, nullable = false)
    private String nom;
}
