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
@Table(name = "tarif_vol")
public class TarifVol {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne
    @JoinColumn(name = "id_vol_programmation")
    private VolProgrammation volProgrammation;

    @ManyToOne
    @JoinColumn(name = "id_classe")
    private Classe classe;

    @ManyToOne
    @JoinColumn(name = "id_categorie_type")
    private CategorieType categorieType;

    @Column(name = "tarif", precision = 10, scale = 2)
    private BigDecimal tarif;
}
