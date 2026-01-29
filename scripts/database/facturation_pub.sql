-- Facturation mensuelle des publicités + paiements affectés par vol

-- 1) Facture mensuelle (1 société x 1 mois)
CREATE TABLE IF NOT EXISTS facture_pub (
  id SERIAL PRIMARY KEY,
  id_societe INTEGER NOT NULL REFERENCES societe(id),
  annee INTEGER NOT NULL,
  mois INTEGER NOT NULL,
  date_creation DATE NOT NULL DEFAULT CURRENT_DATE,
  total_theorique DECIMAL(15,2) NOT NULL DEFAULT 0,
  total_paye DECIMAL(15,2) NOT NULL DEFAULT 0,
  CONSTRAINT uk_facture_pub UNIQUE (id_societe, annee, mois)
);

-- 2) Lignes de facture (par vol_programmation)
CREATE TABLE IF NOT EXISTS facture_pub_ligne (
  id SERIAL PRIMARY KEY,
  id_facture_pub INTEGER NOT NULL REFERENCES facture_pub(id) ON DELETE CASCADE,
  id_vol_programmation INTEGER NOT NULL REFERENCES vol_programmation(id),
  nb_diffusions INTEGER NOT NULL,
  prix_unitaire DECIMAL(15,2) NOT NULL,
  montant_theorique DECIMAL(15,2) NOT NULL,
  montant_paye DECIMAL(15,2) NOT NULL DEFAULT 0,
  CONSTRAINT uk_facture_pub_ligne UNIQUE (id_facture_pub, id_vol_programmation)
);

-- 3) Ajout du lien paiement -> facture
ALTER TABLE paiement_pub
  ADD COLUMN IF NOT EXISTS id_facture_pub INTEGER;

ALTER TABLE paiement_pub
  ADD CONSTRAINT IF NOT EXISTS fk_paiement_pub_facture
  FOREIGN KEY (id_facture_pub) REFERENCES facture_pub(id);

-- 4) Détails d'affectation paiement -> ligne de facture
CREATE TABLE IF NOT EXISTS paiement_pub_affectation (
  id SERIAL PRIMARY KEY,
  id_paiement_pub INTEGER NOT NULL REFERENCES paiement_pub(id) ON DELETE CASCADE,
  id_facture_pub_ligne INTEGER NOT NULL REFERENCES facture_pub_ligne(id) ON DELETE CASCADE,
  montant_affecte DECIMAL(15,2) NOT NULL,
  CONSTRAINT uk_paiement_pub_affectation UNIQUE (id_paiement_pub, id_facture_pub_ligne)
);
