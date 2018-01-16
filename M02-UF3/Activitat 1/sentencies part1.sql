#1. Obtenir el nom i l’adreça dels hotels de 4 estrelles.
SELECT nom AS 'Nom de l\'hotel', 
	   adreca AS 'Adreça' 
	FROM hotels 
WHERE categoria=4;

#2. Obtenir el nom dels clients (Nom i cognom) que el seu cognom comenci per vocal (sense tenir en compte els accents).
SELECT concat(nom, ' ',cognom1) AS 'Nom i Cognom' 
	FROM clients 
WHERE left(cognom1,1) = 'A';

#3. Quina és la reserva_id que té més nits. Indica també la quantitat de nits.
SELECT reserva_id AS 'Reserva ID', 
	   data_inici AS 'Data d\'inici', 
       data_fi AS 'Data fi', 
       MAX(TIMESTAMPDIFF(DAY,data_inici,data_fi)) AS Dies 
	FROM reserves 
GROUP BY reserva_id 
ORDER BY Dies DESC 
LIMIT 1;



#4. Quantes reserves va rebre l’hotel ‘Catalonia Ramblas’ de Barcelona durant tot  l’any 2015 (una reserva pertany al 2015 si alguna nit d’aquesta reserva era del 2015).
SELECT COUNT(r.reserva_id) AS 'Quantitat Reserves',
	   h.nom AS 'Nom de l\'hotel'
  FROM reserves as r
INNER JOIN habitacions as hab ON hab.hab_id = r.hab_id
INNER JOIN hotels as h ON h.hotel_id = hab.hotel_id
WHERE h.nom = 'Catalonia Ramblas';

#5. Obtenir el nom i cognoms dels clients que varen néixer el mes de Març.
SELECT concat(nom, ' ',cognom1) AS 'Nom i Cognom'
	FROM clients 
WHERE substring(data_naix,6,2)=03;


#6. Quantitat d’hotels de 4 estrelles de la població de Barcelona.
SELECT COUNT(h.hotel_id) 
	FROM hotels h 
    INNER JOIN poblacions p ON p.poblacio_id = h.poblacio_id
WHERE p.nom = 'Barcelona';

#7. De l’any 2015 volem obtenir els seu histograma de reserves. És a dir volem saber el número de reserves de cadascun dels mesos. Una reserva pertany a un mes si la alguna nit d’aquella reserva cau a dins de l’any 2015.
SELECT count(r.reserva_id) AS 'Quantitat Reserves', 
	   h.nom AS Nom
	FROM reserves r
    INNER JOIN habitacions hab ON hab.hab_id = r.hab_id
    INNER JOIN hotels h ON h.hotel_id = hab.hotel_id
GROUP BY h.nom;

#ARREGLAR 8. El nom dels hotels que tenen com a mínim una habitació lliure durant les dates ‘2015-05-01’ i ‘2015-05-17’.
SELECT r.data_inici,r.data_fi,hab.hab_id, hab.hotel_id
  FROM reserves AS r
INNER JOIN habitacions AS hab ON hab.hab_id = r.hab_id
WHERE r.data_inici > "2015-05-01"
      AND r.data_fi < "2015-05-17";
      

#9. Obtenir la quantitat de reserves que s’inicien en cadascun dels dies de la setmana. Tenint en compte només l’any 2016.


#10. Durant 2014 qui va realitzar més reserves? Els homes o les dones? Mostra el sexe i el número de reserves.


#11. Quina és la mitjana de dies de reserva per l’hotel «HTOP Royal Star» de Blanes durant l’any 2016? (Una reserva pertany el 2016 si alguna nit cau en aquest any).


#12. El nom, categoria, adreça i número d’habitacions de l’hotel amb més habitacions de la BD.


#13. Rànquing de 5 països amb més reserves durant l’any 2016. Per cada país mostrar el nom del país i el número de reserves.


#14. Codi client, Nom, Cognom, del client que ha realitzat més reserves de tota la BD.


#15. Codi client, Nom, Cognom, del client que ha realitzat més reserves durant el mes d’agost de l’any 2016. Les reserves a comptabilitzar són totes aquelles que en algun dia del seu període cau en el mes d’agost.


#16. Quin és el país que en tenim menys clients?


#17. Quina és la mitjana de nits dels clients provinents d’‘HOLANDA’ per l’any 2016?


#18. Digues el nom i cognoms dels clients que el seu cognom sigui ‘Bahi’.


#19. Quins clients (nom, cognoms) segueixen el patró de que el seu cognom comenci per la lletra ‘p’  i seguida d’una vocal.


#20. Quin és l’hotel de 4 estrelles amb més reserves durant tot el 2015 ( una reserva pertany el 2015 si alguna de les nits hi pertany).


#21. Quin és l’hotel amb més reserves (tota la BD).


#22. Quin és el país amb més reserves? (tots els anys) O sigui, quin és el país d’on han vingut més turistes.


