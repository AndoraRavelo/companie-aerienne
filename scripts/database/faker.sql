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
categorie_type,
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

CREATE TABLE categorie_type (
    id SERIAL PRIMARY KEY,
    code VARCHAR(30) NOT NULL UNIQUE,
    nom VARCHAR(50) NOT NULL
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
    id_reservation INTEGER NOT NULL REFERENCES reservation(id),
    id_vol_programmation INTEGER NOT NULL REFERENCES vol_programmation(id),
    place INTEGER NOT NULL,
    id_classe INTEGER NOT NULL REFERENCES classe(id),
    id_categorie_type INTEGER NOT NULL REFERENCES categorie_type(id),
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
    id_categorie_type INTEGER NOT NULL REFERENCES categorie_type(id),
    tarif DECIMAL(10,2),
    CONSTRAINT uk_tarif_vol UNIQUE (id_vol_programmation, id_classe, id_categorie_type)
);

-- ===============================
-- DONNÉES DE TEST
-- ===============================

-- Classes
INSERT INTO classe (nom) VALUES
('Première classe'),
('Économique'),
('Premium');

-- Catégories de passagers
INSERT INTO categorie_type (code, nom) VALUES
('ADULTE', 'Adulte'),
('ENFANT', 'Enfant');

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
('Nosy Be');

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
INSERT INTO tarif_vol (id_vol_programmation, id_classe, id_categorie_type, tarif)
VALUES
(1, 1, (SELECT id FROM categorie_type WHERE code = 'ADULTE'), 1200000),     -- Première classe adulte
(1, 2, (SELECT id FROM categorie_type WHERE code = 'ADULTE'), 700000),      -- Économique adulte
(1, 3, (SELECT id FROM categorie_type WHERE code = 'ADULTE'), 1000000),     -- Premium adulte
(1, 1, (SELECT id FROM categorie_type WHERE code = 'ENFANT'), 1200000),     -- Première classe enfant
(1, 2, (SELECT id FROM categorie_type WHERE code = 'ENFANT'), 500000),      -- Économique enfant (remise)
(1, 3, (SELECT id FROM categorie_type WHERE code = 'ENFANT'), 1000000);     -- Premium enfant

-- Client
INSERT INTO client (nom, prenom, email, telephone)
VALUES ('Rakoto', 'Jean', 'jean.rakoto@email.mg', '0340000000');

-- Statut réservation
INSERT INTO statut_reservation (nom)
VALUES ('Validée'), ('Annulée');

-- Réservation de test
INSERT INTO reservation (id_vol_programmation, id_client, nombre_places)
VALUES (1, 1, 3);

INSERT INTO historique_reservation (id_reservation, id_statut)
VALUES (1, 1);

INSERT INTO reservation_place (id_reservation, id_vol_programmation, place, id_classe, id_categorie_type)
VALUES
(1, 1, 31, 2, (SELECT id FROM categorie_type WHERE code = 'ADULTE')),
(1, 1, 32, 2, (SELECT id FROM categorie_type WHERE code = 'ENFANT')),
(1, 1, 81, 3, (SELECT id FROM categorie_type WHERE code = 'ADULTE'));

-- ===============================
-- FIN DU SCRIPT
-- ===============================
