-- Tables "enfants" (dépendantes) d'abord
DROP TABLE IF EXISTS reservation_place;
DROP TABLE IF EXISTS historique_reservation;
DROP TABLE IF EXISTS reservation;
DROP TABLE IF EXISTS tarif_vol;

DROP TABLE IF EXISTS vol_programmation_pilote;
DROP TABLE IF EXISTS vol_programmation_statut;

DROP TABLE IF EXISTS classe_place;
DROP TABLE IF EXISTS avion_pilote;

-- Tables "parents" ensuite
DROP TABLE IF EXISTS vol_programmation;
DROP TABLE IF EXISTS vol;

DROP TABLE IF EXISTS client;

DROP TABLE IF EXISTS pilote;
DROP TABLE IF EXISTS avion;

DROP TABLE IF EXISTS statut_reservation;
DROP TABLE IF EXISTS statut_vol;

DROP TABLE IF EXISTS classe;
DROP TABLE IF EXISTS aeroport;