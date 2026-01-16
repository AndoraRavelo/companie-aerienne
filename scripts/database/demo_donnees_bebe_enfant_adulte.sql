
--    - Première classe : BEBE 2 / ENFANT 4 / ADULTE 10
--    - Économique      : BEBE 4 / ENFANT 10 / ADULTE 30
--    - Premium         : BEBE 4 / ENFANT 5 / ADULTE 20.

DO $$
DECLARE
  avion_id INT;
  aeroport_dep_id INT;
  aeroport_arr_id INT;
  pilote_id INT;

  vol_id INT;
  statut_vol_id INT;
  vp_id INT;

  client_id INT;
  classe_first_id INT;
  classe_eco_id INT;
  classe_premium_id INT;

  cat_adulte_id INT;
  cat_enfant_id INT;
  cat_bebe_id INT;

  statut_resa_id INT;
  resa_id INT;
BEGIN
  -- ===============================
  -- Avion
  -- ===============================
  INSERT INTO avion (matricule, capacite)
  VALUES ('AV-DEMO-001', 120)
  RETURNING id INTO avion_id;

  -- ===============================
  -- Aéroports
  -- ===============================
  INSERT INTO aeroport (nom) VALUES ('Antananarivo') RETURNING id INTO aeroport_dep_id;
  INSERT INTO aeroport (nom) VALUES ('Nosy Be')      RETURNING id INTO aeroport_arr_id;

  -- ===============================
  -- Pilote
  -- ===============================
  INSERT INTO pilote (nom, prenom)
  VALUES ('Rakoto', 'Pilote')
  RETURNING id INTO pilote_id;

  -- ===============================
  -- Statut vol
  -- ===============================
  INSERT INTO statut_vol (nom)
  VALUES ('Programmé')
  RETURNING id INTO statut_vol_id;

  -- ===============================
  -- Vol + Programmation
  -- ===============================
  INSERT INTO vol (id_aeroport_depart, id_aeroport_arrivee, duree)
  VALUES (aeroport_dep_id, aeroport_arr_id, 1.30)
  RETURNING id INTO vol_id;

  INSERT INTO vol_programmation (id_vol, id_avion, date_heure)
  VALUES (vol_id, avion_id, '2026-02-01 08:00:00')
  RETURNING id INTO vp_id;

  INSERT INTO vol_programmation_statut (id_vol_programmation, id_statut)
  VALUES (vp_id, statut_vol_id);

  INSERT INTO vol_programmation_pilote (id_vol_programmation, id_pilote, role)
  VALUES (vp_id, pilote_id, 'Commandant');

  INSERT INTO avion_pilote (id_avion, id_pilote, date)
  VALUES (avion_id, pilote_id, CURRENT_DATE);

  -- ===============================
  -- Client
  -- ===============================
  INSERT INTO client (nom, prenom, email, telephone)
  VALUES ('Rakoto', 'Jean', 'jean.rakoto@email.mg', '0340000000')
  RETURNING id INTO client_id;

  -- ===============================
  -- Classes
  -- ===============================
  INSERT INTO classe (nom) VALUES ('Première classe') RETURNING id INTO classe_first_id;
  INSERT INTO classe (nom) VALUES ('Économique')      RETURNING id INTO classe_eco_id;
  INSERT INTO classe (nom) VALUES ('Premium')         RETURNING id INTO classe_premium_id;

  -- Plages de sièges (sur 120)
  INSERT INTO classe_place (id_classe, place_debut, place_fin, id_avion)
  VALUES
    (classe_first_id, 1, 30, avion_id),
    (classe_eco_id, 31, 80, avion_id),
    (classe_premium_id, 81, 120, avion_id);

  -- ===============================
  -- Catégories
  -- ===============================
  INSERT INTO categorie_type (code, nom, base_code, coefficient)
  VALUES
    ('ADULTE', 'Adulte', NULL, NULL)
  RETURNING id INTO cat_adulte_id;

  INSERT INTO categorie_type (code, nom, base_code, coefficient)
  VALUES
    ('ENFANT', 'Enfant', NULL, NULL)
  RETURNING id INTO cat_enfant_id;

  INSERT INTO categorie_type (code, nom, base_code, coefficient)
  VALUES
    ('BEBE', 'Bébé', 'ADULTE', 0.10)
  RETURNING id INTO cat_bebe_id;

  -- ===============================
  -- Statut réservation
  -- ===============================
  INSERT INTO statut_reservation (nom)
  VALUES ('Validée')
  RETURNING id INTO statut_resa_id;

  -- ===============================
  -- Tarifs (ta demande)
  -- ===============================
  INSERT INTO tarif_vol (id_vol_programmation, id_classe, id_categorie_type, tarif)
  VALUES
    -- ADULTE
    (vp_id, classe_first_id,   cat_adulte_id, 2000000),
    (vp_id, classe_premium_id, cat_adulte_id, 1000000),
    (vp_id, classe_eco_id,     cat_adulte_id, 900000),
    -- ENFANT
    (vp_id, classe_first_id,   cat_enfant_id, 800000),
    (vp_id, classe_premium_id, cat_enfant_id, 700000),
    (vp_id, classe_eco_id,     cat_enfant_id, 600000);

  -- ===============================
  -- Réservation (total 89 sièges)
  -- ===============================
  INSERT INTO reservation (id_vol_programmation, id_client, nombre_places)
  VALUES (vp_id, client_id, 89)
  RETURNING id INTO resa_id;

  INSERT INTO historique_reservation (id_reservation, id_statut)
  VALUES (resa_id, statut_resa_id);

  -- Première classe: 2 BEBE, 4 ENFANT, 10 ADULTE => 16 sièges
  WITH seats AS (
    SELECT s AS place, row_number() OVER (ORDER BY s) AS rn
    FROM generate_series(1, 30) s
    WHERE NOT EXISTS (
      SELECT 1 FROM reservation_place rp
      WHERE rp.id_vol_programmation = vp_id AND rp.place = s
    )
  )
  INSERT INTO reservation_place (id_reservation, id_vol_programmation, place, id_classe, id_categorie_type)
  SELECT resa_id, vp_id, place, classe_first_id,
         CASE
           WHEN rn BETWEEN 1 AND 2 THEN cat_bebe_id
           WHEN rn BETWEEN 3 AND 6 THEN cat_enfant_id
           WHEN rn BETWEEN 7 AND 16 THEN cat_adulte_id
         END
  FROM seats
  WHERE rn BETWEEN 1 AND 16;

  -- Économique: 4 BEBE, 10 ENFANT, 30 ADULTE => 44 sièges
  WITH seats AS (
    SELECT s AS place, row_number() OVER (ORDER BY s) AS rn
    FROM generate_series(31, 80) s
    WHERE NOT EXISTS (
      SELECT 1 FROM reservation_place rp
      WHERE rp.id_vol_programmation = vp_id AND rp.place = s
    )
  )
  INSERT INTO reservation_place (id_reservation, id_vol_programmation, place, id_classe, id_categorie_type)
  SELECT resa_id, vp_id, place, classe_eco_id,
         CASE
           WHEN rn BETWEEN 1 AND 4 THEN cat_bebe_id
           WHEN rn BETWEEN 5 AND 14 THEN cat_enfant_id
           WHEN rn BETWEEN 15 AND 44 THEN cat_adulte_id
         END
  FROM seats
  WHERE rn BETWEEN 1 AND 44;

  -- Premium: 4 BEBE, 5 ENFANT, 20 ADULTE => 29 sièges
  WITH seats AS (
    SELECT s AS place, row_number() OVER (ORDER BY s) AS rn
    FROM generate_series(81, 120) s
    WHERE NOT EXISTS (
      SELECT 1 FROM reservation_place rp
      WHERE rp.id_vol_programmation = vp_id AND rp.place = s
    )
  )
  INSERT INTO reservation_place (id_reservation, id_vol_programmation, place, id_classe, id_categorie_type)
  SELECT resa_id, vp_id, place, classe_premium_id,
         CASE
           WHEN rn BETWEEN 1 AND 4 THEN cat_bebe_id
           WHEN rn BETWEEN 5 AND 9 THEN cat_enfant_id
           WHEN rn BETWEEN 10 AND 29 THEN cat_adulte_id
         END
  FROM seats
  WHERE rn BETWEEN 1 AND 29;

END $$;
