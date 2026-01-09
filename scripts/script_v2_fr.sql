-- ==========================================================
-- Schéma V2 (français) : distinction Trajet / Vol Programmé
-- ==========================================================
-- Exécution : psql -U postgres -d testa -f script_v2_fr.sql
-- 
-- Nomenclature (français) :
--   trajet            = route commerciale (ex : TNR → NOS)
--   vol_programme     = départ précis d'un trajet (date / heure)
--   vol_avion         = table de liaison vol_programme ↔ avion
--   vol_equipage      = table de liaison vol_programme ↔ équipage
-- 
-- Capacités : on additionne les capacités des avions liés à un vol_programme
-- Réservations : nombre de sièges réservés est retranché du total disponible.
-- ==========================================================

-- =====================================
-- 0. Nettoyage (DROP si existe déjà)
-- =====================================
DROP TABLE IF EXISTS vol_avion      CASCADE;
DROP TABLE IF EXISTS vol_equipage   CASCADE;
DROP TABLE IF EXISTS reservation    CASCADE;
DROP TABLE IF EXISTS vol_programme  CASCADE;
DROP TABLE IF EXISTS trajet         CASCADE;
DROP TABLE IF EXISTS passager       CASCADE;
DROP TABLE IF EXISTS equipage       CASCADE;
DROP TABLE IF EXISTS avion          CASCADE;
DROP TABLE IF EXISTS aeroport       CASCADE;

-- =====================
-- 1. Tables de référence
-- =====================
-- 1.1 Aéroport (départ / arrivée)
CREATE TABLE aeroport (
    id SERIAL PRIMARY KEY,
    code_iata CHAR(3) UNIQUE NOT NULL, -- code IATA : ex "TNR"
    nom       VARCHAR(100) NOT NULL,
    ville     VARCHAR(100) NOT NULL,
    pays      VARCHAR(100) NOT NULL
);

-- 1.2 Avion (capacité portée ici)
CREATE TABLE avion (
    id SERIAL PRIMARY KEY,
    immatriculation VARCHAR(10) UNIQUE NOT NULL, -- ex "5R-MFA"
    modele          VARCHAR(50) NOT NULL,        -- ex "ATR 72-600"
    capacite        INTEGER NOT NULL CHECK (capacite > 0),
    statut          VARCHAR(30) DEFAULT 'operationnel'
);

-- 1.3 Équipage (membre)
CREATE TABLE equipage (
    id SERIAL PRIMARY KEY,
    nom_complet VARCHAR(100) NOT NULL,
    role        VARCHAR(30)  NOT NULL, -- pilote, PNC, etc.
    licence     VARCHAR(20),
    heures_vol  INTEGER DEFAULT 0
);

-- 1.4 Passager (client)
CREATE TABLE passager (
    id SERIAL PRIMARY KEY,
    nom       VARCHAR(50) NOT NULL,
    prenom    VARCHAR(50) NOT NULL,
    email     VARCHAR(100) UNIQUE,
    telephone VARCHAR(20)
);

-- =====================
-- 2. Cœur métier
-- =====================
-- 2.1 Trajet (route commerciale) : pas de date ni d'avion
CREATE TABLE trajet (
    id SERIAL PRIMARY KEY,
    code_trajet VARCHAR(10) UNIQUE NOT NULL, -- ex "TNR-NOS"
    aeroport_depart_id  INTEGER NOT NULL REFERENCES aeroport(id),
    aeroport_arrivee_id INTEGER NOT NULL REFERENCES aeroport(id),
    CHECK (aeroport_depart_id <> aeroport_arrivee_id)
);

-- 2.2 Vol programmé (occurrence précise d'un trajet)
CREATE TABLE vol_programme (
    id SERIAL PRIMARY KEY,
    trajet_id  INTEGER NOT NULL REFERENCES trajet(id),
    depart_ts  TIMESTAMP NOT NULL,
    arrivee_ts TIMESTAMP NOT NULL,
    CHECK (arrivee_ts > depart_ts)
);


-- 2.3 Liaison vol_programme ↔ avion (plusieurs avions possibles)
CREATE TABLE vol_avion (
    id SERIAL PRIMARY KEY,
    vol_programme_id INTEGER NOT NULL REFERENCES vol_programme(id),
    avion_id         INTEGER NOT NULL REFERENCES avion(id)
);

-- 2.4 Liaison vol_programme ↔ équipage
CREATE TABLE vol_equipage (
    id SERIAL PRIMARY KEY,
    vol_programme_id INTEGER NOT NULL REFERENCES vol_programme(id),
    equipage_id      INTEGER NOT NULL REFERENCES equipage(id),
    role_sur_vol     VARCHAR(30) NOT NULL -- capitaine, PNC, etc.
);

-- 2.5 Réservation (N sièges réservés sur un vol_programme)
CREATE TABLE reservation (
    id SERIAL PRIMARY KEY,
    code_resa VARCHAR(8) UNIQUE NOT NULL,
    vol_programme_id INTEGER NOT NULL REFERENCES vol_programme(id),
    passager_id      INTEGER NOT NULL REFERENCES passager(id),
    sieges           INTEGER NOT NULL CHECK (sieges > 0),
    date_resa        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    prix             NUMERIC(10,2) NOT NULL
);


-- =====================================
-- 3. Jeu de données minimal pour test
-- =====================================
-- 3.1 Aéroports
INSERT INTO aeroport (code_iata, nom, ville, pays) VALUES
('TNR', 'Ivato', 'Antananarivo', 'Madagascar'),
('NOS', 'Fascene', 'Nosy Be', 'Madagascar');

-- 3.2 Avions
INSERT INTO avion (immatriculation, modele, capacite) VALUES
('5R-MFA', 'ATR 72-600', 70),
('5R-MFB', 'Boeing 737-800', 160);

-- 3.3 Équipages
INSERT INTO equipage (nom_complet, role) VALUES
('Rakoto Andry', 'pilote'),
('Rasoanarivo Fara', 'PNC');

-- 3.4 Trajet
INSERT INTO trajet (code_trajet, aeroport_depart_id, aeroport_arrivee_id) VALUES
('TNR-NOS', 1, 2);

-- 3.5 Vols programmés (occurrences)
INSERT INTO vol_programme (trajet_id, depart_ts, arrivee_ts) VALUES
(1, '2026-01-12 08:00', '2026-01-12 09:30'), -- id = 1
(1, '2026-01-12 12:00', '2026-01-12 13:30'), -- id = 2
(1, '2026-01-13 12:00', '2026-01-13 13:30');   -- id = 3

-- 3.6 Affectation des avions
INSERT INTO vol_avion (vol_programme_id, avion_id) VALUES
(1, 1),
(2, 2),
(3, 1);

-- 3.7 Affectation des équipages
INSERT INTO vol_equipage (vol_programme_id, equipage_id, role_sur_vol) VALUES
(1, 1, 'capitaine'),
(1, 2, 'PNC');

-- 3.8 Passagers & réservations
INSERT INTO passager (nom, prenom, email) VALUES
('Smith', 'John', 'john.smith@example.com'),
('Martin', 'Claire', 'claire.martin@example.com');

INSERT INTO reservation (code_resa, vol_programme_id, passager_id, sieges, prix) VALUES
('ABC001', 1, 1, 2, 100.00),
('DEF002', 2, 2, 1, 120.00);

-- ==========================================================
-- Fin du script V2 (français)
-- ==========================================================
