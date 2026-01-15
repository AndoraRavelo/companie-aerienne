package com.companieaerienne.entities;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "vol_programme")
public class VolProgramme {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(optional = false)
    @JoinColumn(name = "trajet_id")
    private Trajet trajet;

    @Column(name = "depart_ts", nullable = false)
    private LocalDateTime departTs;

    @Column(name = "arrivee_ts", nullable = false)
    private LocalDateTime arriveeTs;

    @Column(name = "prix_unitaire", nullable = false , precision = 10, scale = 2)
    private BigDecimal prixUnitaire;
}
