package com.companieaerienne.entities;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "trajet")
public class Trajet {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "code_trajet", length = 10, nullable = false, unique = true)
    private String codeTrajet;

    @ManyToOne(optional = false)
    @JoinColumn(name = "aeroport_depart_id")
    private Aeroport aeroportDepart;

    @ManyToOne(optional = false)
    @JoinColumn(name = "aeroport_arrivee_id")
    private Aeroport aeroportArrivee;
}
