#ok 1. Obtenir el nom i l’adreça dels hotels de 4 estrelles.
EXPLAIN 
SELECT nom AS 'Nom de l\'hotel', 
	   adreca AS 'Adreça' 
	FROM hotels 
WHERE categoria=4;

ALTER TABLE hotels
	ADD INDEX categoria(categoria, nom, adreca);

#ok 2. Obtenir el nom dels clients (Nom i cognom) que el seu cognom comenci per vocal (sense tenir en compte els accents).
EXPLAIN
SELECT CONCAT(nom, ' ',cognom1) AS 'Nom i Cognom' 
	FROM clients 
WHERE LEFT(cognom1,1) IN ('a', 'e', 'i', 'o', 'u');

ALTER table clients
	ADD INDEX nom_complet(nom, cognom1);

#ok 3. Quina és la reserva_id que té més nits. Indica també la quantitat de nits.
EXPLAIN
SELECT reserva_id AS 'Reserva ID', 
	   data_inici AS 'Data d\'inici', 
       data_fi AS 'Data fi', 
       MAX(dies) AS Dies 
	FROM reserves 
GROUP BY reserva_id 
ORDER BY Dies DESC 
LIMIT 1;

ALTER TABLE reserves
  ADD COLUMN dies SMALLINT UNSIGNED AS (TIMESTAMPDIFF(DAY,data_inici,data_fi)) VIRTUAL;

ALTER TABLE reserves
	ADD KEY covered(reserva_id, data_inici, data_fi, hab_id, client_id);

#ok 4. Quantes reserves va rebre l’hotel ‘Catalonia Ramblas’ de Barcelona durant tot  l’any 2015 (una reserva pertany al 2015 si alguna nit d’aquesta reserva era del 2015).
EXPLAIN
SELECT num_reserves, nom_hotel 
	FROM hotel_reserves 
WHERE any=2015 
AND nom_hotel = 'Catalonia Ramblas';

CREATE TABLE hotel_reserves(
	id	INT AUTO_INCREMENT PRIMARY KEY,
	any	INT,
	num_reserves	INT,
	nom_hotel	VARCHAR(50)
);
SELECT * FROM hotel_reserves;

INSERT INTO hotel_reserves (any, num_reserves, nom_hotel)
SELECT YEAR(r.data_fi), COUNT(r.reserva_id), h.nom
FROM reserves r
INNER JOIN habitacions hab ON hab.hab_id = r.hab_id
INNER JOIN hotels h ON h.hotel_id = hab.hotel_id
GROUP BY h.nom, YEAR(r.data_fi);

#ok 5. Obtenir el nom i cognoms dels clients que varen néixer el mes de Març.
EXPLAIN
SELECT CONCAT(nom, ' ',cognom1) AS 'Nom i Cognom'
	FROM clients 
WHERE mes_naix=3;

ALTER TABLE clients
ADD COLUMN mes_naix SMALLINT UNSIGNED AS (MONTH(data_naix)) VIRTUAL;

ALTER TABLE clients
ADD KEY mes (mes_naix);


#ok 6. Quantitat d’hotels de 4 estrelles de la població de Barcelona.
EXPLAIN
SELECT COUNT(h.hotel_id) 
	FROM hotels h 
    INNER JOIN poblacions p ON p.poblacio_id = h.poblacio_id
WHERE p.nom = 'Barcelona';

ALTER TABLE poblacions
ADD INDEX nom (nom, poblacio_id);


#ARREGLAR 8. El nom dels hotels que tenen com a mínim una habitació lliure durant les dates ‘2015-05-01’ i ‘2015-05-17’.
EXPLAIN
SELECT h.nom AS 'Nom de l\'hotel'
  FROM hotels AS h
  INNER JOIN habitacions AS hab ON hab.hotel_id = h.hotel_id
  WHERE hab.hab_id NOT IN (SELECT hab.hab_id
                              FROM reserves AS r
                            INNER JOIN habitacions AS hab ON hab.hab_id = r.hab_id
                            WHERE r.data_fi >= "2015-05-01"
                                  AND r.data_inici <= "2015-05-17")
GROUP BY h.nom;
      

#ok 9. Obtenir la quantitat de reserves que s’inicien en cadascun dels dies de la setmana. Tenint en compte només l’any 2016.
EXPLAIN
SELECT diasetmana, COUNT(data_inici)
    FROM reserves
WHERE data_inici >= "2016-01-01"
      AND data_fi <= "2016-12-31"
GROUP BY diasetmana;

ALTER TABLE reserves
ADD COLUMN diasetmana SMALLINT UNSIGNED AS (WEEKDAY(data_inici)+1) VIRTUAL;

ALTER TABLE reserves
ADD INDEX diasetmana (diasetmana, data_inici, data_fi);

#ok 10. Durant 2014 qui va realitzar més reserves? Els homes o les dones? Mostra el sexe i el número de reserves.
EXPLAIN
SELECT c.sexe AS 'Genere', count(r.reserva_id) AS 'Quantitat Reserves'
	FROM clients as c
    INNER JOIN reserves r ON r.client_id = c.client_id
    WHERE r.data_inici >= '2014-01-01' AND r.data_fi <= '2014-12-31'
    GROUP BY c.sexe;

#11. Quina és la mitjana de dies de reserva per l’hotel «HTOP Royal Star» de Blanes durant l’any 2016? (Una reserva pertany el 2016 si alguna nit cau en aquest any).
EXPLAIN
SELECT AVG(DAY(r.data_inici))
  FROM reserves r
INNER JOIN habitacions hab ON r.hab_id = hab.hab_id
INNER JOIN hotels h ON h.hotel_id = hab.hotel_id
WHERE h.nom = 'HTOP Royal Star'
  AND r.data_inici >= "2016-01-01"
  AND r.data_fi <= "2016-12-31";



#ok 12. El nom, categoria, adreça i número d’habitacions de l’hotel amb més habitacions de la BD.
EXPLAIN
SELECT nom,
       categoria,
       habitacions
  FROM hotels
WHERE habitacions = (SELECT MAX(habitacions)
                      FROM hotels);
                      
ALTER TABLE hotels
ADD INDEX hotels (nom, categoria, habitacions);

#ok 13. Rànquing de 5 països amb més reserves durant l’any 2016. Per cada país mostrar el nom del país i el número de reserves.

EXPLAIN
SELECT nom_pais, num_reserves FROM reserves_pais WHERE any=2016 ORDER BY num_reserves DESC LIMIT 5;

CREATE TABLE reserves_pais (
	id INT AUTO_INCREMENT PRIMARY KEY,
    any INT,
    num_reserves INT,
    nom_pais VARCHAR(40) DEFAULT NULL
);

INSERT INTO reserves_pais (any, num_reserves, nom_pais)
SELECT YEAR(r.data_fi), COUNT(r.reserva_id), p.nom
FROM reserves r
INNER JOIN clients c ON c.client_id = r.client_id
INNER JOIN paisos p ON p.pais_id = c.pais_origen_id
GROUP BY p.nom, YEAR(r.data_fi);

ALTER TABLE reserves_pais
	ADD INDEX pais_reserves(any, num_reserves, nom_pais);

#ok 14. Codi client, Nom, Cognom, del client que ha realitzat més reserves de tota la BD.
EXPLAIN
SELECT c.client_id, c.nom, c.cognom1, COUNT(r.client_id) AS 'Numero de reserves'
  FROM reserves r
INNER JOIN clients c ON c.client_id = r.client_id
GROUP BY c.client_id
ORDER BY 'Numero de reserves' DESC
LIMIT 1; 

#ok 15. Codi client, Nom, Cognom, del client que ha realitzat més reserves durant el mes d’agost de l’any 2016. Les reserves a comptabilitzar són totes aquelles que en algun dia del seu període cau en el mes d’agost.
EXPLAIN
SELECT c.client_id AS 'Codi Client',
       CONCAT (c.nom," ",c.cognom1) AS 'Nom i Cognom',
       COUNT(r.reserva_id) AS Reserves
  FROM clients AS c
INNER JOIN reserves AS r ON r.client_id = c.client_id
WHERE r.data_inici BETWEEN "2016-08-01"
  AND "2016-08-31"
GROUP BY c.client_id, CONCAT (c.nom, " ", c.cognom1)
ORDER BY Reserves DESC
LIMIT 1;

#ok 16. Quin és el país que en tenim menys clients?
EXPLAIN
SELECT p.nom AS 'Nom del pais', COUNT(c.pais_origen_id) AS 'Total de clients del pais'
  FROM paisos AS p
INNER JOIN clients c ON p.pais_id = c.pais_origen_id
GROUP BY p.nom
ORDER BY 'Total de clients del pais'
LIMIT 1;

#17. Quina és la mitjana de nits dels clients provinents d’‘HOLANDA’ per l’any 2016?
#AIUDA XD
EXPLAIN
SELECT AVG(b.Reserves) AS 'Mitjana Reserves Holandesos'
FROM (
      SELECT COUNT(r.reserva_id) AS Reserves,
             YEAR(data_inici) AS Anys
        FROM paisos AS p
      INNER JOIN clients AS c ON c.pais_origen_id = p.pais_id
      INNER JOIN reserves AS r ON c.client_id = r.client_id
      WHERE p.nom = "Holanda"
      GROUP BY Anys
      ) b;

#ok 18. Digues el nom i cognoms dels clients que el seu cognom sigui ‘Bahi’.
EXPLAIN
SELECT nom, cognom1
	FROM clients
WHERE cognom1 = 'Bahi';

ALTER TABLE clients
	ADD INDEX cognom (cognom1, nom);

#ok 19. Quins clients (nom, cognoms) segueixen el patró de que el seu cognom comenci per la lletra ‘p’  i seguida d’una vocal.
EXPLAIN
SELECT nom AS Nom,
       cognom1 AS Cognom
  FROM clients
WHERE cognom1 REGEXP 'P[aeiuo]'
  AND LEFT(cognom1,1) = 'P';

#20. Quin és l’hotel de 4 estrelles amb més reserves durant tot el 2015 ( una reserva pertany el 2015 si alguna de les nits hi pertany).
EXPLAIN
SELECT COUNT(r.reserva_id) AS Reserves, h.nom AS 'Nom hotel'
FROM reserves r 
INNER JOIN habitacions hab ON hab.hab_id = r.hab_id
INNER JOIN hotels h ON h.hotel_id = hab.hotel_id
WHERE r.data_inici >= '2015-01-01' AND r.data_fi <= '2015-12-31'
	AND h.categoria = 4 
GROUP BY h.nom
ORDER BY Reserves DESC
LIMIT 1;



#ok 21. Quin és l’hotel amb més reserves (tota la BD).
EXPLAIN
SELECT COUNT(r.reserva_id) AS 'Numero de reserves',
       h.nom AS Hotel
  FROM reserves r
INNER JOIN habitacions AS hab ON hab.hab_id = r.hab_id
INNER JOIN hotels AS h ON h.hotel_id = hab.hotel_id
GROUP BY h.nom
ORDER BY 'Numero de reserves' DESC
LIMIT 1; 


#ok 22. Quin és el país amb més reserves? (tots els anys) O sigui, quin és el país d’on han vingut més turistes.
EXPLAIN
SELECT nom_pais, SUM(num_reserves) AS 'Total Reserves'
FROM reserves_pais
GROUP BY nom_pais
ORDER BY SUM(num_reserves) DESC
LIMIT 1;
