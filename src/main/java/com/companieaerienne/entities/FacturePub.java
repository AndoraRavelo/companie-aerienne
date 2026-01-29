package com.companieaerienne.entities;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(
        name = "facture_pub",
        uniqueConstraints = {
                @UniqueConstraint(name = "uk_facture_pub", columnNames = {"id_societe", "annee", "mois"})
        }
)
public class FacturePub {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(optional = false)
    @JoinColumn(name = "id_societe")
    private Societe societe;

    @Column(name = "annee", nullable = false)
    private Integer annee;

    @Column(name = "mois", nullable = false)
    private Integer mois;

    @Column(name = "date_creation", nullable = false)
    private LocalDate dateCreation;

    @Column(name = "total_theorique", nullable = false, precision = 15, scale = 2)
    private BigDecimal totalTheorique;

    @Column(name = "total_paye", nullable = false, precision = 15, scale = 2)
    private BigDecimal totalPaye;
}
