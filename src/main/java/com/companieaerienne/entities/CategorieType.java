package com.companieaerienne.entities;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;

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

    @Column(name = "base_code", length = 30)
    private String baseCode;

    @Column(name = "coefficient", precision = 10, scale = 4)
    private BigDecimal coefficient;
}
