package com.companieaerienne.repositories;

import com.companieaerienne.entities.ProduitExtra;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ProduitExtraRepository extends JpaRepository<ProduitExtra, Integer> {
    List<ProduitExtra> findByActifTrueOrderByLibelleAsc();
}
