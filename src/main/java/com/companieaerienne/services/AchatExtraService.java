package com.companieaerienne.services;

import com.companieaerienne.entities.AchatExtra;
import com.companieaerienne.entities.AchatExtraLigne;
import com.companieaerienne.entities.Client;
import com.companieaerienne.entities.ProduitExtra;
import com.companieaerienne.entities.VolProgrammation;
import com.companieaerienne.repositories.AchatExtraLigneRepository;
import com.companieaerienne.repositories.AchatExtraRepository;
import com.companieaerienne.repositories.ClientRepository;
import com.companieaerienne.repositories.ProduitExtraRepository;
import com.companieaerienne.repositories.VolProgrammationRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class AchatExtraService {

    private final VolProgrammationRepository volProgrammationRepository;
    private final ClientRepository clientRepository;
    private final ProduitExtraRepository produitExtraRepository;
    private final AchatExtraRepository achatExtraRepository;
    private final AchatExtraLigneRepository achatExtraLigneRepository;

    public List<Client> tousLesClients() {
        List<Client> clients = clientRepository.findAll();
        clients.sort((a, b) -> {
            String an = a != null && a.getNom() != null ? a.getNom() : "";
            String bn = b != null && b.getNom() != null ? b.getNom() : "";
            int c = an.compareToIgnoreCase(bn);
            if (c != 0) return c;
            String ap = a != null && a.getPrenom() != null ? a.getPrenom() : "";
            String bp = b != null && b.getPrenom() != null ? b.getPrenom() : "";
            return ap.compareToIgnoreCase(bp);
        });
        return clients;
    }

    @Transactional
    public AchatExtra creerAchat(Integer vpId, Integer clientId, List<Integer> produitIds, List<Integer> quantites) {
        if (vpId == null) throw new IllegalArgumentException("Vol programmé manquant");
        if (clientId == null) throw new IllegalArgumentException("Client manquant");

        VolProgrammation vp = volProgrammationRepository.findById(vpId).orElse(null);
        if (vp == null) throw new IllegalArgumentException("Vol programmé introuvable");

        Client client = clientRepository.findById(clientId).orElse(null);
        if (client == null) throw new IllegalArgumentException("Client introuvable");

        if (produitIds == null || quantites == null || produitIds.size() != quantites.size()) {
            throw new IllegalArgumentException("Lignes d'achat invalides");
        }

        AchatExtra achat = new AchatExtra();
        achat.setClient(client);
        achat.setVolProgrammation(vp);
        achat.setDateAchat(LocalDateTime.now());
        achat = achatExtraRepository.save(achat);

        boolean hasLine = false;
        for (int i = 0; i < produitIds.size(); i++) {
            Integer produitId = produitIds.get(i);
            Integer qte = quantites.get(i);
            if (produitId == null || qte == null || qte <= 0) continue;

            ProduitExtra produit = produitExtraRepository.findById(produitId).orElse(null);
            if (produit == null) continue;
            if (produit.getActif() == null || !produit.getActif()) continue;

            BigDecimal pu = produit.getPrixUnitaire() != null ? produit.getPrixUnitaire() : BigDecimal.ZERO;
            BigDecimal sousTotal = pu.multiply(BigDecimal.valueOf(qte));

            AchatExtraLigne l = new AchatExtraLigne();
            l.setAchatExtra(achat);
            l.setProduitExtra(produit);
            l.setQuantite(qte);
            l.setPrixUnitaireApplique(pu);
            l.setSousTotal(sousTotal);
            achatExtraLigneRepository.save(l);
            hasLine = true;
        }

        if (!hasLine) {
            throw new IllegalStateException("Aucun produit sélectionné");
        }

        return achat;
    }
}
