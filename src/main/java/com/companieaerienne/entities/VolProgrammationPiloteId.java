package com.companieaerienne.entities;

import lombok.AllArgsConstructor;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode
public class VolProgrammationPiloteId implements Serializable {
    private Integer volProgrammation;
    private Integer pilote;
}
