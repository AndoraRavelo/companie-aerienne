package com.companieaerienne.entities;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "classe_place")
@IdClass(ClassePlaceId.class)
public class ClassePlace {
    @Id
    @ManyToOne
    @JoinColumn(name = "id_classe")
    private Classe classe;

    @Column(name = "place_debut")
    private Integer placeDebut;

    @Column(name = "place_fin")
    private Integer placeFin;

    @Id
    @ManyToOne
    @JoinColumn(name = "id_avion")
    private Avion avion;
}
