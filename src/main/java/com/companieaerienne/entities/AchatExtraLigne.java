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
@Table(name = "achat_extra_ligne")
public class AchatExtraLigne {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(optional = false)
    @JoinColumn(name = "id_achat_extra")
    private AchatExtra achatExtra;

    @ManyToOne(optional = false)
    @JoinColumn(name = "id_produit_extra")
    private ProduitExtra produitExtra;

    @Column(name = "quantite", nullable = false)
    private Integer quantite;

    @Column(name = "prix_unitaire_applique", nullable = false)
    private BigDecimal prixUnitaireApplique;

    @Column(name = "sous_total", nullable = false)
    private BigDecimal sousTotal;
}
