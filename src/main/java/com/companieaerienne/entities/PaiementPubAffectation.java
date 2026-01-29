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
        name = "paiement_pub_affectation",
        uniqueConstraints = {
                @UniqueConstraint(name = "uk_paiement_pub_affectation", columnNames = {"id_paiement_pub", "id_facture_pub_ligne"})
        }
)
public class PaiementPubAffectation {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(optional = false)
    @JoinColumn(name = "id_paiement_pub")
    private PaiementPub paiementPub;

    @ManyToOne(optional = false)
    @JoinColumn(name = "id_facture_pub_ligne")
    private FacturePubLigne facturePubLigne;

    @Column(name = "montant_affecte", nullable = false, precision = 15, scale = 2)
    private BigDecimal montantAffecte;
}
