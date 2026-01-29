package com.companieaerienne.entities;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "achat_extra")
public class AchatExtra {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(optional = false)
    @JoinColumn(name = "id_client")
    private Client client;

    @ManyToOne(optional = false)
    @JoinColumn(name = "id_vol_programmation")
    private VolProgrammation volProgrammation;

    @Column(name = "date_achat", nullable = false)
    private LocalDateTime dateAchat;
}
