Evaluation :

/*1- Liste des clients français :*/
SELECT CustomerID,CompanyName,ContactName,Phone
FROM customers 
WHERE Country = 'france' ;

/*2- Liste des produits vendus par le fournisseur "Exotic Liquids" :*/
SELECT ProductName,UnitPrice 
FROM suppliers
JOIN products ON products.ProductID = suppliers.SupplierID
WHERE products.SupplierID = 1 

/*3- Nombre de produits mis à disposition par les fournisseurs français (tri par nombre de produits décroissant) :*/
SELECT suppliers.CompanyName, COUNT(products.ProductID) 
FROM suppliers
INNER JOIN products ON suppliers.SupplierID = products.SupplierID
WHERE suppliers.Country = 'France'
GROUP BY suppliers.SupplierID
ORDER BY COUNT(products.ProductID) DESC, Fournisseur;

/*4- Liste des clients français ayant passé plus de 10 commandes :*/
SELECT customers.CompanyName AS 'Client', COUNT(orders.OrderID) AS 'Nbre commandes'
FROM orders
INNER JOIN customers ON orders.CustomerID = customers.CustomerID
WHERE customers.CustomerID IN (
    SELECT customers.CustomerID
    FROM customers
    WHERE customers.Country = 'France'
)
GROUP BY customers.CustomerID
HAVING COUNT(orders.OrderID) > 10;
/*5- Liste des clients dont le montant cumulé de toutes les commandes passées est supérieur à 30000 € :*/

SELECT customers.CompanyName AS 'Client', SUM(UnitPrice * Quantity) AS 'CA', customers.Country AS 'Pays'
FROM orders
 JOIN orders ON orders.CustomerID = customers.CustomerID
JOIN order_details ON order_details.OrderID = orders.OrderID
GROUP BY orders.CustomerID
HAVING CA > 30000
ORDER BY CA DESC;

/*6- Liste des pays dans lesquels des produits fournis par "Exotic Liquids" ont été livrés :*/
USE northwind;

SELECT DISTINCT ShipCountry AS 'Pays'
FROM suppliers
JOIN products ON products.SupplierID = suppliers.SupplierID
JOIN `order details` ON `order details`.ProductID = products.ProductID
JOIN orders ON orders.OrderID = `order details`.OrderID
WHERE CompanyName = 'Exotic Liquids'
;


/*7- Chiffre d'affaires global sur les ventes de 1997 :*/

USE northwind;

SELECT SUM(UnitPrice * Quantity) AS 'Montant Ventes 97'
FROM orders
JOIN `order details` ON `order details`.OrderID = orders.OrderID
WHERE YEAR(OrderDate) = 1997
;

/*8- Chiffre d'affaires détaillé par mois, sur les ventes de 1997 :*/

USE northwind;

SELECT MONTH(OrderDate) AS 'Mois 97',SUM(UnitPrice * Quantity) AS 'Montant Ventes 97'
FROM orders
JOIN `order details` ON `order details`.OrderID = orders.OrderID
WHERE YEAR(OrderDate) = 1997
GROUP BY MONTH(OrderDate)
;


/*9- A quand remonte la dernière commande du client nommé "Du monde entier" ?*/

USE northwind;

SELECT OrderDate AS 'Date de dernière commande'
FROM orders
WHERE ShipName = 'Du monde entier'
ORDER BY OrderDate DESC
LIMIT 1
;


/*10- Quel est le délai moyen de livraison en jours ?*/

USE northwind;

SELECT ROUND(AVG(DATEDIFF(RequiredDate, OrderDate))) AS 'Délais moyen de livraison en jours depuis la commande', 
ROUND(AVG(DATEDIFF(RequiredDate, ShippedDate))) AS 'Délais moyen de livraison en jours depuis l\'envois'
FROM orders
;
