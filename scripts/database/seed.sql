-- Seed data for the new schema
-- Safe to run on an empty database created from scripts/database/base.sql
-- NOTE: Uses subselects to avoid hard-coded IDs

-- Airports
INSERT INTO aeroport (nom) VALUES
  ('TNR'),
  ('NOS'),
  ('DIE'),
  ('TMM')
ON CONFLICT DO NOTHING;

-- Aircraft
INSERT INTO avion (matricule, capacite) VALUES
  ('5R-MBA', 180),
  ('5R-MBB', 220),
  ('5R-MBC', 72)
ON CONFLICT DO NOTHING;

-- Pilots
INSERT INTO pilote (nom, prenom) VALUES
  ('Rakoto', 'Jean'),
  ('Rabe', 'Paul'),
  ('Andriamanitra', 'Luc'),
  ('Raharinirina', 'Miora')
ON CONFLICT DO NOTHING;

-- Clients
INSERT INTO client (nom, prenom, email, telephone) VALUES
  ('Randria', 'Sarah', 'sarah@mail.com', '0341234567'),
  ('Rakoto', 'Michel', 'michel@mail.com', '0329876543'),
  ('Razan', 'Lova', 'lova@mail.com', '0331112233')
ON CONFLICT DO NOTHING;

-- Classes
INSERT INTO classe (nom) VALUES
  ('Economique'),
  ('Business'),
  ('Premium')
ON CONFLICT DO NOTHING;

-- Classe/places per aircraft
-- Avion 5R-MBA: Eco 1..160, Business 161..180
INSERT INTO classe_place (id_classe, place_debut, place_fin, id_avion)
VALUES
  ((SELECT id FROM classe WHERE nom='Economique'), 1, 160, (SELECT id FROM avion WHERE matricule='5R-MBA')),
  ((SELECT id FROM classe WHERE nom='Business'),   161, 180, (SELECT id FROM avion WHERE matricule='5R-MBA'))
ON CONFLICT DO NOTHING;

-- Avion 5R-MBB: Eco 1..190, Business 191..220
INSERT INTO classe_place (id_classe, place_debut, place_fin, id_avion)
VALUES
  ((SELECT id FROM classe WHERE nom='Economique'), 1, 190, (SELECT id FROM avion WHERE matricule='5R-MBB')),
  ((SELECT id FROM classe WHERE nom='Business'),   191, 220, (SELECT id FROM avion WHERE matricule='5R-MBB'))
ON CONFLICT DO NOTHING;

-- Avion 5R-MBC (72): Eco 1..60, Premium 61..72
INSERT INTO classe_place (id_classe, place_debut, place_fin, id_avion)
VALUES
  ((SELECT id FROM classe WHERE nom='Economique'), 1, 60, (SELECT id FROM avion WHERE matricule='5R-MBC')),
  ((SELECT id FROM classe WHERE nom='Premium'),    61, 72, (SELECT id FROM avion WHERE matricule='5R-MBC'))
ON CONFLICT DO NOTHING;

-- Routes (vol)
INSERT INTO vol (id_aeroport_depart, id_aeroport_arrivee, duree) VALUES
  ((SELECT id FROM aeroport WHERE nom='TNR'), (SELECT id FROM aeroport WHERE nom='NOS'), 1.30),
  ((SELECT id FROM aeroport WHERE nom='TNR'), (SELECT id FROM aeroport WHERE nom='DIE'), 2.15),
  ((SELECT id FROM aeroport WHERE nom='TMM'), (SELECT id FROM aeroport WHERE nom='TNR'), 0.55)
ON CONFLICT DO NOTHING;

-- Vol statuses
INSERT INTO statut_vol (nom) VALUES
  ('Programmé'),
  ('Embarquement'),
  ('En vol'),
  ('Terminé'),
  ('Annulé')
ON CONFLICT DO NOTHING;

-- Scheduled flights (vol_programmation)
INSERT INTO vol_programmation (id_vol, id_avion, date_heure) VALUES
  ((SELECT id FROM vol LIMIT 1), (SELECT id FROM avion WHERE matricule='5R-MBA'), '2026-01-12 12:00:00'),
  ((SELECT id FROM vol LIMIT 1), (SELECT id FROM avion WHERE matricule='5R-MBB'), '2026-01-12 18:00:00'),
  ((SELECT id FROM vol WHERE id = (SELECT id FROM vol ORDER BY id OFFSET 1 LIMIT 1)), (SELECT id FROM avion WHERE matricule='5R-MBA'), '2026-01-13 09:00:00'),
  ((SELECT id FROM vol WHERE id = (SELECT id FROM vol ORDER BY id OFFSET 2 LIMIT 1)), (SELECT id FROM avion WHERE matricule='5R-MBC'), '2026-01-14 07:30:00')
ON CONFLICT DO NOTHING;

-- Initial status for each scheduled flight
INSERT INTO vol_programmation_statut (id_vol_programmation, id_statut)
SELECT vp.id, (SELECT id FROM statut_vol WHERE nom='Programmé')
FROM vol_programmation vp
ON CONFLICT DO NOTHING;

-- Pilot assignment per scheduled flight
INSERT INTO vol_programmation_pilote (id_vol_programmation, id_pilote, role)
SELECT vp.id, (SELECT id FROM pilote WHERE nom='Rakoto' AND prenom='Jean'), 'Commandant'
FROM vol_programmation vp
ON CONFLICT DO NOTHING;
INSERT INTO vol_programmation_pilote (id_vol_programmation, id_pilote, role)
SELECT vp.id, (SELECT id FROM pilote WHERE nom='Rabe' AND prenom='Paul'), 'Copilote'
FROM vol_programmation vp
ON CONFLICT DO NOTHING;

-- Tariffs per class and scheduled flight
-- Economique
INSERT INTO tarif_vol (id_vol_programmation, id_classe, tarif)
SELECT vp.id, (SELECT id FROM classe WHERE nom='Economique'), 350000
FROM vol_programmation vp
ON CONFLICT DO NOTHING;
-- Business
INSERT INTO tarif_vol (id_vol_programmation, id_classe, tarif)
SELECT vp.id, (SELECT id FROM classe WHERE nom='Business'), 750000
FROM vol_programmation vp
ON CONFLICT DO NOTHING;
-- Premium (only where aircraft has premium class)
INSERT INTO tarif_vol (id_vol_programmation, id_classe, tarif)
SELECT vp.id, (SELECT id FROM classe WHERE nom='Premium'), 950000
FROM vol_programmation vp
WHERE vp.id_avion = (SELECT id FROM avion WHERE matricule='5R-MBC')
ON CONFLICT DO NOTHING;

-- Reservation statuses
INSERT INTO statut_reservation (nom) VALUES
  ('En attente'),
  ('Confirmée'),
  ('Annulée')
ON CONFLICT DO NOTHING;

-- Sample reservations
-- 2 seats on first scheduled flight for Sarah
INSERT INTO reservation (id_vol_programmation, id_client, nombre_places)
VALUES (
  (SELECT id FROM vol_programmation ORDER BY id LIMIT 1),
  (SELECT id FROM client WHERE email='sarah@mail.com'),
  2
);
-- 1 seat on first scheduled flight for Michel
INSERT INTO reservation (id_vol_programmation, id_client, nombre_places)
VALUES (
  (SELECT id FROM vol_programmation ORDER BY id LIMIT 1),
  (SELECT id FROM client WHERE email='michel@mail.com'),
  1
);

-- Assign concrete seats (ensure they fall into defined classe_place ranges)
INSERT INTO reservation_place (id_reservation, id_vol_programmation, place)
VALUES
  ((SELECT id FROM reservation ORDER BY id LIMIT 1), (SELECT id FROM vol_programmation ORDER BY id LIMIT 1), 10),
  ((SELECT id FROM reservation ORDER BY id LIMIT 1), (SELECT id FROM vol_programmation ORDER BY id LIMIT 1), 11),
  ((SELECT id FROM reservation ORDER BY id OFFSET 1 LIMIT 1), (SELECT id FROM vol_programmation ORDER BY id LIMIT 1), 12)
ON CONFLICT DO NOTHING;

-- Reservation history
INSERT INTO historique_reservation (id_reservation, id_statut)
SELECT r.id, (SELECT id FROM statut_reservation WHERE nom='Confirmée')
FROM reservation r
ON CONFLICT DO NOTHING;
