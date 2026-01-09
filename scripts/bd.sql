-- =========================================================
-- BDD DE LA COMPAGNIE AERIENNE
-- Schéma complet + données de test
-- =========================================================

-- Nettoyage préalable (désactiver si besoin de conserver les données)
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
-- 1.1 Aéroport
CREATE TABLE aeroport (
    id SERIAL PRIMARY KEY,
    code_iata CHAR(3) UNIQUE NOT NULL, -- ex "TNR"
    nom       VARCHAR(100) NOT NULL,
    ville     VARCHAR(100) NOT NULL,
    pays      VARCHAR(100) NOT NULL
);

-- 1.2 Avion
CREATE TABLE avion (
    id SERIAL PRIMARY KEY,
    immatriculation VARCHAR(10) UNIQUE NOT NULL, -- ex "5R-MFA"
    modele          VARCHAR(50) NOT NULL,        -- ex "ATR 72-600"
    capacite        INTEGER NOT NULL CHECK (capacite > 0),
    statut          VARCHAR(30) DEFAULT 'operationnel'
);

-- 1.3 Équipage
CREATE TABLE equipage (
    id SERIAL PRIMARY KEY,
    nom_complet VARCHAR(100) NOT NULL,
    role        VARCHAR(30)  NOT NULL, -- pilote, PNC, etc.
    licence     VARCHAR(20),
    heures_vol  INTEGER DEFAULT 0
);

-- 1.4 Passager
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
-- 2.1 Trajet (route commerciale)
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

-- 2.3 Liaison vol_programme ↔ avion
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
    role_sur_vol     VARCHAR(30) NOT NULL
);

-- 2.5 Réservation
CREATE TABLE reservation (
    id SERIAL PRIMARY KEY,
    code_resa VARCHAR(8) UNIQUE NOT NULL,
    vol_programme_id INTEGER NOT NULL REFERENCES vol_programme(id),
    passager_id      INTEGER NOT NULL REFERENCES passager(id),
    sieges           INTEGER NOT NULL CHECK (sieges > 0),
    date_resa        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    prix             NUMERIC(10,2) NOT NULL
);

-- 2.6 Historique statut vol
CREATE TABLE status_vol (
    id SERIAL PRIMARY KEY,
    vol_programme_id INTEGER NOT NULL REFERENCES vol_programme(id),
    libelle          VARCHAR(50) NOT NULL,
    date_statut      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2.7 Historique statut réservation
CREATE TABLE status_reservation (
    id SERIAL PRIMARY KEY,
    reservation_id INTEGER NOT NULL REFERENCES reservation(id),
    libelle         VARCHAR(50) NOT NULL,
    date_statut     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =========================================================
-- 3. DONNÉES D'EXEMPLE
-- =========================================================

-- 3.1 Aéroports
INSERT INTO aeroport (code_iata, nom, ville, pays) VALUES
('TNR', 'Ivato International Airport', 'Antananarivo', 'Madagascar'),
('NOS', 'Fascene Airport', 'Nosy Be', 'Madagascar');

-- 3.2 Avions
INSERT INTO avion (immatriculation, modele, capacite) VALUES
('5R-MFA', 'ATR 72-600', 70),
('5R-MFB', 'ATR 42-500', 48);

-- 3.3 Équipage
INSERT INTO equipage (nom_complet, role, licence) VALUES
('Rakoto Jean', 'Pilote', 'ATPL'),
('Rabe Paul', 'Copilote', 'CPL'),
('Rasoanaivo Marie', 'PNC', NULL),
('Randrianina Sophie', 'PNC', NULL);

-- 3.4 Passagers
INSERT INTO passager (nom, prenom, email, telephone) VALUES
('Andrianarivo', 'Lucas', 'lucas@gmail.com', '0341234567'),
('Razanamihaja', 'Claire', 'claire@gmail.com', '0329876543');

-- 3.5 Trajet TNR -> NOS
INSERT INTO trajet (code_trajet, aeroport_depart_id, aeroport_arrivee_id)
VALUES ('TNR-NOS',
        (SELECT id FROM aeroport WHERE code_iata = 'TNR'),
        (SELECT id FROM aeroport WHERE code_iata = 'NOS'));

-- 3.6 Vol programmé le 12/01 à 12h
INSERT INTO vol_programme (trajet_id, depart_ts, arrivee_ts)
VALUES ((SELECT id FROM trajet WHERE code_trajet = 'TNR-NOS'),
        '2026-01-12 12:00:00', '2026-01-12 13:15:00');

INSERT INTO vol_programme (trajet_id)

-- 3.7 Avion affecté
INSERT INTO vol_avion (vol_programme_id, avion_id)
VALUES (1, (SELECT id FROM avion WHERE immatriculation = '5R-MFA'));

-- 3.8 Équipage affecté
INSERT INTO vol_equipage (vol_programme_id, equipage_id, role_sur_vol) VALUES
(1, 1, 'Capitaine'),
(1, 2, 'Copilote'),
(1, 3, 'PNC'),
(1, 4, 'PNC');

-- 3.9 Réservation de test
INSERT INTO reservation (code_resa, vol_programme_id, passager_id, sieges, prix)
VALUES ('AB123456', 1, 1, 2, 400000);

-- 3.10 Historique statut vol
INSERT INTO status_vol (vol_programme_id, libelle) VALUES
(1, 'créé'),
(1, 'embarquement'),
(1, 'terminé');

-- 3.11 Historique statut réservation
INSERT INTO status_reservation (reservation_id, libelle) VALUES
(1, 'créée'),
(1, 'confirmée');

-- =========================================================
-- FIN DU SCRIPT bd.sql
-- =========================================================

-- === Vols supplémentaires TNR -> NOS =====================

-- 12 janvier 15h00
INSERT INTO vol_programme (trajet_id, depart_ts, arrivee_ts)
VALUES (
    (SELECT id FROM trajet WHERE code_trajet = 'TNR-NOS'),
    '2026-01-13 15:00:00',
    '2026-01-13 16:15:00'
);

-- 12 janvier 18h00
INSERT INTO vol_programme (trajet_id, depart_ts, arrivee_ts)
VALUES (
    (SELECT id FROM trajet WHERE code_trajet = 'TNR-NOS'),
    '2026-01-12 18:00:00',
    '2026-01-12 19:15:00'
);

-- 13 janvier 09h00
INSERT INTO vol_programme (trajet_id, depart_ts, arrivee_ts)
VALUES (
    (SELECT id FROM trajet WHERE code_trajet = 'TNR-NOS'),
    '2026-01-13 09:00:00',
    '2026-01-13 10:15:00'
);


INSERT INTO vol_avion (vol_programme_id, avion_id)
VALUES (5, (SELECT id FROM avion WHERE immatriculation = '5R-MFA'));
INSERT INTO vol_programme (trajet_id, depart_ts, arrivee_ts)
VALUES (
    (SELECT id FROM trajet WHERE code_trajet = 'TNR-NOS'),
    '2026-01-13 09:00:00',
    '2026-01-13 10:15:00'
);