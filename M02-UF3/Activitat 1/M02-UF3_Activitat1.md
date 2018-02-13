**Sara Caparrós Torres i Patricia López López (ASIX 2 - Curs 2017/18)**  
# ACTIVITAT OPTIMITZACIÓ #
**Index**  
* [Part 1](#part-1)  
* [Part 2 – Query Cache](#part-2--query-cache)  
* [Part 3 – Benchmarking](#part-3--benchmarking)  
![Hotels][hotel]
# Part 1
Disposem d'una base de dades que guarda informació relacionada amb les reserves dels hotels de 4 i 5 estrelles de tot Catalunya.  

Part 1. Escriu les sentències SQL per tal d’obtenir els que se’ns demana. A més a més si creus que la sentència es pot millorar amb la incorporació d’un índex i/o modificació de l’esquema (sense alterar-ne el comportament),etc... Afegeix la sentència DDL i l’_output_ de **EXPLAIN mostrant la millora (EXPLAIN sense índex i EXPLAIN amb índex)**. Si creus que la consulta no es pot millorar mitjançant índexs justifica el perquè. ( 2 punts )
**Nota: No milloreu les sentències amb índexs complerts**

**Important:**
* **Configureu la màquina virtual amb 512MB de RAM**
* **Crea només els índex necessaris! Si hi ha índexs que es poden reaprofitar per diferents sentències fes-ho.**

**1.** Obtenir el nom i l’adreça dels hotels de 4 estrelles.
```
EXPLAIN 
SELECT nom AS 'Nom de l\'hotel', 
       adreca AS 'Adreça' 
	FROM hotels 
WHERE categoria=4;

ALTER TABLE hotels
	ADD INDEX categoria(categoria, nom, adreca);
```
**2.** Obtenir el nom dels clients (Nom i cognom) que el seu cognom comenci per vocal (sense tenir en compte els accents).
```
SELECT CONCAT(nom, ' ',cognom1) AS 'Nom i Cognom' 
	FROM clients 
WHERE LEFT(cognom1,1) IN ('a', 'e', 'i', 'o', 'u');

ALTER table clients
	ADD INDEX nom_complet(nom, cognom1);
```
**3.** Quina és la reserva_id que té més nits. Indica també la quantitat de nits.
```
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
```
**4.** Quantes reserves va rebre l’hotel ‘Catalonia Ramblas’ de Barcelona durant tot  l’any 2015 (una reserva pertany al 2015 si alguna nit d’aquesta reserva era del 2015).
```
SELECT num_reserves,
       nom_hotel 
	FROM hotel_reserves 
WHERE any=2015 
    AND nom_hotel = 'Catalonia Ramblas';

CREATE TABLE hotel_reserves(
	id	INT AUTO_INCREMENT PRIMARY KEY,
	any	INT,
	num_reserves	INT,
	nom_hotel	VARCHAR(50)
);

INSERT INTO hotel_reserves (any, num_reserves, nom_hotel)
SELECT YEAR(r.data_fi), 
       COUNT(r.reserva_id), 
       h.nom
    FROM reserves r
    INNER JOIN habitacions hab ON hab.hab_id = r.hab_id
    INNER JOIN hotels h ON h.hotel_id = hab.hotel_id
GROUP BY h.nom, YEAR(r.data_fi);
```
**5.** Obtenir el nom i cognoms dels clients que varen néixer el mes de Març.
```
SELECT CONCAT(nom, ' ',cognom1) AS 'Nom i Cognom'
	FROM clients 
WHERE mes_naix=3;

ALTER TABLE clients
    ADD COLUMN mes_naix SMALLINT UNSIGNED AS (MONTH(data_naix)) VIRTUAL;

ALTER TABLE clients
    ADD KEY mes (mes_naix);
```
**6.** Quantitat d’hotels de 4 estrelles de la població de Barcelona.
```
SELECT COUNT(h.hotel_id) 
	FROM hotels h 
    INNER JOIN poblacions p ON p.poblacio_id = h.poblacio_id
WHERE p.nom = 'Barcelona';

ALTER TABLE poblacions
    ADD INDEX nom (nom, poblacio_id);
```
**7. NO** De l’any 2015 volem obtenir els seu histograma de reserves. És a dir volem saber el número de reserves de cadascun dels mesos. Una reserva pertany a un mes si la alguna nit d’aquella reserva cau a dins de l’any 2015.
**8.** El nom dels hotels que tenen com a mínim una habitació lliure durant les dates ‘2015-05-01’ i ‘2015-05-17’.
```
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
```
**9.** Obtenir la quantitat de reserves que s’inicien en cadascun dels dies de la setmana. Tenint en compte només l’any 2016.
```
SELECT diasetmana, 
       COUNT(data_inici)
    FROM reserves
WHERE data_inici >= "2016-01-01"
    AND data_fi <= "2016-12-31"
GROUP BY diasetmana;

ALTER TABLE reserves
    ADD COLUMN diasetmana SMALLINT UNSIGNED AS (WEEKDAY(data_inici)+1) VIRTUAL;

ALTER TABLE reserves
    ADD INDEX diasetmana (diasetmana, data_inici, data_fi);
```
**10.** Durant 2014 qui va realitzar més reserves? Els homes o les dones? Mostra el sexe i el número de reserves.
```
SELECT c.sexe AS 'Genere', 
       count(r.reserva_id) AS 'Quantitat Reserves'
	FROM clients as c
    INNER JOIN reserves r ON r.client_id = c.client_id
WHERE r.data_inici >= '2014-01-01' AND r.data_fi <= '2014-12-31'
GROUP BY c.sexe;
```
**11.** Quina és la mitjana de dies de reserva per l’hotel «HTOP Royal Star» de Blanes durant l’any 2016? (Una reserva pertany el 2016 si alguna nit cau en aquest any).
```
SELECT AVG(DAY(r.data_inici))
  FROM reserves r
INNER JOIN habitacions hab ON r.hab_id = hab.hab_id
INNER JOIN hotels h ON h.hotel_id = hab.hotel_id
WHERE h.nom = 'HTOP Royal Star'
  AND r.data_inici >= "2016-01-01"
  AND r.data_fi <= "2016-12-31";
```
**12.** El nom, categoria, adreça i número d’habitacions de l’hotel amb més habitacions de la BD.
```
SELECT nom,
       categoria,
       habitacions
  FROM hotels
WHERE habitacions = (SELECT MAX(habitacions)
                      FROM hotels);
                      
ALTER TABLE hotels
    ADD INDEX hotels (nom, categoria, habitacions);
```
**13.** Rànquing de 5 països amb més reserves durant l’any 2016. Per cada país mostrar el nom del país i el número de reserves.
```
SELECT nom_pais, 
       num_reserves 
    FROM reserves_pais 
WHERE any=2016 
ORDER BY num_reserves DESC 
LIMIT 5;

CREATE TABLE reserves_pais (
    id INT AUTO_INCREMENT PRIMARY KEY,
    any INT,
    num_reserves INT,
    nom_pais VARCHAR(40) DEFAULT NULL
);

INSERT INTO reserves_pais (any, num_reserves, nom_pais)
SELECT YEAR(r.data_fi), 
       COUNT(r.reserva_id), 
       p.nom
    FROM reserves r
    INNER JOIN clients c ON c.client_id = r.client_id
    INNER JOIN paisos p ON p.pais_id = c.pais_origen_id
GROUP BY p.nom, YEAR(r.data_fi);

ALTER TABLE reserves_pais
	ADD INDEX pais_reserves(any, num_reserves, nom_pais);
```
**14.** Codi client, Nom, Cognom, del client que ha realitzat més reserves de tota la BD.
```
SELECT c.client_id, 
       c.nom, 
       c.cognom1, 
       COUNT(r.client_id) AS 'Numero de reserves'
  FROM reserves r
  INNER JOIN clients c ON c.client_id = r.client_id
GROUP BY c.client_id
ORDER BY 'Numero de reserves' DESC
LIMIT 1; 
```
**15.** Codi client, Nom, Cognom, del client que ha realitzat més reserves durant el mes d’agost de l’any 2016. Les reserves a comptabilitzar són totes aquelles que en algun dia del seu període cau en el mes d’agost.
```
SELECT c.client_id AS 'Codi Client',
       CONCAT(c.nom," ",c.cognom1) AS 'Nom i Cognom',
       COUNT(r.reserva_id) AS Reserves
  FROM clients AS c
  INNER JOIN reserves AS r ON r.client_id = c.client_id
WHERE r.data_inici BETWEEN "2016-08-01"
  AND "2016-08-31"
GROUP BY c.client_id, CONCAT(c.nom, " ", c.cognom1)
ORDER BY Reserves DESC
LIMIT 1;
```
**16.** Quin és el país que en tenim menys clients?
```
SELECT p.nom AS 'Nom del pais', 
       COUNT(c.pais_origen_id) AS 'Total de clients del pais'
  FROM paisos AS p
  INNER JOIN clients c ON p.pais_id = c.pais_origen_id
GROUP BY p.nom
ORDER BY 'Total de clients del pais'
LIMIT 1;
```
**17.** Quina és la mitjana de nits dels clients provinents d’‘HOLANDA’ per l’any 2016?
```
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
```
**18.** Digues el nom i cognoms dels clients que el seu cognom sigui ‘Bahi’.
```
SELECT nom, 
       cognom1
	FROM clients
WHERE cognom1 = 'Bahi';

ALTER TABLE clients
	ADD INDEX cognom (cognom1, nom);
```
**19.** Quins clients (nom, cognoms) segueixen el patró de que el seu cognom comenci per la lletra ‘p’  i seguida d’una vocal.
```
SELECT nom AS Nom,
       cognom1 AS Cognom
  FROM clients
WHERE cognom1 REGEXP 'P[aeiuo]'
  AND LEFT(cognom1,1) = 'P';
```
**20.** Quin és l’hotel de 4 estrelles amb més reserves durant tot el 2015 ( una reserva pertany el 2015 si alguna de les nits hi pertany).
```
SELECT nom_hotel, 
       num_reserves 
       FROM hotel_reserves 
       INNER JOIN hotels ON nom = nom_hotel
WHERE any=2015 
    AND categoria = 4
ORDER BY num_reserves DESC
LIMIT 1;
```
**21.** Quin és l’hotel amb més reserves (tota la BD).
```
SELECT COUNT(r.reserva_id) AS 'Numero de reserves',
       h.nom AS Hotel
  FROM reserves r
  INNER JOIN habitacions AS hab ON hab.hab_id = r.hab_id
  INNER JOIN hotels AS h ON h.hotel_id = hab.hotel_id
GROUP BY h.nom
ORDER BY 'Numero de reserves' DESC
LIMIT 1; 
```
**22.** Quin és el país amb més reserves? (tots els anys) O sigui, quin és el país d’on han vingut més turistes.
```
SELECT nom_pais, 
       SUM(num_reserves) AS 'Total Reserves'
    FROM reserves_pais
GROUP BY nom_pais
ORDER BY SUM(num_reserves) DESC
LIMIT 1;

```


# Part 2 – Query Cache
**Escull 5 sentències SQL de la Part 1 (intenta que els temps d’execució siguin significatius)**
## Quins temps d'execució t'han sortit per cada consulta?  
Sentència número 3  
![qc-1][qc-1]  
Sentència número 9  
![qc-2][qc-2]  
Sentència número 10  
![qc-3][qc-3]  
Sentència número 15  
![qc-4][qc-4]  
Sentència número 21  
![qc-5][qc-5]  

## Activa la Query Cache (ON)  
Per activar la cache, entrem al **Mysql** i li assignem un tamany de 16Mb a la cache:  
![qc-6][qc-6]  
![qc-7][qc-7]   
Un cop fet, des del fitxer `/etc/my.cnf` es pot configurar alguns paràmetres de la cache:  
![qc-8][qc-8]   
També es pot activar dins del **Mysql**:  
![qc-9][qc-9]  

### Reexecuta les consultes anteriors 2 vegades seguides. Ha millorat el temps d'execució?  
Sentència número 3  
![qc-10][qc-10]  
Sentència número 9  
![qc-11][qc-11]  
Sentència número 10  
![qc-12][qc-12]  
Sentència número 15  
![qc-13][qc-13]  
Sentència número 21  
![qc-14][qc-14]  

Ha millorat considerablement el temps.  

### Quina modificació hem de fer perquè la consulta no passi per Cache? (reescriu una consulta amb els canvis)  
Per que una sentència no pasi per cache, hem d’afegir el paràmetre `SQL_NO_CACHE` després del `SELECT`:  
![qc-15][qc-15]  

## Activa la Query Cache (ON DEMAND)  
![qc-16][qc-16]  

També es pot amb `query_cache_type=2`.  

### Posa un exemple d'execució sota demanda.  
![qc-17][qc-17]  

### Quina modificació hem de fer perquè la consulta passi per Cache?(reescriu la consulta amb els canvis)  
Per que una consulta pasi per cache hem d’escriure `SQL_CACHE` després del `SELECT`:  
![qc-18][qc-18]  

## Un cop acabats els punts anteriors mostra quin ha estat el teu CacheHitRatio? Com has obtingut els valors de cache_hits i cache_misses?  
Per veure el **CacheHitRadio** hem d’aplicar la següent fórmula:  
![qc-19][qc-19]  
![qc-20][qc-20]  
![qc-21][qc-21]  
![qc-22][qc-22]  

## Demostra quines sentències DML (INSERT, UPDATE, DELETE) provoquen que es buidi la cache de les taules implicades amb aquestes sentències.  
![qc-23][qc-23]  
Amb un `RESET query cache` es neteja la memòria cache.  


# Part 3 – Benchmarking
Mitjançant la eina Sysbench prepara un joc de proves mitjançant les sentències SQL anteriors o d’altres que creguis que puguin anar bé per realitzar les proves.
Documenta la instal·lació de l'eina, la creació dels scripts de prova i l’execució de les proves.  
[Documentació](https://www.howtoforge.com/how-to-benchmark-your-system-cpu-file-io-mysql-with-sysbench)  
Instal·lació sysbench amb `yum install sysbench`  
![b-1][b-1]  

## Test 1
Treu tots els índexs de la Part 1 i desactiva la CACHE i realitza el benchmark
## Test 2
Afegeix els índexs de  la part 1
## Test 3
Activa la CACHE (també fes que les consultes passin per aquesta CACHE)
## Realitza una comparativa mostrant els resultats obtinguts dels tres benchmarks.
## En el tercer cas indica quin ha estat el valor de CacheHitRatio.


[hotel]: imgs/hotel.png
[qc-1]: imgs/qc-1.png
[qc-2]: imgs/qc-2.png
[qc-3]: imgs/qc-3.png
[qc-4]: imgs/qc-4.png
[qc-5]: imgs/qc-5.png
[qc-6]: imgs/qc-6.png
[qc-7]: imgs/qc-7.png
[qc-8]: imgs/qc-8.png
[qc-9]: imgs/qc-9.png
[qc-10]: imgs/qc-10.png
[qc-11]: imgs/qc-11.png
[qc-12]: imgs/qc-12.png
[qc-13]: imgs/qc-13.png
[qc-14]: imgs/qc-14.png
[qc-15]: imgs/qc-15.png
[qc-16]: imgs/qc-16.png
[qc-17]: imgs/qc-17.png
[qc-18]: imgs/qc-18.png
[qc-19]: imgs/qc-19.png
[qc-20]: imgs/qc-20.png
[qc-21]: imgs/qc-21.png
[qc-22]: imgs/qc-22.png
[qc-23]: imgs/qc-23.png
[b-1]: imgs/b-1.png
