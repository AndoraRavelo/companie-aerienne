package com.companieaerienne.repositories;

import com.companieaerienne.entities.Classe;
import com.companieaerienne.entities.CategorieType;
import com.companieaerienne.entities.TarifVol;
import com.companieaerienne.entities.VolProgrammation;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface TarifVolRepository extends JpaRepository<TarifVol, Integer> {
    Optional<TarifVol> findByVolProgrammationAndClasse(VolProgrammation volProgrammation, Classe classe);
    Optional<TarifVol> findByVolProgrammationAndClasseAndCategorieType(VolProgrammation volProgrammation, Classe classe, CategorieType categorieType);
    java.util.List<TarifVol> findByVolProgrammation(VolProgrammation volProgrammation);
}
