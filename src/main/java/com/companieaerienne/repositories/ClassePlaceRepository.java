package com.companieaerienne.repositories;

import com.companieaerienne.entities.ClassePlace;
import com.companieaerienne.entities.ClassePlaceId;
import com.companieaerienne.entities.Avion;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ClassePlaceRepository extends JpaRepository<ClassePlace, ClassePlaceId> {
    java.util.List<ClassePlace> findByAvion(Avion avion);
}
