-- =====================================================================
-- Schéma V3 (français) : Ajout d'historique de statuts
-- =====================================================================
-- Basé sur script_v2_fr.sql, on ajoute :
--   - Table reference_statut (type + code + libellé)
--   - Table historique_statut_vol
--   - Table historique_statut_reservation
-- On garde la colonne 'statut' dans vol_programme et reservation pour
--   accéder rapidement au statut courant, mais tout changement doit
--   être consigné dans la table d'historique.
-- =====================================================================

\i scripts/script_v2_fr.sql  -- importe tout le schéma V2 FR

-- =============================
-- 1. Référentiel des statuts
-- =============================
CREATE TABLE reference_statut (
    id SERIAL PRIMARY KEY,
    categorie VARCHAR(30) NOT NULL,   -- ex 'vol', 'reservation'
    code       VARCHAR(20) NOT NULL,
    libelle    VARCHAR(50) NOT NULL,
    UNIQUE(categorie, code)
);

-- Remplissage de base
INSERT INTO reference_statut (categorie, code, libelle) VALUES
('vol', 'planifie',  'Planifié'),
('vol', 'embarquement', 'Embarquement'),
('vol', 'en_vol',   'En vol'),
('vol', 'arrive',   'Arrivé'),
('vol', 'annule',   'Annulé'),
('reservation', 'confirmee', 'Confirmée'),
('reservation', 'annulee',   'Annulée'),
('reservation', 'en_attente','En attente');

-- =============================
-- 2. Historique des statuts vol
-- =============================
CREATE TABLE historique_statut_vol (
    id SERIAL PRIMARY KEY,
    vol_programme_id INTEGER NOT NULL REFERENCES vol_programme(id),
    statut_id        INTEGER NOT NULL REFERENCES reference_statut(id),
    date_changement  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================
-- 3. Historique des statuts réservation
-- =============================
CREATE TABLE historique_statut_reservation (
    id SERIAL PRIMARY KEY,
    reservation_id   INTEGER NOT NULL REFERENCES reservation(id),
    statut_id        INTEGER NOT NULL REFERENCES reference_statut(id),
    date_changement  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================
-- 4. Déclencheurs pour conserver l'historique automatiquement
-- =============================
-- (Option : on crée des triggers pour alimenter l'historique à chaque UPDATE)
-- Exemple pour vol_programme :

CREATE OR REPLACE FUNCTION trg_vol_programme_statut()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.statut IS DISTINCT FROM OLD.statut THEN
        INSERT INTO historique_statut_vol (vol_programme_id, statut_id)
        SELECT OLD.id, r.id
        FROM reference_statut r
        WHERE r.categorie = 'vol' AND r.code = NEW.statut;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_update_vol_statut
AFTER UPDATE OF statut ON vol_programme
FOR EACH ROW
EXECUTE FUNCTION trg_vol_programme_statut();

-- Même principe pour reservation
CREATE OR REPLACE FUNCTION trg_reservation_statut()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.statut IS DISTINCT FROM OLD.statut THEN
        INSERT INTO historique_statut_reservation (reservation_id, statut_id)
        SELECT OLD.id, r.id
        FROM reference_statut r
        WHERE r.categorie = 'reservation' AND r.code = NEW.statut;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_update_reservation_statut
AFTER UPDATE OF statut ON reservation
FOR EACH ROW
EXECUTE FUNCTION trg_reservation_statut();

-- =====================================================================
-- Fin du script V3
-- =====================================================================
