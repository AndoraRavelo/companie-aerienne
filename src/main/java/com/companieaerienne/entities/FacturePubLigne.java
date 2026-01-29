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
@Table(
        name = "facture_pub_ligne",
        uniqueConstraints = {
                @UniqueConstraint(name = "uk_facture_pub_ligne", columnNames = {"id_facture_pub", "id_vol_programmation"})
        }
)
public class FacturePubLigne {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(optional = false)
    @JoinColumn(name = "id_facture_pub")
    private FacturePub facturePub;

    @ManyToOne(optional = false)
    @JoinColumn(name = "id_vol_programmation")
    private VolProgrammation volProgrammation;

    @Column(name = "nb_diffusions", nullable = false)
    private Integer nbDiffusions;

    @Column(name = "prix_unitaire", nullable = false, precision = 15, scale = 2)
    private BigDecimal prixUnitaire;

    @Column(name = "montant_theorique", nullable = false, precision = 15, scale = 2)
    private BigDecimal montantTheorique;

    @Column(name = "montant_paye", nullable = false, precision = 15, scale = 2)
    private BigDecimal montantPaye;
}
