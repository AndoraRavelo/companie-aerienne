package com.companieaerienne.repositories;

import com.companieaerienne.entities.AchatExtraLigne;
import com.companieaerienne.entities.VolProgrammation;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.math.BigDecimal;

public interface AchatExtraLigneRepository extends JpaRepository<AchatExtraLigne, Integer> {

    @Query("SELECT COALESCE(SUM(l.sousTotal), 0) FROM AchatExtraLigne l WHERE l.achatExtra.volProgrammation = :vp")
    BigDecimal sumSousTotalByVolProgrammation(@Param("vp") VolProgrammation vp);
}
