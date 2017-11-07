**Sara Caparrós Torres i Patricia López López (ASIX 2 - Curs 2017/18)**
# ACTIVITAT Storage Engines MySQL #

## ENUNCIAT ##

Partint d'una màquina CentOS 7 amb el Percona Server 5.7 instal·lat realitza els següents apartats a on es tracten els diferents Storage Engines que conté el MySQL i en conseqüència el Percona Server.


## Activitat 1. REALITZA I/O RESPON ELS SEGÜENTS APARTATS ##

1.	Indica quins són els motors d’emmagatzematge que pots utilitzar (quins estan actius)? Mostra al comanda utilitzada i el resultat d’aquesta.  
  
Amb la comanda `SHOW ENGINES` podem veure quins motors d’emmagatzematge te-nim.  
Per veure els camps ordenats podem posar `SHOW EGINES\G;`  

![screenshot_ex1-1](./imgs/Act1_ex1-p1.png)  
![screenshot_ex1-2](./imgs/Act1_ex1-p2.png)  

El camp **Support** indica el següent:
  
| Valor | Significat |
| ---------- | ---------- |
| `YES`   | L’emmagatzematge està suportat i actiu  |
| `DEFAULT`   | Com el `YES`, a més és l’emmagatzematge per defecte  |
| `NO`   | L’emmagatzematge no està suportat  |
| `DISABLED`   | L’emmagatzematge està suportat i pero no està actiu |
  
2.	Com puc saber quin és el motor d’emmagatzematge per defecte. Mostra com canviar aquest paràmetre de tal manera que les noves taules que creem a la BD per defecte utilitzin el motor MyISAM?  
  
El motor d’emmagatzematge per defecte és el InnoDB  
![screenshot_ex1-1](./imgs/Act1_ex2-p1.png)  
Per canviar el valor per defecte editem el fitxer de configuració **/etc/my.cnf**  
![screenshot_ex1-1](./imgs/Act1_ex2-p2.png)  
`Service mysql restart` i comprovem que s’hagi canviat  
![screenshot_ex1-1](./imgs/Act1_ex2-p3.png)  
  
3.	Com podem saber quin és el motor d'emmagatzematge per defecte?  
  
Amb la comanda `SHOW ENGINES\G` mirant el camp **Support**, ha de ser `DEFAULT`.  
  
4.	Explica els passos per instal·lar i activar l'*ENGINE MyRocks*. MyRocks és un motor d'emmagatzematge per MySQL basat en RocksDB (SGBD incrustat de tipus clau-valor).  
  
[Documentació MyRocks](https://www.percona.com/doc/percona-server/LATEST/myrocks/install.html)  

Instal·lem Percona MyRocks:  
`sudo yum install Percona-Server-rocksdb-57.x86_64`  
![screenshot_ex1-1](./imgs/Act1_ex4-p1.png)  
![screenshot_ex1-1](./imgs/Act1_ex4-p2.png)  
Executem l’script `ps-admin` com a usuari root o amb sudo, i donar credencials d’usuari root de MySQL per habilitar el motor d’emmagatzematge RocksDB (My-Rocks).  
`sudo ps-admin --enable-rocksdb -u root –ppatata`  
![screenshot_ex1-1](./imgs/Act1_ex4-p3.png)  
Comprovem que està instal·lat  
![screenshot_ex1-1](./imgs/Act1_ex4-p4.png)  
  
```
CREATE DATABASE proves;
USE proves;
CREATE TABLE equips (
	equip_id	SMALLINT UNSIGNED PRIMARY KEY,
	nom		VARCHAR(30) NOT NULL,
	esponsor	VARCHAR(20) NOT NULL,
	director	VARCHAR(20) NOT NULL,
	pressupost	DECIMAL(11,3)
) ENGINE=Rocksdb;
```
  
![screenshot_ex1-1](./imgs/Act1_ex4-p5.png)  
![screenshot_ex1-1](./imgs/Act1_ex4-p6.png)  
  
5.	Importa la BD Sakila com a taules MyISAM. Fes els canvis necessaris per importar la BD Sakila perquè totes les taules siguin de tipus MyISAM.  
Mira quins són els fitxers físics que ha creat, quan ocupen i quines són les seves extensions. Mostra'n una captura de pantalla i indica què conté cada fitxer.  
  
Per canviar les taules a MyISAM, editem el fitxer sakila-schema.sql i modifiquem els EN-GINE posant MyISAM.  
```
CREATE TABLE actor (  
actor_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,  
first_name VARCHAR(45) NOT NULL,  
last_name VARCHAR(45) NOT NULL,  
last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,  
PRIMARY KEY  (actor_id),  
KEY idx_actor_last_name (last_name)  
)ENGINE=MyISAM DEFAULT CHARSET=utf8;  
```
Per veure el sistema d’emmagatzament més senzill, ho farem amb aquesta comanda:  
```
SELECT table_name, engine  
FROM information_schema.TABLES  
WHERE TABLE_SCHEMA='sakila';  
```
![screenshot_ex1-1](./imgs/Act1_ex5-p1.png)  
  
Una altre manera és un cop importada (sense haver modificat l’ENGINE) es pot canviar cada taula amb:  
`ALTER TABLE nom_taula ENGINE = MYISAM;`  
L’únic problema són les Foreign Keys, que no deixen modificar-ho correctament.  
  
Al haver creat la base de dades amb MyIsam, MyIam crea 3 fitxers que es guarden física-ment per cada taula:  
* Format file (.frm): Guarda la definició de l'estructura de la taula
* Data file (.MYD): Guarda el contingut de la taula (files/dades)
* Index file (.MYI): Guarda els índexs de la taula

Aquest fitxers es troben a **/var/lib/mysq/sakila**  
![screenshot_ex1-1](./imgs/Act1_ex5-p2.png)  
  
per exemple si mirem el contingut del fitxer **address.frm**:  
![screenshot_ex1-1](./imgs/Act1_ex5-p3.png)  
  
El contingut del fitxer **address.MYD** i **address.MYI** no ens deixa veure-ho.  
  
Podem veure quant ocupen amb un `ls -l`  
![screenshot_ex1-1](./imgs/Act1_ex5-p4.png)  
  
## Activitat 2. INNODB part I. REALITZA ELS SEGÜENTS APARTATS. ##

1.	Importa la BD Sakila com a taules InnoDB.  
2.	Quin/quins són els fitxers de dades? A on es troben i quin és la seva mida?  
3.	Canvia la configuració del MySQL perquè:  
	* Canviar la localització dels fitxers del tablespace de sistema per defecte a /discs-mysql/  
	* Tinguem dos fitxers corresponents al tablespace de sistema.  
	* Tots dos han de tenir la mateixa mida inicial (1MB)  
	* El tablespace ha de creixer de 1MB en 1MB.  
	* Situa aquests fitxers (de manera relativa a la localització per defecte) en una nova localització simulant el següent:  
		* /discs-mysql/disk1/primer fitxer de dades → simularà un disc dur  
		* /discs-mysql/disk2/segon fitxer de dades → simularà un segon disc dur.  
4.	**Checkpoint:** Mostra al professor els canvis realitzats i que la BD continua funcionant.  


## Activitat 3. INNODB part II. REALITZA ELS SEGÜENTS APARTATS. ##

1.	Partint de l'esquema anterior configura el Percona Server perquè cada taula generi el seu propi tablespace en una carpeta anomenada ***tspaces*** *(aquesta pot estar situada a on vulgueu)*.  
	1.	Indica quins són els canvis de configuració que has realitzat.  
	2.	Després del canvi què ha passat amb els fitxers que contenien les dades de la BD de Sakila? Fes les captures necesàries per complementar la resposta.  

## Activitat 4. INNODB part III. REALITZA ELS SEGÜENTS APARTATS. ##

1.	Crea un tablespace anomenat **'ts1'** situat a `/discs-mysql/disc1/` i col·loca les taules *actor*, *address* i *category* de la BD Sakila.  
2.	Crea un altre tablespace anomenat **'ts2'** situat a `/discs-mysql/disc2/` i col·loca-hi la resta de taules.  
3.	Comprova que pots realitzar operacions DML a les taules dels dos tablespaces.  
4.	Quines comandes i configuracions has realitzat per fer els dos apartats anteriors?  
5.	**Checkpoint:** Mostra al professor els canvis realitzats i que la BD continua funcionant  

## Activitat 5. REDOLOG. REALITZA ELS SEGÜENTS APARTATS. ##

1.	Com podem comprovar (Innodb Log Checkpointing):  
	* LSN (Log Sequence Number)  
	* L'últim LSN actualitzat a disc  
	* Quin és l'últim LSN que se li ha fet Checkpoint  
2.	Proposa un exemple a on es vegi l'ús del redolog  
3.	Com podem mirar el número de pàgines modificades (dirty pages)? I el número total de pàgines?  
4.	**Checkpoint:** Mostra al professor els canvis realitzats i que la BD continua funcionant.  

## Activitat 6. Implementar BD Distribuïdes.  ##

Com s'ha vist a classe MySQL proporciona el motor d'emmagatzemament FEDERATED que té com a funció permetre l'accés remot a bases de dades MySQL en un servidor local sense utilitzar tècniques de replicació ni clustering.  

1.	Prepara un Servidor Percona Server amb la BD de Sakila  
2.	Prepara un segon servidor Percona Server a on hi hauran un conjunt de taules FEDERADES al primer servdor.  
3.	Per realitzar aquest link entre les dues BD podem fer-ho de dues maneres:  
	1.	Opció1: especificar TOTA la cadena de connexió a CONNECTION  
	2.	Opció2: especificar una connexió a un server a CONNECTION que prèviament s'ha creat mitjançant CREATE SERVER  
	3.	Posa un exemple de 2 taules de cada opció.  
Tingues en compte els permisos a nivell de BD i de SO així com temes de seguretat com firewalls, etc...  
	4.	Detalla quines són els passos i comandes que has hagut de realitzar en cada màquina.  
4.	**Checkpoint:** Mostra al professor la configuració que has hagut de realitzar i el seu funcionament.  

## Activitat 7. Storage Engine CSV ##  
1. Documenta i posa exemple de com utilitzar ENGINE CSV.  
  
Aquest engine guarda les dades en fitxers de text utilitzant una coma per separar cada paràmetre.  
Aquesta és una forma d’exportar les dades d’una taula molt ràpidament, i que es pot obrir amb un Excel, un Calc, etc. i fins i tot és un format que és molt senzill per “posar-ho maco” amb PowerShell o C#...
  
2.	Cal documentar els passos que has hagut de realitzar per preparar l'exemple: configuracions, instruccions DML, DDL, etc...  
```
USE proves;  
CREATE TABLE test (  
    i	INT		NOT NULL,  
    c	CHAR(10)	NOT NULL  
) ENGINE=csv;  
INSERT INTO test VALUES (1,’record one’),(2,’record two’);  
SELECT * FROM test;  
```
| i | c |
| ---------- | ---------- |
| 1 | record one |
| 2 | record two |


Dintre d’aquest estan tots els arxius, i està el test.csv  

```
[root@asix2 proves]# cd /var/lib/mysql/proves  
[root@asix2 proves]# ls  
db.opt	equips.frm	test.CSM	test.CSV	test.frm  
[root@asix2 proves]# cat test.CSV  
1,”record one”  
2,”record two”  
```