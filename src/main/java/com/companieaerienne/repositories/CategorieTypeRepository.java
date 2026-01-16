package com.companieaerienne.repositories;

import com.companieaerienne.entities.CategorieType;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface CategorieTypeRepository extends JpaRepository<CategorieType, Integer> {
    Optional<CategorieType> findByCode(String code);
}
