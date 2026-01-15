INSERT INTO vol_programme (id,trajet_id, depart_ts, arrivee_ts,prix_unitaire)
VALUES (2,(SELECT id FROM trajet WHERE code_trajet = 'TNR-NOS'),
        '2026-01-15 12:00:00', '2026-01-15 13:15:00', 200000) ;
