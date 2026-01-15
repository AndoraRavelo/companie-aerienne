BEGIN;

-- 1) Avion de test (capacité 120)
INSERT INTO avion (matricule, capacite)
SELECT 'TEST-120', 120
WHERE NOT EXISTS (SELECT 1 FROM avion WHERE matricule = 'TEST-120');

-- 2) Classes de test
INSERT INTO classe (nom)
SELECT '1ere Classe'
WHERE NOT EXISTS (SELECT 1 FROM classe WHERE nom = '1ere Classe');

INSERT INTO classe (nom)
SELECT 'Economique'
WHERE NOT EXISTS (SELECT 1 FROM classe WHERE nom = 'Economique');

INSERT INTO classe (nom)
SELECT 'Premium'
WHERE NOT EXISTS (SELECT 1 FROM classe WHERE nom = 'Premium');

-- 3) Plages de sièges par classe (classe_place)
-- 1ere Classe: 1-30 (30 places)
INSERT INTO classe_place (id_classe, place_debut, place_fin, id_avion)
SELECT c.id, 1, 30, a.id
FROM classe c, avion a
WHERE c.nom = '1ere Classe'
  AND a.matricule = 'TEST-120'
  AND NOT EXISTS (
    SELECT 1 FROM classe_place cp
    WHERE cp.id_classe = c.id AND cp.id_avion = a.id
  );

-- Economique: 31-80 (50 places)
INSERT INTO classe_place (id_classe, place_debut, place_fin, id_avion)
SELECT c.id, 31, 80, a.id
FROM classe c, avion a
WHERE c.nom = 'Economique'
  AND a.matricule = 'TEST-120'
  AND NOT EXISTS (
    SELECT 1 FROM classe_place cp
    WHERE cp.id_classe = c.id AND cp.id_avion = a.id
  );

-- Premium: 81-120 (40 places)
INSERT INTO classe_place (id_classe, place_debut, place_fin, id_avion)
SELECT c.id, 81, 120, a.id
FROM classe c, avion a
WHERE c.nom = 'Premium'
  AND a.matricule = 'TEST-120'
  AND NOT EXISTS (
    SELECT 1 FROM classe_place cp
    WHERE cp.id_classe = c.id AND cp.id_avion = a.id
  );

-- 4) Vol + Vol Programmation (nécessaire pour tarif_vol)
-- Assure 2 aéroports (si tu en as déjà, ces INSERT ne feront rien)
INSERT INTO aeroport (nom)
SELECT 'TEST-A'
WHERE NOT EXISTS (SELECT 1 FROM aeroport WHERE nom='TEST-A');

INSERT INTO aeroport (nom)
SELECT 'TEST-B'
WHERE NOT EXISTS (SELECT 1 FROM aeroport WHERE nom='TEST-B');

-- Crée un vol TEST-A -> TEST-B (durée arbitraire)
INSERT INTO vol (id_aeroport_depart, id_aeroport_arrivee, duree)
SELECT ad.id, aa.id, 90
FROM aeroport ad, aeroport aa
WHERE ad.nom='TEST-A' AND aa.nom='TEST-B'
  AND NOT EXISTS (
    SELECT 1 FROM vol v
    WHERE v.id_aeroport_depart = ad.id AND v.id_aeroport_arrivee = aa.id
  );

-- Crée une vol_programmation avec l'avion TEST-120
INSERT INTO vol_programmation (id_vol, id_avion, date_heure)
SELECT v.id, a.id, '2026-01-12 18:00:00'
FROM vol v, avion a, aeroport ad, aeroport aa
WHERE a.matricule='TEST-120'
  AND ad.nom='TEST-A' AND aa.nom='TEST-B'
  AND v.id_aeroport_depart = ad.id
  AND v.id_aeroport_arrivee = aa.id
  AND NOT EXISTS (
    SELECT 1 FROM vol_programmation vp
    WHERE vp.id_vol = v.id AND vp.id_avion = a.id AND vp.date_heure = '2026-01-12 18:00:00'
  );

-- 5) Tarifs par classe pour CE vol_programmation
-- (on cible la vp créée au dessus)
INSERT INTO tarif_vol (id_vol_programmation, id_classe, tarif)
SELECT vp.id, c.id, 1200000
FROM vol_programmation vp
JOIN vol v ON v.id = vp.id_vol
JOIN avion a ON a.id = vp.id_avion
JOIN aeroport ad ON ad.id = v.id_aeroport_depart
JOIN aeroport aa ON aa.id = v.id_aeroport_arrivee
JOIN classe c ON c.nom = '1ere Classe'
WHERE a.matricule='TEST-120'
  AND ad.nom='TEST-A' AND aa.nom='TEST-B'
  AND vp.date_heure = '2026-01-12 18:00:00'
  AND NOT EXISTS (
    SELECT 1 FROM tarif_vol tv
    WHERE tv.id_vol_programmation = vp.id AND tv.id_classe = c.id
  );

INSERT INTO tarif_vol (id_vol_programmation, id_classe, tarif)
SELECT vp.id, c.id, 700000
FROM vol_programmation vp
JOIN vol v ON v.id = vp.id_vol
JOIN avion a ON a.id = vp.id_avion
JOIN aeroport ad ON ad.id = v.id_aeroport_depart
JOIN aeroport aa ON aa.id = v.id_aeroport_arrivee
JOIN classe c ON c.nom = 'Economique'
WHERE a.matricule='TEST-120'
  AND ad.nom='TEST-A' AND aa.nom='TEST-B'
  AND vp.date_heure = '2026-01-12 18:00:00'
  AND NOT EXISTS (
    SELECT 1 FROM tarif_vol tv
    WHERE tv.id_vol_programmation = vp.id AND tv.id_classe = c.id
  );

INSERT INTO tarif_vol (id_vol_programmation, id_classe, tarif)
SELECT vp.id, c.id, 1000000
FROM vol_programmation vp
JOIN vol v ON v.id = vp.id_vol
JOIN avion a ON a.id = vp.id_avion
JOIN aeroport ad ON ad.id = v.id_aeroport_depart
JOIN aeroport aa ON aa.id = v.id_aeroport_arrivee
JOIN classe c ON c.nom = 'Premium'
WHERE a.matricule='TEST-120'
  AND ad.nom='TEST-A' AND aa.nom='TEST-B'
  AND vp.date_heure = '2026-01-12 18:00:00'
  AND NOT EXISTS (
    SELECT 1 FROM tarif_vol tv
    WHERE tv.id_vol_programmation = vp.id AND tv.id_classe = c.id
  );

COMMIT;