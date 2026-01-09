-- =====================================================================
-- Schéma V4 (français) : Historique explicite par tables
-- =====================================================================
-- Objectif : créer deux tables _status_vol_ et _status_reservation_
--            qui enregistrent à chaque ligne un événement de statut
--            (créé, confirmé, annulé, retardé, etc.) avec horodatage.
-- 
-- NB : On NE met plus de déclencheur. L'application devra insérer
--      elle-même une ligne dans ces tables lorsqu’un statut change.
-- =====================================================================

\i scripts/script_v2_fr.sql  -- charge le schéma principal (sans triggers)

-- ==================================================
-- 1. Table status_vol  (historique d'un vol_programme)
-- ==================================================
CREATE TABLE status_vol (
    id SERIAL PRIMARY KEY,
    vol_programme_id INTEGER NOT NULL REFERENCES vol_programme(id),
    libelle          VARCHAR(50) NOT NULL,         -- ex : 'créé', 'embarquement', 'annulé'
    date_statut      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =========================================================
-- 2. Table status_reservation  (historique d'une réservation)
-- =========================================================
CREATE TABLE status_reservation (
    id SERIAL PRIMARY KEY,
    reservation_id INTEGER NOT NULL REFERENCES reservation(id),
    libelle         VARCHAR(50) NOT NULL,
    date_statut     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =========================================================
-- 3. Exemples d’insertion pour illustrer le fonctionnement
-- =========================================================
-- Vol_programme id = 1 : créé puis embarquement
INSERT INTO status_vol (vol_programme_id, libelle) VALUES
(1, 'créé'),
(1, 'embarquement');

-- Réservation id = 1 : confirmée puis annulée
INSERT INTO status_reservation (reservation_id, libelle) VALUES
(1, 'confirmée'),
(1, 'annulée');

-- =====================================================================
-- Fin script V4
-- =====================================================================
