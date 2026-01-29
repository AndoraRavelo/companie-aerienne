package com.companieaerienne.repositories;

import com.companieaerienne.entities.FacturePub;
import com.companieaerienne.entities.FacturePubLigne;
import com.companieaerienne.entities.VolProgrammation;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface FacturePubLigneRepository extends JpaRepository<FacturePubLigne, Integer> {
    List<FacturePubLigne> findByFacturePubOrderByIdAsc(FacturePub facturePub);

    @Query("SELECT COALESCE(SUM(l.montantPaye), 0) FROM FacturePubLigne l WHERE l.volProgrammation = :vp")
    java.math.BigDecimal sumMontantPayeByVolProgrammation(@Param("vp") VolProgrammation vp);

    @Query("SELECT l.facturePub.societe.nom, COALESCE(SUM(l.montantPaye), 0) " +
            "FROM FacturePubLigne l " +
            "WHERE l.volProgrammation IN :vps " +
            "GROUP BY l.facturePub.societe.nom " +
            "ORDER BY l.facturePub.societe.nom")
    List<Object[]> sumMontantPayeBySocieteAndVolProgrammations(@Param("vps") List<VolProgrammation> vps);
}
