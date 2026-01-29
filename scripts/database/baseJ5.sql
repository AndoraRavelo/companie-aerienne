-- ===============================
-- DONNÉES J5 : CA PAR VOL PROGRAMMÉ
-- ===============================
-- Ce script ajoute 3 vols programmés TNR -> NOS (Nosy Be) avec:
-- - billets adulte économique: 40 / 30 / 50
-- - diffusions pubs: (Vaniala 1, Lewis 1) / (Socobis 2, Jejoo 1) / (0)
-- - tarif adulte économique: 800000 Ar

-- Aéroports
INSERT INTO aeroport (nom)
SELECT 'TNR'
WHERE NOT EXISTS (SELECT 1 FROM aeroport WHERE nom = 'TNR');

INSERT INTO aeroport (nom)
SELECT 'NOS'
WHERE NOT EXISTS (SELECT 1 FROM aeroport WHERE nom = 'NOS');

-- Avion
INSERT INTO avion (matricule, capacite)
SELECT 'ATR - 045', 72
WHERE NOT EXISTS (SELECT 1 FROM avion WHERE matricule = 'ATR - 045');

-- Classe / Catégorie
INSERT INTO classe (nom)
SELECT 'Economique'
WHERE NOT EXISTS (SELECT 1 FROM classe WHERE nom = 'Economique');

INSERT INTO categorie_type (code, nom, base_code, coefficient)
SELECT 'ADULTE', 'Adulte', NULL, NULL
WHERE NOT EXISTS (SELECT 1 FROM categorie_type WHERE code = 'ADULTE');

-- Répartition des places (Eco 1..72)
INSERT INTO classe_place (id_classe, place_debut, place_fin, id_avion)
SELECT
  (SELECT id FROM classe WHERE nom = 'Economique'),
  1,
  72,
  (SELECT id FROM avion WHERE matricule = 'ATR - 045')
WHERE NOT EXISTS (
  SELECT 1
  FROM classe_place cp
  WHERE cp.id_classe = (SELECT id FROM classe WHERE nom = 'Economique')
    AND cp.id_avion = (SELECT id FROM avion WHERE matricule = 'ATR - 045')
);

-- Route / vol (TNR -> NOS)
INSERT INTO vol (id_aeroport_depart, id_aeroport_arrivee, duree)
SELECT
  (SELECT id FROM aeroport WHERE nom = 'TNR'),
  (SELECT id FROM aeroport WHERE nom = 'NOS'),
  1.50
WHERE NOT EXISTS (
  SELECT 1
  FROM vol v
  WHERE v.id_aeroport_depart = (SELECT id FROM aeroport WHERE nom = 'TNR')
    AND v.id_aeroport_arrivee = (SELECT id FROM aeroport WHERE nom = 'NOS')
);

-- Statut vol minimum
INSERT INTO statut_vol (nom)
SELECT 'Programmé'
WHERE NOT EXISTS (SELECT 1 FROM statut_vol WHERE nom = 'Programmé');

-- 3 vols programmés
INSERT INTO vol_programmation (id_vol, id_avion, date_heure)
SELECT
  (SELECT id FROM vol v WHERE v.id_aeroport_depart = (SELECT id FROM aeroport WHERE nom='TNR') AND v.id_aeroport_arrivee = (SELECT id FROM aeroport WHERE nom='NOS') LIMIT 1),
  (SELECT id FROM avion WHERE matricule = 'ATR - 045'),
  TIMESTAMP '2026-01-20 10:00:00'
WHERE NOT EXISTS (
  SELECT 1 FROM vol_programmation vp
  WHERE vp.date_heure = TIMESTAMP '2026-01-20 10:00:00'
    AND vp.id_avion = (SELECT id FROM avion WHERE matricule = 'ATR - 045')
);

INSERT INTO vol_programmation (id_vol, id_avion, date_heure)
SELECT
  (SELECT id FROM vol v WHERE v.id_aeroport_depart = (SELECT id FROM aeroport WHERE nom='TNR') AND v.id_aeroport_arrivee = (SELECT id FROM aeroport WHERE nom='NOS') LIMIT 1),
  (SELECT id FROM avion WHERE matricule = 'ATR - 045'),
  TIMESTAMP '2026-01-21 10:00:00'
WHERE NOT EXISTS (
  SELECT 1 FROM vol_programmation vp
  WHERE vp.date_heure = TIMESTAMP '2026-01-21 10:00:00'
    AND vp.id_avion = (SELECT id FROM avion WHERE matricule = 'ATR - 045')
);

INSERT INTO vol_programmation (id_vol, id_avion, date_heure)
SELECT
  (SELECT id FROM vol v WHERE v.id_aeroport_depart = (SELECT id FROM aeroport WHERE nom='TNR') AND v.id_aeroport_arrivee = (SELECT id FROM aeroport WHERE nom='NOS') LIMIT 1),
  (SELECT id FROM avion WHERE matricule = 'ATR - 045'),
  TIMESTAMP '2026-01-21 15:00:00'
WHERE NOT EXISTS (
  SELECT 1 FROM vol_programmation vp
  WHERE vp.date_heure = TIMESTAMP '2026-01-21 15:00:00'
    AND vp.id_avion = (SELECT id FROM avion WHERE matricule = 'ATR - 045')
);

-- Status initial
INSERT INTO vol_programmation_statut (id_vol_programmation, id_statut)
SELECT vp.id, (SELECT id FROM statut_vol WHERE nom='Programmé')
FROM vol_programmation vp
WHERE vp.id_avion = (SELECT id FROM avion WHERE matricule = 'ATR - 045')
  AND vp.date_heure IN (TIMESTAMP '2026-01-20 10:00:00', TIMESTAMP '2026-01-21 10:00:00', TIMESTAMP '2026-01-21 15:00:00')
ON CONFLICT DO NOTHING;

-- Tarifs : adulte + économique = 800000 Ar
INSERT INTO tarif_vol (id_vol_programmation, id_classe, id_categorie_type, tarif)
SELECT
  vp.id,
  (SELECT id FROM classe WHERE nom='Economique'),
  (SELECT id FROM categorie_type WHERE code='ADULTE'),
  800000
FROM vol_programmation vp
WHERE vp.id_avion = (SELECT id FROM avion WHERE matricule = 'ATR - 045')
  AND vp.date_heure IN (TIMESTAMP '2026-01-20 10:00:00', TIMESTAMP '2026-01-21 10:00:00', TIMESTAMP '2026-01-21 15:00:00')
ON CONFLICT DO NOTHING;

-- Client technique pour générer les réservations
INSERT INTO client (nom, prenom, email, telephone)
SELECT 'Test', 'J5', 'j5@test.mg', '0340000000'
WHERE NOT EXISTS (SELECT 1 FROM client WHERE email = 'j5@test.mg');

-- =====================================================
-- RÉSERVATIONS + PLACES
-- Chaque ticket = 1 reservation + 1 reservation_place
-- =====================================================

-- Vol du 20/01/2026 10h : 40 billets eco adulte
DO $$
DECLARE
  vp_id INTEGER;
  c_id INTEGER;
  i INTEGER;
  r_id INTEGER;
BEGIN
  SELECT id INTO vp_id FROM vol_programmation
  WHERE id_avion = (SELECT id FROM avion WHERE matricule='ATR - 045')
    AND date_heure = TIMESTAMP '2026-01-20 10:00:00'
  LIMIT 1;

  SELECT id INTO c_id FROM client WHERE email='j5@test.mg' LIMIT 1;

  FOR i IN 1..40 LOOP
    INSERT INTO reservation (id_vol_programmation, id_client, nombre_places)
    VALUES (vp_id, c_id, 1)
    RETURNING id INTO r_id;

    INSERT INTO reservation_place (id_reservation, id_vol_programmation, place, id_classe, id_categorie_type)
    VALUES (r_id, vp_id, i,
            (SELECT id FROM classe WHERE nom='Economique'),
            (SELECT id FROM categorie_type WHERE code='ADULTE'));
  END LOOP;
END $$;

-- Vol du 21/01/2026 10h : 30 billets eco adulte
DO $$
DECLARE
  vp_id INTEGER;
  c_id INTEGER;
  i INTEGER;
  r_id INTEGER;
BEGIN
  SELECT id INTO vp_id FROM vol_programmation
  WHERE id_avion = (SELECT id FROM avion WHERE matricule='ATR - 045')
    AND date_heure = TIMESTAMP '2026-01-21 10:00:00'
  LIMIT 1;

  SELECT id INTO c_id FROM client WHERE email='j5@test.mg' LIMIT 1;

  FOR i IN 1..30 LOOP
    INSERT INTO reservation (id_vol_programmation, id_client, nombre_places)
    VALUES (vp_id, c_id, 1)
    RETURNING id INTO r_id;

    INSERT INTO reservation_place (id_reservation, id_vol_programmation, place, id_classe, id_categorie_type)
    VALUES (r_id, vp_id, i,
            (SELECT id FROM classe WHERE nom='Economique'),
            (SELECT id FROM categorie_type WHERE code='ADULTE'));
  END LOOP;
END $$;

-- Vol du 21/01/2026 15h : 50 billets eco adulte
DO $$
DECLARE
  vp_id INTEGER;
  c_id INTEGER;
  i INTEGER;
  r_id INTEGER;
BEGIN
  SELECT id INTO vp_id FROM vol_programmation
  WHERE id_avion = (SELECT id FROM avion WHERE matricule='ATR - 045')
    AND date_heure = TIMESTAMP '2026-01-21 15:00:00'
  LIMIT 1;

  SELECT id INTO c_id FROM client WHERE email='j5@test.mg' LIMIT 1;

  FOR i IN 1..50 LOOP
    INSERT INTO reservation (id_vol_programmation, id_client, nombre_places)
    VALUES (vp_id, c_id, 1)
    RETURNING id INTO r_id;

    INSERT INTO reservation_place (id_reservation, id_vol_programmation, place, id_classe, id_categorie_type)
    VALUES (r_id, vp_id, i,
            (SELECT id FROM classe WHERE nom='Economique'),
            (SELECT id FROM categorie_type WHERE code='ADULTE'));
  END LOOP;
END $$;

-- =====================================================
-- PUBLICITÉS
-- =====================================================

-- Tarif de diffusion pub (si pas déjà présent)
INSERT INTO tarif_diffusion_pub (montant, date_debut, date_fin)
SELECT 400000, DATE '2025-01-01', NULL
WHERE NOT EXISTS (
  SELECT 1 FROM tarif_diffusion_pub
  WHERE date_debut = DATE '2025-01-01' AND date_fin IS NULL
);

-- Sociétés
INSERT INTO societe (nom)
SELECT 'Vaniala'
WHERE NOT EXISTS (SELECT 1 FROM societe WHERE lower(nom)=lower('Vaniala'));

INSERT INTO societe (nom)
SELECT 'Lewis'
WHERE NOT EXISTS (SELECT 1 FROM societe WHERE lower(nom)=lower('Lewis'));

INSERT INTO societe (nom)
SELECT 'Socobis'
WHERE NOT EXISTS (SELECT 1 FROM societe WHERE lower(nom)=lower('Socobis'));

INSERT INTO societe (nom)
SELECT 'Jejoo'
WHERE NOT EXISTS (SELECT 1 FROM societe WHERE lower(nom)=lower('Jejoo'));

-- Vidéos
INSERT INTO video_publicitaire (id_societe, titre)
SELECT (SELECT id FROM societe WHERE lower(nom)=lower('Vaniala') LIMIT 1), 'Pub Vaniala'
WHERE NOT EXISTS (SELECT 1 FROM video_publicitaire WHERE titre='Pub Vaniala');

INSERT INTO video_publicitaire (id_societe, titre)
SELECT (SELECT id FROM societe WHERE lower(nom)=lower('Lewis') LIMIT 1), 'Pub Lewis'
WHERE NOT EXISTS (SELECT 1 FROM video_publicitaire WHERE titre='Pub Lewis');

INSERT INTO video_publicitaire (id_societe, titre)
SELECT (SELECT id FROM societe WHERE lower(nom)=lower('Socobis') LIMIT 1), 'Pub Socobis'
WHERE NOT EXISTS (SELECT 1 FROM video_publicitaire WHERE titre='Pub Socobis');

INSERT INTO video_publicitaire (id_societe, titre)
SELECT (SELECT id FROM societe WHERE lower(nom)=lower('Jejoo') LIMIT 1), 'Pub Jejoo'
WHERE NOT EXISTS (SELECT 1 FROM video_publicitaire WHERE titre='Pub Jejoo');

-- Diffusions
-- 20/01 10h : Vaniala 1, Lewis 1
INSERT INTO diffusion_pub (id_vol_programmation, id_video_publicitaire, nombre_diffusions)
VALUES (
  (SELECT id FROM vol_programmation WHERE date_heure=TIMESTAMP '2026-01-20 10:00:00' AND id_avion=(SELECT id FROM avion WHERE matricule='ATR - 045') LIMIT 1),
  (SELECT id FROM video_publicitaire WHERE titre='Pub Vaniala' LIMIT 1),
  1
)
ON CONFLICT DO NOTHING;

INSERT INTO diffusion_pub (id_vol_programmation, id_video_publicitaire, nombre_diffusions)
VALUES (
  (SELECT id FROM vol_programmation WHERE date_heure=TIMESTAMP '2026-01-20 10:00:00' AND id_avion=(SELECT id FROM avion WHERE matricule='ATR - 045') LIMIT 1),
  (SELECT id FROM video_publicitaire WHERE titre='Pub Lewis' LIMIT 1),
  1
)
ON CONFLICT DO NOTHING;

-- 21/01 10h : Socobis 2, Jejoo 1
INSERT INTO diffusion_pub (id_vol_programmation, id_video_publicitaire, nombre_diffusions)
VALUES (
  (SELECT id FROM vol_programmation WHERE date_heure=TIMESTAMP '2026-01-21 10:00:00' AND id_avion=(SELECT id FROM avion WHERE matricule='ATR - 045') LIMIT 1),
  (SELECT id FROM video_publicitaire WHERE titre='Pub Socobis' LIMIT 1),
  2
)
ON CONFLICT DO NOTHING;

INSERT INTO diffusion_pub (id_vol_programmation, id_video_publicitaire, nombre_diffusions)
VALUES (
  (SELECT id FROM vol_programmation WHERE date_heure=TIMESTAMP '2026-01-21 10:00:00' AND id_avion=(SELECT id FROM avion WHERE matricule='ATR - 045') LIMIT 1),
  (SELECT id FROM video_publicitaire WHERE titre='Pub Jejoo' LIMIT 1),
  1
)
ON CONFLICT DO NOTHING;

-- Ajuste les séquences
SELECT setval(pg_get_serial_sequence('avion', 'id'), (SELECT COALESCE(MAX(id), 1) FROM avion), true);
SELECT setval(pg_get_serial_sequence('aeroport', 'id'), (SELECT COALESCE(MAX(id), 1) FROM aeroport), true);
SELECT setval(pg_get_serial_sequence('vol', 'id'), (SELECT COALESCE(MAX(id), 1) FROM vol), true);
SELECT setval(pg_get_serial_sequence('statut_vol', 'id'), (SELECT COALESCE(MAX(id), 1) FROM statut_vol), true);
SELECT setval(pg_get_serial_sequence('vol_programmation', 'id'), (SELECT COALESCE(MAX(id), 1) FROM vol_programmation), true);
SELECT setval(pg_get_serial_sequence('vol_programmation_statut', 'id'), (SELECT COALESCE(MAX(id), 1) FROM vol_programmation_statut), true);
SELECT setval(pg_get_serial_sequence('client', 'id'), (SELECT COALESCE(MAX(id), 1) FROM client), true);
SELECT setval(pg_get_serial_sequence('classe', 'id'), (SELECT COALESCE(MAX(id), 1) FROM classe), true);
SELECT setval(pg_get_serial_sequence('categorie_type', 'id'), (SELECT COALESCE(MAX(id), 1) FROM categorie_type), true);
SELECT setval(pg_get_serial_sequence('reservation', 'id'), (SELECT COALESCE(MAX(id), 1) FROM reservation), true);
SELECT setval(pg_get_serial_sequence('tarif_vol', 'id'), (SELECT COALESCE(MAX(id), 1) FROM tarif_vol), true);
SELECT setval(pg_get_serial_sequence('societe', 'id'), (SELECT COALESCE(MAX(id), 1) FROM societe), true);
SELECT setval(pg_get_serial_sequence('video_publicitaire', 'id'), (SELECT COALESCE(MAX(id), 1) FROM video_publicitaire), true);
SELECT setval(pg_get_serial_sequence('tarif_diffusion_pub', 'id'), (SELECT COALESCE(MAX(id), 1) FROM tarif_diffusion_pub), true);
SELECT setval(pg_get_serial_sequence('diffusion_pub', 'id'), (SELECT COALESCE(MAX(id), 1) FROM diffusion_pub), true);
