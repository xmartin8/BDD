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

**Important:
* Configureu la màquina virtual amb 512MB de RAM
* Crea només els índex necessaris! Si hi ha índexs que es poden reaprofitar per diferents sentències fes-ho.**

1. Obtenir el nom i l’adreça dels hotels de 4 estrelles.
2. Obtenir el nom dels clients (Nom i cognom) que el seu cognom comenci per vocal (sense tenir en compte els accents).
3. Quina és la reserva_id que té més nits. Indica també la quantitat de nits.
4. Quantes reserves va rebre l’hotel ‘Catalonia Ramblas’ de Barcelona durant tot  l’any 2015 (una reserva pertany al 2015 si alguna nit d’aquesta reserva era del 2015).
5. Obtenir el nom i cognoms dels clients que varen néixer el mes de Març.
6. Quantitat d’hotels de 4 estrelles de la població de Barcelona.
7. De l’any 2015 volem obtenir els seu histograma de reserves. És a dir volem saber el número de reserves de cadascun dels mesos. Una reserva pertany a un mes si la alguna nit d’aquella reserva cau a dins de l’any 2015.
8. El nom dels hotels que tenen com a mínim una habitació lliure durant les dates ‘2015-05-01’ i ‘2015-05-17’.
9. Obtenir la quantitat de reserves que s’inicien en cadascun dels dies de la setmana. Tenint en compte només l’any 2016.
10. Durant 2014 qui va realitzar més reserves? Els homes o les dones? Mostra el sexe i el número de reserves.
11. Quina és la mitjana de dies de reserva per l’hotel «HTOP Royal Star» de Blanes durant l’any 2016? (Una reserva pertany el 2016 si alguna nit cau en aquest any).
12. El nom, categoria, adreça i número d’habitacions de l’hotel amb més habitacions de la BD.
13. Rànquing de 5 països amb més reserves durant l’any 2016. Per cada país mostrar el nom del país i el número de reserves.
14. Codi client, Nom, Cognom, del client que ha realitzat més reserves de tota la BD.
15. Codi client, Nom, Cognom, del client que ha realitzat més reserves durant el mes d’agost de l’any 2016. Les reserves a comptabilitzar són totes aquelles que en algun dia del seu període cau en el mes d’agost.
16. Quin és el país que en tenim menys clients?
17. Quina és la mitjana de nits dels clients provinents d’‘HOLANDA’ per l’any 2016?
18. Digues el nom i cognoms dels clients que el seu cognom sigui ‘Bahi’.
19. Quins clients (nom, cognoms) segueixen el patró de que el seu cognom comenci per la lletra ‘p’  i seguida d’una vocal.
20. Quin és l’hotel de 4 estrelles amb més reserves durant tot el 2015 ( una reserva pertany el 2015 si alguna de les nits hi pertany).
21. Quin és l’hotel amb més reserves (tota la BD).
22. Quin és el país amb més reserves? (tots els anys) O sigui, quin és el país d’on han vingut més turistes.


# Part 2 – Query Cache
**Escull 5 sentències SQL de la Part 1 (intenta que els temps d’execució siguin significatius)**
* Quins temps d'execució t'han sortit per cada consulta?
* Activa la Query Cache (ON)
    - Reexecuta les consultes anteriors 2 vegades seguides. Ha millorat el temps d'execució?
    - Quina modificació hem de fer perquè la consulta no passi per Cache? (reescriu una consulta amb els canvis)
* Activa la Query Cache (ON DEMAND)
    - Posa un exemple d'execució sota demanda.
    - Quina modificació hem de fer perquè la consulta passi per Cache?(reescriu la consulta amb els canvis)
* Un cop acabats els punts anteriors mostra quin ha estat el teu CacheHitRatio? Com has obtingut els valors de cache_hits i cache_misses?
* Demostra quines sentències DML (INSERT, UPDATE, DELETE) provoquen que es buidi la cache de les taules implicades amb aquestes sentències.


# Part 3 – Benchmarking
Mitjançant la eina Sysbench prepara un joc de proves mitjançant les sentències SQL anteriors o d’altres que creguis que puguin anar bé per realitzar les proves.
Documenta la instal·lació de l'eina, la creació dels scripts de prova i l’execució de les proves.
## Test 1
Treu tots els índexs de la Part 1 i desactiva la CACHE i realitza el benchmark
## Test 2
Afegeix els índexs de  la part 1
## Test 3
Activa la CACHE (també fes que les consultes passin per aquesta CACHE)
## Realitza una comparativa mostrant els resultats obtinguts dels tres benchmarks.
## En el tercer cas indica quin ha estat el valor de CacheHitRatio.


[hotel]: imgs/hotel.png