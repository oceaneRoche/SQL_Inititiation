-- affichage des données de la table client
SELECT * FROM client;

-- création d'une table
CREATE TABLE client(
	IdCli INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Nom VARCHAR(50) NOT NULL,
    Ville VARCHAR(50) NOT NULL
);

-- insertion des données
INSERT INTO client(Nom, Ville) 
VALUES 
('Jean', 'Paris'),
('Paul', 'PAris'),
('Vincent', 'Evry'),
('Pierre', 'Lyon');

-- suppression des clients en trop
DELETE FROM client WHERE IdCli > 4;

-- ==================================
-- PARTIE : étude des affichages
-- ==================================
SELECT 2*5 -- ça marche
SELECT * FROM client WHERE Ville = 'Paris';

-- convertis en majuscule les valeurs dans la colinne "ville"
SELECT * FROM client WHERE UPPER(Ville) = 'PARIS';

/*
Fonction scalire (qui agit sur tte les lignes du tableaux
convertis :
	-en minuscule les valeurs dans la colinne "ville" dans le select
	-en majuscule les valeurs dans la colinne "ville" dans le where
=> on convertis grâce a des fonctions
*/
SELECT *, LOWER(Ville), LOWER(Nom) FROM client WHERE LOWER(Ville) = 'PARIS';

-- découverte du LIKE
-- '%' n'importe quel caractère illimité
-- '_' n'importe quel caractère 1 seule fois
SELECT *  FROM client WHERE Ville LIKE 'P%';

/* Fonction aggregation (ex: MIN, MAX, ...)
	- SUM: somme
	- GROUP BY : pour regrouper et ORDER BY : pour trier
	- DESC : decroissant et ASC : croissant
	- COUNT(*), ville : affiche le nb de client par ville
*/
SELECT MIN(idcli) FROM client;
SELECT MAX(idcli), MIN(idcli), SUM(idcli), COUNT(*) FROM client; 
SELECT COUNT(*), ville FROM client GROUP BY ville;
SELECT COUNT(*), ville FROM client GROUP BY ville HAVING ville LIKE '%y%' ORDER BY ville DESC;

INSERT INTO client(Nom, Ville) SELECT Nom,Ville FROM client

-- LIMIT permet d'afficher que les 3 premiers clients
SELECT * FROM client LIMIT 3

-- afficher le client(nom, ville) dont le idcli est le MAX
SELECT * FROM client ORDER BY idcli DESC lIMIT 1;

-- ================================================================
-- Partie : étude des Mise à jours (modification et suppression)
-- ================================================================

-- Mettre les noms des villes en majuscule
UPDATE client SET ville = upper(ville)

-- Mettre les noms des clients en majuscule uniquement ceux de paris
UPDATE client  SET nom = upper(nom) WHERE ville = 'Paris';

-- Supprimer les clients qui n'ont jamais rien acheté
DELETE FROM client  WHERE IdCli NOT IN (SELECT DISTINCT IdCli FROm vente); 