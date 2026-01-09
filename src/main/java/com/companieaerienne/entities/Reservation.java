package com.companieaerienne.entities;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.Instant;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "reservation")
public class Reservation {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "code_resa", length = 8, nullable = false, unique = true)
    private String codeResa;

    @ManyToOne(optional = false)
    @JoinColumn(name = "vol_id")
    private Vol vol;

    @ManyToOne(optional = false)
    @JoinColumn(name = "passager_id")
    private Passager passager;

    @Column(length = 5)
    private String siege;

    @Column(name = "date_resa")
    private Instant dateResa;

    @Column(nullable = false, precision = 10, scale = 2)
    private BigDecimal prix;

    @Column(length = 20, nullable = false)
    private String statut = "confirmee";
}
