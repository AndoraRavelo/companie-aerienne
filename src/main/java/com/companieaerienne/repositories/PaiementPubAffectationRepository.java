package com.companieaerienne.repositories;

import com.companieaerienne.entities.PaiementPub;
import com.companieaerienne.entities.PaiementPubAffectation;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface PaiementPubAffectationRepository extends JpaRepository<PaiementPubAffectation, Integer> {
    List<PaiementPubAffectation> findByPaiementPub(PaiementPub paiementPub);
}
