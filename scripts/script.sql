-- =========================
-- AEROPORTS
-- =========================
INSERT INTO aeroport (nom) VALUES
('TNR'),
('NOS'),
('DIE'),
('TMM');

-- =========================
-- AVIONS
-- =========================
INSERT INTO avion (matricule, capacite) VALUES
('5R-MBA', 180),
('5R-MBB', 220);

-- =========================
-- PILOTES
-- =========================
INSERT INTO pilote (nom, prenom) VALUES
('Rakoto', 'Jean'),
('Rabe', 'Paul'),
('Andriamanitra', 'Luc');

-- =========================
-- CLIENTS
-- =========================
INSERT INTO client (nom, prenom, email, telephone) VALUES
('Randria', 'Sarah', 'sarah@mail.com', '0341234567'),
('Rakoto', 'Michel', 'michel@mail.com', '0329876543');

-- =========================
-- CLASSES
-- =========================
INSERT INTO classe (nom) VALUES
('Economique'),
('Business');

-- =========================
-- CLASSES / PLACES PAR AVION
-- =========================
-- Avion 1
INSERT INTO classe_place VALUES
(1, 1, 150, 1),   -- Economique
(2, 151, 180, 1); -- Business

-- Avion 2
INSERT INTO classe_place VALUES
(1, 1, 180, 2),
(2, 181, 220, 2);

-- =========================
-- VOLS (ROUTES)
-- =========================
INSERT INTO vol (id_aeroport_depart, id_aeroport_arrivee, duree) VALUES
(1, 2, 1.30), -- TNR -> NOS
(1, 3, 2.15); -- TNR -> DIE

-- =========================
-- STATUTS DE VOL
-- =========================
INSERT INTO statut_vol (nom) VALUES
('Programmé'),
('Embarquement'),
('En vol'),
('Terminé'),
('Annulé');

-- =========================
-- PROGRAMMATION DES VOLS
-- =========================
INSERT INTO vol_programmation (id_vol, id_avion, date_heure) VALUES
(1, 1, '2026-01-12 12:00:00'), -- TNR -> NOS
(1, 2, '2026-01-12 18:00:00'),
(2, 1, '2026-01-13 09:00:00');

-- =========================
-- STATUT DES PROGRAMMATIONS
-- =========================
INSERT INTO vol_programmation_statut (id_vol_programmation, id_statut) VALUES
(1, 1),
(2, 1),
(3, 1);

-- =========================
-- PILOTES PAR VOL
-- =========================
INSERT INTO vol_programmation_pilote VALUES
(1, 1, 'Commandant'),
(1, 2, 'Copilote'),
(2, 2, 'Commandant'),
(2, 3, 'Copilote');

-- =========================
-- TARIFS
-- =========================
INSERT INTO tarif_vol (id_vol_programmation, id_classe, tarif) VALUES
(1, 1, 350000), -- Economique
(1, 2, 750000), -- Business
(2, 1, 360000),
(2, 2, 780000);

-- =========================
-- STATUTS DE RESERVATION
-- =========================
INSERT INTO statut_reservation (nom) VALUES
('En attente'),
('Confirmée'),
('Annulée');

-- =========================
-- RESERVATIONS
-- =========================
INSERT INTO reservation (id_vol_programmation, id_client, nombre_places) VALUES
(1, 1, 2),
(1, 2, 1);

-- =========================
-- PLACES RESERVEES
-- =========================
INSERT INTO reservation_place VALUES
(1, 1, 10),
(1, 1, 11),
(2, 1, 12);

-- =========================
-- HISTORIQUE DES RESERVATIONS
-- =========================
INSERT INTO historique_reservation (id_reservation, id_statut) VALUES
(1, 2),
(2, 1);
