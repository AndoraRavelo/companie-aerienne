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
@Table(name = "vol")
public class Vol {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne
    @JoinColumn(name = "id_aeroport_depart")
    private Aeroport aeroportDepart;

    @ManyToOne
    @JoinColumn(name = "id_aeroport_arrivee")
    private Aeroport aeroportArrivee;

    @Column(name = "duree", precision = 5, scale = 2)
    private BigDecimal duree;
}
