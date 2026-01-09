-- =============================================
-- Schéma v2 : distinction Route / Flight Instance
-- =============================================
-- Pour exécuter : psql -U postgres -d testa -f script_v2.sql

-- ===============
-- D R O P  OLD
-- ===============
DROP TABLE IF EXISTS flight_aircraft      CASCADE;  -- nouvelle table liaison avion
DROP TABLE IF EXISTS flight_crew          CASCADE;  -- nouvelle table liaison equipage
DROP TABLE IF EXISTS flight_instance      CASCADE;
DROP TABLE IF EXISTS route                CASCADE;
DROP TABLE IF EXISTS reservation          CASCADE;
DROP TABLE IF EXISTS vol                  CASCADE;  -- ancienne table plus utilisée
DROP TABLE IF EXISTS affectation_equipage CASCADE;

-- Garder (mais drop si existait pour recréer) :
DROP TABLE IF EXISTS passager             CASCADE;
DROP TABLE IF EXISTS equipage             CASCADE;
DROP TABLE IF EXISTS avion                CASCADE;
DROP TABLE IF EXISTS aeroport             CASCADE;

-- ===============
-- C R E A T E
-- ===============
CREATE TABLE aeroport (
    id SERIAL PRIMARY KEY,
    code_iata CHAR(3) UNIQUE NOT NULL,
    nom       VARCHAR(100) NOT NULL,
    ville     VARCHAR(100) NOT NULL,
    pays      VARCHAR(100) NOT NULL
);

CREATE TABLE avion (
    id SERIAL PRIMARY KEY,
    immatriculation VARCHAR(10) UNIQUE NOT NULL,
    modele          VARCHAR(50) NOT NULL,
    capacite        INTEGER NOT NULL CHECK (capacite > 0),
    statut          VARCHAR(30) DEFAULT 'operationnel'
);

CREATE TABLE equipage (
    id SERIAL PRIMARY KEY,
    nom_complet VARCHAR(100) NOT NULL,
    role        VARCHAR(30)  NOT NULL,
    licence     VARCHAR(20),
    heures_vol  INTEGER DEFAULT 0
);

CREATE TABLE passager (
    id SERIAL PRIMARY KEY,
    nom       VARCHAR(50) NOT NULL,
    prenom    VARCHAR(50) NOT NULL,
    email     VARCHAR(100) UNIQUE,
    telephone VARCHAR(20)
);

-- TABLE ROUTE (trajet générique)
CREATE TABLE route (
    id SERIAL PRIMARY KEY,
    code_route VARCHAR(10) UNIQUE NOT NULL,
    aeroport_depart_id  INTEGER REFERENCES aeroport(id),
    aeroport_arrivee_id INTEGER REFERENCES aeroport(id)
);

-- TABLE FLIGHT INSTANCE (occurrence précise)
CREATE TABLE flight_instance (
    id SERIAL PRIMARY KEY,
    route_id INTEGER NOT NULL REFERENCES route(id),
    depart_ts TIMESTAMP NOT NULL,
    arrivee_ts TIMESTAMP NOT NULL,
    statut VARCHAR(20) DEFAULT 'planifie'
);

-- Liaison occurrence ↔ avion (plusieurs avions possibles)
CREATE TABLE flight_aircraft (
    id SERIAL PRIMARY KEY,
    flight_instance_id INTEGER NOT NULL REFERENCES flight_instance(id),
    avion_id           INTEGER NOT NULL REFERENCES avion(id)
);

-- Liaison occurrence ↔ equipage (remplace affectation_equipage)
CREATE TABLE flight_crew (
    id SERIAL PRIMARY KEY,
    flight_instance_id INTEGER NOT NULL REFERENCES flight_instance(id),
    equipage_id        INTEGER NOT NULL REFERENCES equipage(id),
    role_sur_vol       VARCHAR(30) NOT NULL
);

-- TABLE RESERVATION re-liante
CREATE TABLE reservation (
    id SERIAL PRIMARY KEY,
    code_resa   VARCHAR(8) UNIQUE NOT NULL,
    flight_instance_id INTEGER NOT NULL REFERENCES flight_instance(id),
    passager_id INTEGER NOT NULL REFERENCES passager(id),
    sieges      INTEGER NOT NULL CHECK (sieges > 0),
    date_resa   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    prix        NUMERIC(10,2) NOT NULL,
    statut      VARCHAR(20) DEFAULT 'confirmee'
);

-- =============================================
-- INSERTIONS D'EXEMPLE
-- =============================================
-- 1. Aéroports
INSERT INTO aeroport (code_iata, nom, ville, pays) VALUES
('TNR', 'Ivato', 'Antananarivo', 'Madagascar'),
('NOS', 'Fascene', 'Nosy Be', 'Madagascar');

-- 2. Avions
INSERT INTO avion (immatriculation, modele, capacite) VALUES
('5R-MFA', 'ATR 72-600', 70),
('5R-MFB', 'Boeing 737-800', 160);

-- 3. Equipages
INSERT INTO equipage (nom_complet, role) VALUES
('Rakoto Andry', 'pilote'),
('Rasoanarivo Fara', 'PNC');

-- 4. Route (trajet générique)
INSERT INTO route (code_route, aeroport_depart_id, aeroport_arrivee_id) VALUES
('TNR-NOS', 1, 2);

-- 5. Flight instances (occurrences réelles)
INSERT INTO flight_instance (route_id, depart_ts, arrivee_ts) VALUES
(1, '2026-01-12 08:00', '2026-01-12 09:30'), -- id 1
(1, '2026-01-12 12:00', '2026-01-12 13:30'), -- id 2
(1, '2026-01-13 12:00', '2026-01-13 13:30');   -- id 3

-- 6. Assignation des avions aux occurrences
INSERT INTO flight_aircraft (flight_instance_id, avion_id) VALUES
(1, 1),
(2, 2),
(3, 1);

-- 7. Assignation des équipages (exemple)
INSERT INTO flight_crew (flight_instance_id, equipage_id, role_sur_vol) VALUES
(1, 1, 'capitaine'),
(1, 2, 'PNC');

-- 8. Passagers et réservations exemples
INSERT INTO passager (nom, prenom, email) VALUES
('Smith', 'John', 'john.smith@example.com'),
('Martin', 'Claire', 'claire.martin@example.com');

INSERT INTO reservation (code_resa, flight_instance_id, passager_id, sieges, prix) VALUES
('ABC001', 1, 1, 2, 100.00),
('DEF002', 2, 2, 1, 120.00);

-- =============================================
-- FIN SCHÉMA V2
-- =============================================
