DROP TABLE IF EXISTS
  diffusion_pub,
  paiement_pub,
  tarif_diffusion_pub,
  video_publicitaire,
  societe,
  tarif_vol,
  historique_reservation,
  reservation_place,
  reservation,
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
 -- DONNÉES DE TEST SIMPLES (IDs fixes)
 -- ===============================
 INSERT INTO avion (id, matricule, capacite) VALUES (1, 'AV-DEMO-001', 120);
 INSERT INTO aeroport (id, nom) VALUES (1, 'Antananarivo');
 INSERT INTO aeroport (id, nom) VALUES (2, 'Nosy Be');
 INSERT INTO pilote (id, nom, prenom) VALUES (1, 'Rakoto', 'Pilote');
 INSERT INTO statut_vol (id, nom) VALUES (1, 'Programmé');
 INSERT INTO vol (id, id_aeroport_depart, id_aeroport_arrivee, duree) VALUES (1, 1, 2, 1.30);

 -- Un vol programmé (fonctionnalités existantes)
 INSERT INTO vol_programmation (id, id_vol, id_avion, date_heure) VALUES (1, 1, 1, '2026-02-01 08:00:00');
 INSERT INTO vol_programmation_statut (id, id_vol_programmation, id_statut) VALUES (1, 1, 1);
 INSERT INTO vol_programmation_pilote (id_vol_programmation, id_pilote, role) VALUES (1, 1, 'Commandant');
 INSERT INTO avion_pilote (id_avion, id_pilote, date) VALUES (1, 1, CURRENT_DATE);

 INSERT INTO client (id, nom, prenom, email, telephone)
 VALUES (1, 'Rakoto', 'Jean', 'jean.rakoto@email.mg', '0340000000');

 INSERT INTO classe (id, nom) VALUES (1, 'Première classe');
 INSERT INTO classe (id, nom) VALUES (2, 'Économique');
 INSERT INTO classe (id, nom) VALUES (3, 'Premium');

 INSERT INTO classe_place (id_classe, place_debut, place_fin, id_avion) VALUES (1, 1, 30, 1);
 INSERT INTO classe_place (id_classe, place_debut, place_fin, id_avion) VALUES (2, 31, 80, 1);
 INSERT INTO classe_place (id_classe, place_debut, place_fin, id_avion) VALUES (3, 81, 120, 1);

 INSERT INTO categorie_type (id, code, nom, base_code, coefficient)
 VALUES (1, 'ADULTE', 'Adulte', NULL, NULL);
 INSERT INTO categorie_type (id, code, nom, base_code, coefficient)
 VALUES (2, 'ENFANT', 'Enfant', NULL, NULL);
 INSERT INTO categorie_type (id, code, nom, base_code, coefficient)
 VALUES (3, 'BEBE', 'Bébé', 'ADULTE', 0.10);

 INSERT INTO statut_reservation (id, nom) VALUES (1, 'Validée');

 INSERT INTO tarif_vol (id, id_vol_programmation, id_classe, id_categorie_type, tarif) VALUES (1, 1, 1, 1, 2000000);
 INSERT INTO tarif_vol (id, id_vol_programmation, id_classe, id_categorie_type, tarif) VALUES (2, 1, 3, 1, 1000000);
 INSERT INTO tarif_vol (id, id_vol_programmation, id_classe, id_categorie_type, tarif) VALUES (3, 1, 2, 1, 900000);
 INSERT INTO tarif_vol (id, id_vol_programmation, id_classe, id_categorie_type, tarif) VALUES (4, 1, 1, 2, 800000);
 INSERT INTO tarif_vol (id, id_vol_programmation, id_classe, id_categorie_type, tarif) VALUES (5, 1, 3, 2, 700000);
 INSERT INTO tarif_vol (id, id_vol_programmation, id_classe, id_categorie_type, tarif) VALUES (6, 1, 2, 2, 600000);

 -- ===============================
 -- DONNÉES J4 : PUBLICITÉS (Vaniala 20, Lewis 10) EN DÉCEMBRE 2025
 -- ===============================
 INSERT INTO tarif_diffusion_pub (id, montant, date_debut, date_fin) VALUES (1, 400000, '2025-01-01', NULL);

 -- Un seul vol programmé en décembre 2025 pour tester le CA
 INSERT INTO vol_programmation (id, id_vol, id_avion, date_heure) VALUES (2, 1, 1, '2025-12-15 08:00:00');
 INSERT INTO vol_programmation_statut (id, id_vol_programmation, id_statut) VALUES (2, 2, 1);
 INSERT INTO vol_programmation_pilote (id_vol_programmation, id_pilote, role) VALUES (2, 1, 'Commandant');

 INSERT INTO societe (id, nom) VALUES (1, 'Vaniala');
 INSERT INTO societe (id, nom) VALUES (2, 'Lewis');

 -- Paiement : Vaniala a payé 1 000 000 Ar le 15/12/2025
 INSERT INTO paiement_pub (id, id_societe, date_paiement, montant) VALUES (1, 1, '2025-12-15', 1000000);
 INSERT INTO paiement_pub (id, id_societe, date_paiement, montant) VALUES (2, 1, '2025-12-15', 2000000);
 DELETE FROM paiement_pub WHERE id = 2;
 SELECT * FROM paiement_pub;

 INSERT INTO video_publicitaire (id, id_societe, titre) VALUES (1, 1, 'Pub Vaniala');
 INSERT INTO video_publicitaire (id, id_societe, titre) VALUES (2, 2, 'Pub Lewis');

 INSERT INTO diffusion_pub (id, id_vol_programmation, id_video_publicitaire, nombre_diffusions)
 VALUES (1, 2, 1, 20);
 INSERT INTO diffusion_pub (id, id_vol_programmation, id_video_publicitaire, nombre_diffusions)
 VALUES (2, 2, 2, 10);

 -- Ajuste les séquences (pour éviter collision si tu ajoutes ensuite des lignes sans spécifier id)
 SELECT setval(pg_get_serial_sequence('avion', 'id'), (SELECT COALESCE(MAX(id), 1) FROM avion), true);
 SELECT setval(pg_get_serial_sequence('aeroport', 'id'), (SELECT COALESCE(MAX(id), 1) FROM aeroport), true);
 SELECT setval(pg_get_serial_sequence('pilote', 'id'), (SELECT COALESCE(MAX(id), 1) FROM pilote), true);
 SELECT setval(pg_get_serial_sequence('vol', 'id'), (SELECT COALESCE(MAX(id), 1) FROM vol), true);
 SELECT setval(pg_get_serial_sequence('statut_vol', 'id'), (SELECT COALESCE(MAX(id), 1) FROM statut_vol), true);
 SELECT setval(pg_get_serial_sequence('vol_programmation', 'id'), (SELECT COALESCE(MAX(id), 1) FROM vol_programmation), true);
 SELECT setval(pg_get_serial_sequence('vol_programmation_statut', 'id'), (SELECT COALESCE(MAX(id), 1) FROM vol_programmation_statut), true);
 SELECT setval(pg_get_serial_sequence('client', 'id'), (SELECT COALESCE(MAX(id), 1) FROM client), true);
 SELECT setval(pg_get_serial_sequence('classe', 'id'), (SELECT COALESCE(MAX(id), 1) FROM classe), true);
 SELECT setval(pg_get_serial_sequence('categorie_type', 'id'), (SELECT COALESCE(MAX(id), 1) FROM categorie_type), true);
 SELECT setval(pg_get_serial_sequence('statut_reservation', 'id'), (SELECT COALESCE(MAX(id), 1) FROM statut_reservation), true);
 SELECT setval(pg_get_serial_sequence('tarif_vol', 'id'), (SELECT COALESCE(MAX(id), 1) FROM tarif_vol), true);
 SELECT setval(pg_get_serial_sequence('societe', 'id'), (SELECT COALESCE(MAX(id), 1) FROM societe), true);
 SELECT setval(pg_get_serial_sequence('video_publicitaire', 'id'), (SELECT COALESCE(MAX(id), 1) FROM video_publicitaire), true);
 SELECT setval(pg_get_serial_sequence('tarif_diffusion_pub', 'id'), (SELECT COALESCE(MAX(id), 1) FROM tarif_diffusion_pub), true);
 SELECT setval(pg_get_serial_sequence('diffusion_pub', 'id'), (SELECT COALESCE(MAX(id), 1) FROM diffusion_pub), true);