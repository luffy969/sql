exo1
/*SELECT hot_nom,hot_ville FROM hotel ;*/	
/*SELECT cli_nom,cli_prenom,cli_ville FROM client WHERE cli_nom = "White";*/
/*SELECT sta_nom,sta_altitude FROM station WHERE sta_altitude > 1000*/
/* SELECT cha_numero,cha_capacite FROM chambre WHERE cha_capacite > 1;*/
/*SELECT cli_nom,cli_ville FROM client WHERE cli_ville != "londres";*/      
/*SELECT hot_nom,hot_ville,hot_categorie FROM hotel WHERE hot_ville = "bretou" AND hot_categorie >3; */
exo2
/*SELECT sta_nom,hot_nom,hot_categorie,hot_ville FROM hotel JOIN station ON hotel.hot_sta_id = station.sta_id; */
/* SELECT hot_nom,hot_categorie,hot_ville,cha_numero FROM chambre JOIN hotel ON hotel.hot_id = chambre.cha_hot_id; */
/*SELECT hot_nom,hot_categorie,hot_ville,cha_numero,cha_capacite FROM chambre join hotel ON cha_hot_id = hot_id WHERE chambre.cha_capacite >1 and hot_ville ="bretou"; */
/*SELECT client.cli_nom AS NomClient,hotel.hot_nom AS NomHotel, reservation.res_date AS DateReservation 
FROM reservation 
JOIN client ON client.cli_id = reservation.res_cli_id
JOIN chambre ON chambre.cha_id = reservation.res_cha_id
JOIN hotel ON hotel.hot_id = chambre.cha_hot_id ;*/
/*SELECT sta_nom,hot_nom,cha_numero,cha_capacite 
FROM chambre 
JOIN hotel ON hotel.hot_id = chambre.cha_hot_id 
JOIN station on station.sta_id = hotel.hot_sta_id; */
/*SELECT cli_nom,hot_nom,res_date_debut,
DATEDIFF(res_date_fin,res_date_debut) as duree
FROM reservation
JOIN client on client.cli_id = reservation.res_cli_id
JOIN chambre on chambre.cha_id =reservation.res_cha_id
JOIN hotel on hotel.hot_id = chambre.cha_hot_id;
*/
exo3
/*SELECT station.sta_nom AS Station, 
count(hotel.hot_id) AS NbrHotels
FROM station 
JOIN hotel ON station.sta_id = hotel.hot_sta_id
GROUP BY station.sta_nom;*/
/*SELECT station.sta_nom AS Station, 
count(chambre.cha_id) 
FROM station
JOIN hotel ON hotel.hot_sta_id = sta_id
JOIN chambre ON chambre.cha_hot_id = hotel.hot_id
GROUP BY station.sta_nom;*/
/*SELECT station.sta_nom AS Station, 
count(chambre.cha_id) 
FROM station
JOIN hotel ON hotel.hot_sta_id = sta_id
JOIN chambre ON chambre.cha_hot_id = hotel.hot_id
WHERE chambre.cha_capacite > 1
GROUP BY station.sta_nom;*/
/*SELECT hot_nom 
FROM hotel
JOIN chambre ON chambre.cha_hot_id = hotel.hot_id
JOIN reservation ON reservation.res_cha_id = chambre.cha_id
JOIN client ON client.cli_id =reservation.res_cli_id
WHERE client.cli_nom = "Squire";*/
/*SELECT station.sta_nom AS Station, 
AVG(DATEDIFF(reservation.res_date_fin, reservation.res_date_debut)) AS Moyenne
FROM station 
JOIN hotel ON hotel.hot_sta_id = station.sta_id
JOIN chambre ON chambre.cha_hot_id = hotel.hot_id
JOIN reservation ON reservation.res_cha_id = chambre.cha_id
GROUP BY station.sta_nom;*/
/**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**/

USE papyrus;

/* 1 - Fournisseur 09120 */
SELECT numcom AS Commandes9120
FROM entcom 
WHERE numfou = 9120;

/* 2 - Fournisseurs ayant passé des commande */
SELECT DISTINCT numfou FROM entcom;

/* 3 - Nombre de commandes et de Fournisseur */
SELECT count(numcom) AS NombreCommandes, 
count(DISTINCT numfou) AS NombreFournisseurs
FROM entcom;

/* 4 - stock < stockAlerte & qteAnnuelle < 1000 */ 
SELECT `codart` AS Numero, 
`libart` AS Libellé, 
`stkphy` AS Stock, 
`stkale` AS StockAlerte, 
`qteann` AS qteAnnuelle
FROM `produit`
WHERE stkphy <= stkale
AND qteann < 1000;

/* 5 - Fournisseurs depepartements 75 78 77 92 */ 
SELECT (`posfou` - (`posfou` % 1000)) / 1000 AS Departement, 
`nomfou` AS Nom
FROM fournis
WHERE (`posfou` - (`posfou` % 1000)) / 1000 = 75 
OR (`posfou` - (`posfou` % 1000)) / 1000 = 78 
OR (`posfou` - (`posfou` % 1000)) / 1000 = 92 
OR (`posfou` - (`posfou` % 1000)) / 1000 = 77
ORDER BY (`posfou` - (`posfou` % 1000)) / 1000 DESC, `nomfou`;

/* 6 - Commandes de mars et avril */
SELECT `numcom` AS Commande, 
`datcom` AS DateCommande
FROM entcom 
WHERE `datcom` LIKE '%-04-%'
OR `datcom` LIKE '%-03-%';

/* 7 - Commande du jour avec observations */
SELECT `numcom` AS NumeroCommande, 
`obscom` AS Observations
FROM entcom 
WHERE DATE(`datcom`) = (
SELECT cast(NOW() AS DATE))
AND obscom != "";

/* 8 - Commande par total DESC */ 
SELECT ligcom.`numcom` AS Commande, 
sum(`ligcom`.`priuni` * `ligcom`.`qteliv`) AS Total
FROM ligcom 
GROUP BY ligcom.numcom
ORDER BY Total DESC;

/* 9 - Commandes > 10 000€ pour articles commandés >= 1000 */
SELECT ligcom.`numcom` AS Commande, 
sum(`ligcom`.`priuni` * `ligcom`.`qteliv`) AS Total
FROM ligcom 
WHERE `qtecde` >= 1000
GROUP BY ligcom.numcom
	HAVING Total > 10000
ORDER BY Total DESC;

/* 10 - Commandes par fournisseur */ 
SELECT `fournis`.`nomfou`, 
`entcom`.`numcom`,
`entcom`.`datcom`
FROM `entcom`
JOIN fournis ON fournis.`numfou` = entcom.`numfou`;

/* 11 - Produits 'urgent' */ 
SELECT `entcom`.`numcom` AS Commande, 
`fournis`.`nomfou` AS Fournisseur, 
`produit`.`libart` AS Article, 
`ligcom`.`priuni` * `ligcom`.`qtecde` AS Prix
FROM entcom 
JOIN fournis ON entcom.`numfou` = `fournis`.`numfou`
JOIN `ligcom` ON `ligcom`.`numcom`= entcom.`numcom`
JOIN produit ON `produit`.`codart` = ligcom.`codart`
WHERE entcom.`obscom` = 'Commande urgente';

/* 12 Fournisseurs livrant au moins un article */
SELECT DISTINCT fournis.`nomfou` AS Fournisseur
FROM fournis
JOIN entcom ON `fournis`.`numfou` = entcom.`numfou`
JOIN ligcom ON ligcom.`numcom` = entcom.`numcom`
WHERE ligcom.`qteliv` > 0;

/* 13 - Commandes du fournisseur de la 70210 */ 
SELECT `entcom`.`numcom` AS Numero,
entcom.`datcom` AS DateCommande
FROM entcom 
WHERE entcom.`numfou` = (
	SELECT entcom.`numfou`
	FROM entcom 
	WHERE entcom.`numcom` = 70210);

/* 14 - Articles susceptibles d'etre vendus moins chers que les rubans */
SELECT produit.`libart` AS Articles,
vente.`prix1` AS Prix 
FROM vente 
JOIN produit ON produit.`codart` = vente.`codart`
WHERE vente.`prix1` < ALL (
	SELECT vente.`prix1`
	FROM vente 
	WHERE vente.`codart` LIKE 'R%');
	
/* 15 - Liste des fournisseurs livrant des produit stock >= a 150% du stckale */
SELECT DISTINCT fournis.`nomfou` AS 'Fournisseurs 150% Stock Alerte', 
produit.`libart` AS Produits
FROM fournis 
JOIN vente ON vente.`numfou` = fournis.`numfou`
JOIN produit ON produit.`codart` = vente.`codart`
WHERE produit.`stkphy` >= (produit.`stkale` * 1.5)
ORDER BY produit.`libart`, fournis.`nomfou`;

/* 16 - Liste des fournisseurs livrant des produit stock >= a 150% du stckale & livraison < 30 jours */
SELECT DISTINCT fournis.`nomfou` AS 'Fournisseurs 150% Stock Alerte & Liv < 30J',
produit.`libart` AS Produits
FROM fournis 
JOIN vente ON vente.`numfou` = fournis.`numfou`
JOIN produit ON produit.`codart` = vente.`codart`
WHERE produit.`stkphy` >= (produit.`stkale` * 1.5)
AND vente.`delliv` < 31
ORDER BY fournis.`nomfou`, produit.`libart`;

/* 17 - 90% de la quantite annuelle  */
SELECT produit.`libart` AS produits
FROM produit 
JOIN ligcom ON produit.`codart` = ligcom.`codart`
WHERE (produit.`qteann` * 0.9) < ligcom.`qtecde`
GROUP BY ligcom.`codart`;

/* 18 - Chiffre d'affaire par fournisseur */
SELECT fournis.`nomfou` AS Fournisseurs,
sum(ligcom.`qteliv` * ligcom.`priuni`) * 1.2 AS CA
FROM fournis 
JOIN vente ON vente.`numfou` = fournis.`numfou`
JOIN ligcom ON ligcom.`codart` = vente.`codart`
GROUP BY fournis.`nomfou`;
