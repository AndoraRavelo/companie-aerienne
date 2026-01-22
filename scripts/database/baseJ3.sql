CREATE TABLE avion (
   id SERIAL PRIMARY KEY,
   matricule VARCHAR(50),
   capacite INTEGER
);

-- Création de la table Aeroport
CREATE TABLE aeroport (
   id SERIAL PRIMARY KEY,
   nom VARCHAR(100)
);

-- Création de la table Pilote
CREATE TABLE pilote (
   id SERIAL PRIMARY KEY,
   nom VARCHAR(100),
   prenom VARCHAR(100)
);

-- Création de la table Vol
CREATE TABLE vol (
   id SERIAL PRIMARY KEY,
   id_aeroport_depart INTEGER REFERENCES aeroport(id),
   id_aeroport_arrivee INTEGER REFERENCES aeroport(id),
   duree DECIMAL(5,2)
);

-- Création de la table StatutVol
CREATE TABLE statut_vol (
   id SERIAL PRIMARY KEY,
   nom VARCHAR(50)
);

-- Création de la table VolProgrammation (L'avion est assigné à la programmation)
CREATE TABLE vol_programmation (
   id serial primary key,
   id_vol INTEGER REFERENCES vol(id),
   id_avion INTEGER REFERENCES avion(id),
   date_heure TIMESTAMP
);

-- Historique des statuts d'une programmation de vol
CREATE TABLE vol_programmation_statut (
   id SERIAL PRIMARY KEY,
   id_vol_programmation INTEGER REFERENCES vol_programmation(id),
   id_statut INTEGER REFERENCES statut_vol(id),
   date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Affectation des pilotes à une programmation de vol (plus réaliste que sur l'avion)
CREATE TABLE vol_programmation_pilote (
   id_vol_programmation INTEGER NOT NULL REFERENCES vol_programmation(id),
   id_pilote INTEGER NOT NULL REFERENCES pilote(id),
   role VARCHAR(30),
   PRIMARY KEY (id_vol_programmation, id_pilote)
);

-- Création de la table AvionPilote
CREATE TABLE avion_pilote (
   id_avion INTEGER REFERENCES avion(id),
   id_pilote INTEGER REFERENCES pilote(id),
   date DATE,
   PRIMARY KEY (id_avion, id_pilote, date)
);

-- Création de la table Client
CREATE TABLE client (
   id SERIAL PRIMARY KEY,
   nom VARCHAR(100),
   prenom VARCHAR(100),
   email VARCHAR(150),
   telephone VARCHAR(20)
);

-- Création de la table Classe
CREATE TABLE classe (
   id SERIAL PRIMARY KEY,
   nom VARCHAR(50)
);

-- Création de la table CategorieType (adulte, enfant, ...)
CREATE TABLE categorie_type (
   id SERIAL PRIMARY KEY,
   code VARCHAR(30) NOT NULL UNIQUE,
   nom VARCHAR(50) NOT NULL,
   base_code VARCHAR(30),
   coefficient DECIMAL(10,4)
);

-- Création de la table ClassePlace (définit les plages de sièges par classe et par avion)
CREATE TABLE classe_place (
   id_classe INTEGER REFERENCES classe(id),
   place_debut INTEGER,
   place_fin INTEGER,
   id_avion INTEGER REFERENCES avion(id),
   PRIMARY KEY (id_classe, id_avion)
);

-- Création de la table Reservation (lien vers la programmation du vol)
CREATE TABLE reservation (
   id SERIAL PRIMARY KEY,
   id_vol_programmation INTEGER REFERENCES vol_programmation(id),
   id_client INTEGER REFERENCES client(id),
   nombre_places INTEGER DEFAULT 1
);

-- Création de la table ReservationPlace
CREATE TABLE reservation_place (
   id_reservation INTEGER NOT NULL REFERENCES reservation(id),
   id_vol_programmation INTEGER NOT NULL REFERENCES vol_programmation(id),
   place INTEGER NOT NULL,
   id_classe INTEGER NOT NULL REFERENCES classe(id),
   id_categorie_type INTEGER NOT NULL REFERENCES categorie_type(id),
   PRIMARY KEY (id_vol_programmation, place)
);

-- Création de la table StatutReservation
CREATE TABLE statut_reservation (
   id SERIAL PRIMARY KEY,
   nom VARCHAR(50)
);

-- Création de la table HistoriqueReservation
CREATE TABLE historique_reservation (
   id SERIAL PRIMARY KEY,
   id_reservation INTEGER REFERENCES reservation(id),
   id_statut INTEGER REFERENCES statut_reservation(id),
   date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Création de la table TarifVol
CREATE TABLE tarif_vol (
   id SERIAL PRIMARY KEY,
   id_vol_programmation INTEGER REFERENCES vol_programmation(id),
   id_classe INTEGER REFERENCES classe(id),
   id_categorie_type INTEGER NOT NULL REFERENCES categorie_type(id),
   tarif DECIMAL(10,2),
   CONSTRAINT uk_tarif_vol UNIQUE (id_vol_programmation, id_classe, id_categorie_type)
);

CREATE TABLE societe (
   id SERIAL PRIMARY KEY,
   nom VARCHAR(150) NOT NULL UNIQUE
);

CREATE TABLE video_publicitaire (
   id SERIAL PRIMARY KEY,
   id_societe INTEGER NOT NULL REFERENCES societe(id),
   titre VARCHAR(200)
);

CREATE TABLE tarif_diffusion_pub (
   id SERIAL PRIMARY KEY,
   montant DECIMAL(15,2) NOT NULL,
   date_debut DATE NOT NULL,
   date_fin DATE,
   CONSTRAINT ck_tarif_diffusion_pub_dates CHECK (date_fin IS NULL OR date_fin >= date_debut)
);

CREATE TABLE diffusion_pub (
   id SERIAL PRIMARY KEY,
   id_vol_programmation INTEGER NOT NULL REFERENCES vol_programmation(id),
   id_video_publicitaire INTEGER NOT NULL REFERENCES video_publicitaire(id),
   nombre_diffusions INTEGER NOT NULL,
   date_saisie TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
   CONSTRAINT ck_diffusion_pub_nombre CHECK (nombre_diffusions > 0),
   CONSTRAINT uk_diffusion_pub UNIQUE (id_vol_programmation, id_video_publicitaire)
);

CREATE TABLE paiement_pub (
   id SERIAL PRIMARY KEY,
   id_societe INTEGER NOT NULL REFERENCES societe(id),
   date_paiement DATE NOT NULL,
   montant DECIMAL(15,2) NOT NULL,
   date_saisie TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
   CONSTRAINT ck_paiement_pub_montant CHECK (montant > 0)
);

-- ===============================
-- DONNÉES DE BASE (NIVEAU 1)
-- ===============================
INSERT INTO categorie_type (code, nom) VALUES
('ADULTE', 'Adulte'),
('ENFANT', 'Enfant');

INSERT INTO tarif_diffusion_pub (montant, date_debut, date_fin) VALUES
(400000, '2025-01-01', NULL);
