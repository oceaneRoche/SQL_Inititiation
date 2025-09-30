--Q1: Donner les noms, marques et prix des produits
	SELECT nom, marque, prix FROM produit;

--Q2: Donner les colonnes des clients
	SELECT * FROM client;
	
--Q3: Donner les différentes marques de produits
	SELECT DISTINCT marque FROM produit;
	-- DISTINCT evite de répéter la marque si elle a déjà été listé
	
--Q4: Donner les références des prix et leurs prix majorés de 20%
	SELECT idPro, (prix*2+ prix) FROM produit;

--Q5: Donner les noms des produits de marques IBM
	SELECT nom FROM produit WHERE marque = 'IBM';
	
--Q6: Lister les clients dont le nom comporte la lettre A en 2ième position
	SELECT * FROM client WHERE nom LIKE '_A%'; --mysql n'est pas sensible à la casse

--Q7: Lister les produits dont le prix est compris entre 1200euros et 1400 euros
	SELECT * FROM produit WHERE prix BETWEEN 1200 AND 1400; -- avec égalité, il comprend les bornes
	SELECT * FROM produit WHERE prix >= 1200 AND prix <= 1400; -- il faut préciser les égalités

--Q8: Lister les produits de marque IBM ou Apple
	SELECT * FROM produit WHERE marque = 'IBM' OR marque = 'Apple';
	SELECT * FROM produit WHERE marque IN ('IBM', 'Apple');
	
--Q9: Lister les produits dont le prix est inconnu
	SELECT * FROM produit WHERE prix IS NULL;

--Q10: Lister les produits de marque IBM dont le prix est inférieur à 12000 euros
	SELECT * FROM produit WHERE marque = 'IBM' AND prix < 12000;
	
--Q10 bonus: 
	SELECT * FROM produit WHERE marque = 'IBM' AND prix < 1200 OR marque = 'Apple'; -- le AND est prioritaire sur le OR

--Q11: Lister les produits en les triant par marques et à l'intérieur d'une marque par prix décroissants
	SELECT * FROM produit ORDER BY marque ASC, prix DESC; -- le ASC est facultatif
	
--Q12: Donner les clients ayant passés une vente
	SELECT * FROM client INNER JOIN vente ON client.IdCli = vente.IdCli;

--Q13: Donner les noms des produits ayant été vendus
	SELECT nom FROM produit INNER JOIN vente ON  produit.IdPro = vente.IdPro;
	SELECT DISTINCT p.nom FROM produit p INNER JOIN vente v ON  p.IdPro = v.IdPro;
	SELECT DISTINCT p.nom FROM produit p JOIN vente v ON  p.IdPro = v.IdPro;
	SELECT DISTINCT p.nom FROM produit p, vente v WHERE  p.IdPro = v.IdPro;
	
--Q14: Donner tous les clients et leur vente même ceux avec 0 vente
	SELECT * FROM client LEFT JOIN vente ON client.IdCli = vente.IdCli;
	SELECT * FROM vente LEFT JOIN client ON client.IdCli = vente.IdCli;
	
--Q15: Donner les clients n'ayant pas fait de vente
	SELECT * FROM client LEFT JOIN vente ON client.IdCli = vente.IdCli WHERE vente.IdVt IS NULL;
	
--Q16: Donner les clients ayant passés une vente : sous requête
	SELECT * FROM client c WHERE c.IdCli In (SELECT v.IdCli FROM vente v);
	
--Q17: Donner les clients qui ont acheté le 2001-03-16 : 1)sous requete 2)jointure
	--1)
	SELECT * FROM client c WHERE c.IdCli In (SELECT v.IdCli FROM vente v WHERE v.dateV = '2001-03-16');
		-- GROUP_CONCAT : regroupe toutes les cellules en une seule cellule
		SELECT * , (SELECT GROUP_CONCAT(dateV SEPARATor ' - ') FROM vente v2 WHERE v2.IdCli = c.IdCli) AS liste_date
			FROM client c WHERE c.IdCli In (SELECT v.IdCli FROM vente v WHERE v.dateV = '2001-03-16');
	--2)
	SELECT * FROM client c JOIN vente v ON c.IdCli = v.IdCli WHERE v.dateV = '2001-03-16';	
	
--Q18: Donner les produits qui n'ont pas été acheté
	SELECT * FROM produit p WHERE NOT EXISTS (SELECT * FROM vente v WHERE v.idPro = p.idPro);
	
--Q19: Donner les noms des produits achetés par tous les clients de Nice
	SELECT p.nom FROM produit p WHERE EXISTS (SELECT * FROM vente v WHERE v.idPro = p.idPro
		AND EXISTS (SELECT * FROM client c WHERE c.IdCli = v.IdCli AND ville = 'Nice'))
		
-- Exemples avec ANY, ALL et UNION
	SELECT qte FROM vente WHERE idcli = 1
	SELECT c.nom, v.qte FROM client c  JOIN vente v ON c.IdCli = v.IdCli WHERE v.qte >= ALL (SELECT v2.qte FROM vente v2 WHERE v2.idcli = 1)
	SELECT c.nom, GROUP_CONCAT(v.qte) FROM client c  JOIN vente v ON c.IdCli = v.IdCli WHERE v.qte >= ALL (SELECT v2.qte FROM vente v2 WHERE v2.idcli = 1) GROUP BY c.nom;
	SELECT c.nom, ville FROM client c WHERE ville = 'Paris' UNION SELECT c.nom, ville FROM client c WHERE ville = 'Nice' -- Union est rarement utilisé car il est dangereux
	
--Q20: Donner le nombre total de 'PS1' vendu avec le nombre de commande
	-- ex: 100 PS1 sur 3 commandes
	SELECT COUNT(*) "Total commande", SUM(v.qte) "Total vendu" FROM produit p Join vente v ON p.IdPro = v.IdPro WHERE p.nom = 'PS1';
	
--Q21: Donner les noms des produits moins chers
	-- que la moyenne des prix de tous les produits (fonction: AVG)
	SELECT p.nom, p.prix FROM produit p WHERE p.prix < (SELECT AVG(p2.prix) FROM produit p2);
	
--Q22: Donner les noms des clients habitant la même ville que john
	SELECT c1.nom, c1.ville FROM client c1, client c2 WHERE c1.ville = c2.ville AND c1.nom <> 'John' AND c2.nom = 'John';
	
--Q23: Donner les quantités totales vendu par marque 
	SELECT p.marque, SUM(v.qte) "quantité" FROM vente v JOiN produit p ON p.IdPro = v.IdPro GROUP BY p.marque;
	SELECT p.marque, SUM(v.qte) "quantité", ROUND(AVG(v.qte)) "moyenne quantité" FROM vente v JOiN produit p ON p.IdPro = v.IdPro GROUP BY p.marque;
	
--Q24: Donner les quantités totales acheter par tous les clients et pour ceux qui n'ont rien acheté (null) mettre 0
	-- ifnull retourne 0 si la valeur est nulle
	SELECT c.nom, ifnull(SUM(v.qte), 0) "quantité totale" FROM client c LEFT JOIN vente v ON c.IdCli = v.IdCli GROUP BY c.nom;
	
--Q25: Donner les noms des marques dont les prix moyen par marque des produits est < 1000
	SELECT p.marque, AVG(p.prix) "prix moyen" FROM produit p GROUp by marque Having AVG(p.prix) < 1000;