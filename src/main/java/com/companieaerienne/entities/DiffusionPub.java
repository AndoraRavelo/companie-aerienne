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
@Table(
        name = "diffusion_pub",
        uniqueConstraints = {
                @UniqueConstraint(name = "uk_diffusion_pub", columnNames = {"id_vol_programmation", "id_video_publicitaire"})
        }
)
public class DiffusionPub {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(optional = false)
    @JoinColumn(name = "id_vol_programmation")
    private VolProgrammation volProgrammation;

    @ManyToOne(optional = false)
    @JoinColumn(name = "id_video_publicitaire")
    private VideoPublicitaire videoPublicitaire;

    @Column(name = "nombre_diffusions", nullable = false)
    private Integer nombreDiffusions;

    @Column(name = "date_saisie")
    private LocalDateTime dateSaisie;
}
