-- ===============================
-- SCRIPT COMPLET DE TEST
-- ===============================

-- Nettoyage (optionnel)
DROP TABLE IF EXISTS
historique_reservation,
reservation_place,
reservation,
tarif_vol,
classe_place,
classe,
client,
avion_pilote,
vol_programmation_pilote,
vol_programmation_statut,
vol_programmation,
statut_reservation,
statut_vol,
vol,
pilote,
aeroport,
avion
CASCADE;

-- ===============================
-- TABLES DE BASE
-- ===============================

CREATE TABLE avion (
    id SERIAL PRIMARY KEY,
    matricule VARCHAR(50),
    capacite INTEGER
);

CREATE TABLE aeroport (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(100)
);

CREATE TABLE pilote (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(100),
    prenom VARCHAR(100)
);

CREATE TABLE vol (
    id SERIAL PRIMARY KEY,
    id_aeroport_depart INTEGER REFERENCES aeroport(id),
    id_aeroport_arrivee INTEGER REFERENCES aeroport(id),
    duree DECIMAL(5,2)
);

CREATE TABLE statut_vol (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(50)
);

CREATE TABLE vol_programmation (
    id SERIAL PRIMARY KEY,
    id_vol INTEGER REFERENCES vol(id),
    id_avion INTEGER REFERENCES avion(id),
    date_heure TIMESTAMP
);

CREATE TABLE vol_programmation_statut (
    id SERIAL PRIMARY KEY,
    id_vol_programmation INTEGER REFERENCES vol_programmation(id),
    id_statut INTEGER REFERENCES statut_vol(id),
    date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE vol_programmation_pilote (
    id_vol_programmation INTEGER REFERENCES vol_programmation(id),
    id_pilote INTEGER REFERENCES pilote(id),
    role VARCHAR(30),
    PRIMARY KEY (id_vol_programmation, id_pilote)
);

CREATE TABLE avion_pilote (
    id_avion INTEGER REFERENCES avion(id),
    id_pilote INTEGER REFERENCES pilote(id),
    date DATE,
    PRIMARY KEY (id_avion, id_pilote, date)
);

CREATE TABLE client (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(100),
    prenom VARCHAR(100),
    email VARCHAR(150),
    telephone VARCHAR(20)
);

CREATE TABLE classe (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(50)
);

CREATE TABLE classe_place (
    id_classe INTEGER REFERENCES classe(id),
    place_debut INTEGER,
    place_fin INTEGER,
    id_avion INTEGER REFERENCES avion(id),
    PRIMARY KEY (id_classe, id_avion)
);

CREATE TABLE reservation (
    id SERIAL PRIMARY KEY,
    id_vol_programmation INTEGER REFERENCES vol_programmation(id),
    id_client INTEGER REFERENCES client(id),
    nombre_places INTEGER DEFAULT 1
);

CREATE TABLE reservation_place (
    id_reservation INTEGER REFERENCES reservation(id),
    id_vol_programmation INTEGER REFERENCES vol_programmation(id),
    place INTEGER,
    PRIMARY KEY (id_vol_programmation, place)
);

CREATE TABLE statut_reservation (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(50)
);

CREATE TABLE historique_reservation (
    id SERIAL PRIMARY KEY,
    id_reservation INTEGER REFERENCES reservation(id),
    id_statut INTEGER REFERENCES statut_reservation(id),
    date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE tarif_vol (
    id SERIAL PRIMARY KEY,
    id_vol_programmation INTEGER REFERENCES vol_programmation(id),
    id_classe INTEGER REFERENCES classe(id),
    tarif DECIMAL(10,2)
);

-- ===============================
-- DONNÉES DE TEST
-- ===============================

-- Classes
INSERT INTO classe (nom) VALUES
('Première classe'),
('Économique'),
('Premium');

-- Avion (120 places)
INSERT INTO avion (matricule, capacite)
VALUES ('AV-001', 120);

-- Répartition des places
INSERT INTO classe_place (id_classe, place_debut, place_fin, id_avion)
VALUES
(1, 1, 30, 1),     -- Première classe
(2, 31, 80, 1),    -- Économique
(3, 81, 120, 1);   -- Premium

-- Aéroports
INSERT INTO aeroport (nom) VALUES
('Antananarivo'),
('Toamasina');

-- Statuts vol
INSERT INTO statut_vol (nom) VALUES
('Programmé'),
('Annulé'),
('Effectué');

-- Vol
INSERT INTO vol (id_aeroport_depart, id_aeroport_arrivee, duree)
VALUES (1, 2, 1.30);

-- Programmation du vol
INSERT INTO vol_programmation (id_vol, id_avion, date_heure)
VALUES (1, 1, '2026-02-01 08:00:00');

-- Historique statut vol
INSERT INTO vol_programmation_statut (id_vol_programmation, id_statut)
VALUES (1, 1);

-- Tarifs par classe
INSERT INTO tarif_vol (id_vol_programmation, id_classe, tarif)
VALUES
(1, 1, 1200000),     -- Première classe
(1, 2, 800000),      -- Économique
(1, 3, 1000000);   -- Premium

-- Client
INSERT INTO client (nom, prenom, email, telephone)
VALUES ('Rakoto', 'Jean', 'jean.rakoto@email.mg', '0340000000');

-- Statut réservation
INSERT INTO statut_reservation (nom)
VALUES ('Validée'), ('Annulée');

-- Réservation de test
INSERT INTO reservation (id_vol_programmation, id_client, nombre_places)
VALUES (1, 1, 1);

INSERT INTO historique_reservation (id_reservation, id_statut)
VALUES (1, 1);

-- ===============================
-- FIN DU SCRIPT
-- ===============================
