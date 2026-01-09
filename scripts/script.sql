-- Script de création du schéma minimal et insertion de données d'exemple
-- Base : postgres (utilisez la base "testa" ou celle de votre choix)
-- Pour exécuter : psql -U postgres -d testa -f script.sql

-- =========================
-- DDL : DROP si existe
-- =========================
DROP TABLE IF EXISTS affectation_equipage CASCADE;
DROP TABLE IF EXISTS reservation          CASCADE;
DROP TABLE IF EXISTS vol                  CASCADE;
DROP TABLE IF EXISTS equipage             CASCADE;
DROP TABLE IF EXISTS passager             CASCADE;
DROP TABLE IF EXISTS avion                CASCADE;
DROP TABLE IF EXISTS aeroport             CASCADE;

-- =========================
-- DDL : CRÉATION DES TABLES
-- =========================
CREATE TABLE aeroport (
    id           SERIAL PRIMARY KEY,
    code_iata    CHAR(3) UNIQUE NOT NULL,
    nom          VARCHAR(100) NOT NULL,
    ville        VARCHAR(100) NOT NULL,
    pays         VARCHAR(100) NOT NULL
);

CREATE TABLE avion (
    id             SERIAL PRIMARY KEY,
    immatriculation VARCHAR(10) UNIQUE NOT NULL,
    modele          VARCHAR(50) NOT NULL,
    capacite        INTEGER NOT NULL CHECK (capacite > 0),
    statut          VARCHAR(30) NOT NULL DEFAULT 'operationnel'
);

CREATE TABLE equipage (
    id           SERIAL PRIMARY KEY,
    nom_complet  VARCHAR(100) NOT NULL,
    role         VARCHAR(30)  NOT NULL,
    licence      VARCHAR(20),
    heures_vol   INTEGER DEFAULT 0
);

CREATE TABLE vol (
    id                 SERIAL PRIMARY KEY,
    code_vol           VARCHAR(10) UNIQUE NOT NULL,
    date_heure_depart  TIMESTAMP NOT NULL,
    date_heure_arrivee TIMESTAMP NOT NULL,
    aeroport_depart_id INTEGER REFERENCES aeroport(id),
    aeroport_arrivee_id INTEGER REFERENCES aeroport(id),
    avion_id           INTEGER REFERENCES avion(id),
    statut             VARCHAR(20) NOT NULL DEFAULT 'planifie'
);

CREATE TABLE passager (
    id        SERIAL PRIMARY KEY,
    nom       VARCHAR(50) NOT NULL,
    prenom    VARCHAR(50) NOT NULL,
    email     VARCHAR(100) UNIQUE,
    telephone VARCHAR(20)
);

CREATE TABLE reservation (
    id           SERIAL PRIMARY KEY,
    code_resa    VARCHAR(8) UNIQUE NOT NULL,
    vol_id       INTEGER NOT NULL REFERENCES vol(id),
    passager_id  INTEGER NOT NULL REFERENCES passager(id),
    siege        VARCHAR(5),
    date_resa    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    prix         NUMERIC(10,2) NOT NULL,
    statut       VARCHAR(20) NOT NULL DEFAULT 'confirmee'
);

CREATE TABLE affectation_equipage (
    id           SERIAL PRIMARY KEY,
    vol_id       INTEGER NOT NULL REFERENCES vol(id),
    equipage_id  INTEGER NOT NULL REFERENCES equipage(id),
    role_sur_vol VARCHAR(30) NOT NULL
);

-- =========================
-- INSERTIONS D'EXEMPLE
-- =========================
-- Aéroports
INSERT INTO aeroport (code_iata, nom, ville, pays) VALUES
('CDG', 'Charles de Gaulle', 'Paris', 'France'),
('JFK', 'John F. Kennedy Intl', 'New York', 'USA'),
('LHR', 'Heathrow', 'London', 'United Kingdom');

-- Avions
INSERT INTO avion (immatriculation, modele, capacite) VALUES
('F-HABC', 'Airbus A320', 180),
('N-XYZ1', 'Boeing 737-800', 160);

-- Équipages
INSERT INTO equipage (nom_complet, role, licence) VALUES
('Jean Dupont', 'pilote', 'ATPL12345'),
('Marie Leroy', 'PNC', NULL);

-- Vols (dates au format ISO)
INSERT INTO vol (code_vol, date_heure_depart, date_heure_arrivee, aeroport_depart_id, aeroport_arrivee_id, avion_id) VALUES
('AF001', '2026-02-01 08:00', '2026-02-01 11:00', 1, 2, 1),
('AF002', '2026-02-02 09:00', '2026-02-02 10:00', 2, 1, 2);

-- Affectations équipage -> vols
INSERT INTO affectation_equipage (vol_id, equipage_id, role_sur_vol) VALUES
(1, 1, 'capitaine'),
(1, 2, 'PNC'),
(2, 1, 'capitaine');

-- Passagers
INSERT INTO passager (nom, prenom, email, telephone) VALUES
('Smith', 'John', 'john.smith@example.com', '+15550001'),
('Martin', 'Claire', 'claire.martin@example.com', '+3360000001'),
('Brown', 'Alice', 'alice.brown@example.com', '+447700900001');

-- Réservations
INSERT INTO reservation (code_resa, vol_id, passager_id, siege, prix) VALUES
('ABC123', 1, 1, '12A', 120.00),
('DEF456', 1, 2, '12B', 120.00),
('GHI789', 2, 3, '14C', 90.00);

-- =========================
-- F I N
-- =========================
