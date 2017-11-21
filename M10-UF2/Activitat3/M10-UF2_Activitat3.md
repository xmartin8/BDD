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
| `DISABLED`   | L’emmagatzematge està suportat però no està actiu |
  
2.	Com puc saber quin és el motor d’emmagatzematge per defecte. Mostra com canviar aquest paràmetre de tal manera que les noves taules que creem a la BD per defecte utilitzin el motor MyISAM?  
  
El motor d’emmagatzematge per defecte és el InnoDB  
![screenshot_ex2-1](./imgs/Act1_ex2-p1.png)  
Per canviar el valor per defecte editem el fitxer de configuració **/etc/my.cnf**  
![screenshot_ex2-2](./imgs/Act1_ex2-p2.png)  
`Service mysql restart` i comprovem que s’hagi canviat  
![screenshot_ex2-3](./imgs/Act1_ex2-p3.png)  
  
3.	Com podem saber quin és el motor d'emmagatzematge per defecte?  
  
Amb la comanda `SHOW ENGINES\G` mirant el camp **Support**, ha de ser `DEFAULT`.  
  
4.	Explica els passos per instal·lar i activar l'*ENGINE MyRocks*. MyRocks és un motor d'emmagatzematge per MySQL basat en RocksDB (SGBD incrustat de tipus clau-valor).  
  
[Documentació MyRocks](https://www.percona.com/doc/percona-server/LATEST/myrocks/install.html)  

Instal·lem Percona MyRocks:  
`sudo yum install Percona-Server-rocksdb-57.x86_64`  
![screenshot_ex4-1](./imgs/Act1_ex4-p1.png)  
![screenshot_ex4-2](./imgs/Act1_ex4-p2.png)  
Executem l’script `ps-admin` com a usuari root o amb sudo, i donar credencials d’usuari root de MySQL per habilitar el motor d’emmagatzematge RocksDB (My-Rocks).  
`sudo ps-admin --enable-rocksdb -u root –ppatata`  
![screenshot_ex4-3](./imgs/Act1_ex4-p3.png)  
Comprovem que està instal·lat  
![screenshot_ex4-4](./imgs/Act1_ex4-p4.png)  
  
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
  
![screenshot_ex4-5](./imgs/Act1_ex4-p5.png)  
![screenshot_ex4-6](./imgs/Act1_ex4-p6.png)  
  
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
![screenshot_ex5-1](./imgs/Act1_ex5-p1.png)  
  
Una altre manera és un cop importada (sense haver modificat l’ENGINE) es pot canviar cada taula amb:  
`ALTER TABLE nom_taula ENGINE = MYISAM;`  
L’únic problema són les Foreign Keys, que no deixen modificar-ho correctament.  
  
Al haver creat la base de dades amb MyIsam, MyIam crea 3 fitxers que es guarden física-ment per cada taula:  
* Format file (.frm): Guarda la definició de l'estructura de la taula
* Data file (.MYD): Guarda el contingut de la taula (files/dades)
* Index file (.MYI): Guarda els índexs de la taula

Aquest fitxers es troben a **/var/lib/mysq/sakila**  
![screenshot_ex5-2](./imgs/Act1_ex5-p2.png)  
  
per exemple si mirem el contingut del fitxer **address.frm**:  
![screenshot_ex5-3](./imgs/Act1_ex5-p3.png)  
  
El contingut del fitxer **address.MYD** i **address.MYI** no ens deixa veure-ho.  
  
Podem veure quant ocupen amb un `ls -l`  
![screenshot_ex5-4](./imgs/Act1_ex5-p4.png)  
  
## Activitat 2. INNODB part I. REALITZA ELS SEGÜENTS APARTATS. ##

1.	Importa la BD Sakila com a taules InnoDB.  

Importem la base de dades amb un `SOURCE`.  
![screenshot_ex2-1-1](./imgs/Act2_ex1-p1.png)  

![screenshot_ex2-1-2](./imgs/Act2_ex1-p2.png)  

2.	Quin/quins són els fitxers de dades? A on es troben i quin és la seva mida?  

Els fitxers que crea InnoDB es troben a `/var/lib/mysql/sakila` i són els fitxers amb extensió:  
* .ibd (integrated backup): conté dades i índexs de cada taula (només quan està activitat el `Innodb_file_per_table` , que guarda cada taula en un fitxer).  
* .ibdata1 (integrated backup data part 1): conté el diccionari de dades i l’historial de transaccions per totes les taules.  
* .frm (format): descriu el format de les taules, inclosos els camps i estructura de cada taula.  

Si `Innodb_file_per_table`  està activat, podem veure el següent:  
![screenshot_ex2-2-1](./imgs/Act2_ex2-p1.png)  

Si `Innodb_file_per_table` està desactivat, podem veure el següent:  
![screenshot_ex2-2-2](./imgs/Act2_ex2-p2.png)  

3.	Canvia la configuració del MySQL perquè:  
	* Canviar la localització dels fitxers del tablespace de sistema per defecte a /discs-mysql/  
	
	[Documentació Tecmint](https://www.tecmint.com/change-default-mysql-mariadb-data-directory-in-linux/)  
	
	Primer creem el nou directori i li atorguem permisos.  
	`mkdir /discs-mysql`  
	`chown -R mysql:mysql /discs-mysql`
	  
	Parem el servei mysql.
	`service mysqld stop`  
	
	Copiem els fitxers de mysql al nou directori.
	`cp -R -p /var/lib/mysql/* /discs-mysql`  
	![screenshot_ex2-1-1](./imgs/Act2_ex3-1-p1.png)  
	
	Editem el fitxer `/etc/my.cnf` per afegir el nou directori.  
	![screenshot_ex2-1-2](./imgs/Act2_ex3-1-p2.png)  
	
	Afegim la seguretat SELinux al nou directori abans de engegar de nou el mysql.  
	`semanage fcontext -a -t mysqld_db_t "/discs-mysql(/.*)?"`  
	`restorecon -R /discs-mysql`  
	
	Engeguem el servei mysql.
	`service mysqld start`  
	
	Mirem si el directori ha canviat entrant al mysql i fent un `SELECT @@datadir;`  
	![screenshot_ex2-1-3](./imgs/Act2_ex3-1-p3.png)  

	
	* Tinguem dos fitxers corresponents al tablespace de sistema.  
	
	[Documentació InnoDB](https://dev.mysql.com/doc/refman/5.7/en/innodb-init-startup-configuration.html)  
	
	Si anem al nou directori que hem creat veurem que només en tenim un system tablespace.  
	Volem tenir-ne 2.  
	![screenshot_ex3-2-1](./imgs/Act2_ex3-2-p1.png)  
	
	Fem un `service mysqld stop`.  
	Amb la comanda `rm -rf /discs-mysql/ib*`borrem el ibdata.  
	Editem el fitxer `/etc/my.cnf`.  
	![screenshot_ex3-2-2](./imgs/Act2_ex3-2-p2.png)  

	`service mysqld start`.  
	
	* Tots dos han de tenir la mateixa mida inicial (5MB)  
	
	Amb `innodb_data_file_path = ibdata1:5M;ibdata2:5M:autoextend` al `/etc/my.cnf` li podem dir la mida inicial.  
	
	* El tablespace ha de creixer de 1MB en 1MB.  
	
	Amb `innodb_autoextend_increment = 1M `el tablespace creixerà de 1MB en 1MB.  
	
	Ens ha creat els dos fitxers `ibdata`.  
	![screenshot_ex3-2-3](./imgs/Act2_ex3-2-p3.png)  
	
	* Situa aquests fitxers (de manera relativa a la localització per defecte) en una nova localització simulant el següent:  
		* /discs-mysql/disk1/primer fitxer de dades → simularà un disc dur.   
		* /discs-mysql/disk2/segon fitxer de dades → simularà un segon disc dur.  

	Primer creem els dos fitxers, afegint-li els mateixos permisos que té el mysql i dient-li que mysql sigui el propietari.  
	![screenshot_ex3-5-1](./imgs/Act2_ex3-5-p1.png)  
	
	![screenshot_ex3-5-2](./imgs/Act2_ex3-5-p2.png)  
	
	Abans de canviar res, aturem el servei `service mysqld stop`.  
	Eliminem els ibdata que tenim `rm -rf /discs-mysql/ib*`.  
	Entrem a l'arxiu `/etc/my.cnf` i afegim el directoris disk1 i disk2.  
	![screenshot_ex3-5-3](./imgs/Act2_ex3-5-p3.png)  
	
	Tornem a engegar el servei `service mysqld start`.  
	Comprovem que els fitxers ibdata estiguin al directori que hem assignat.  
	![screenshot_ex3-5-4](./imgs/Act2_ex3-5-p4.png)  
	
4.	**Checkpoint:** Mostra al professor els canvis realitzats i que la BD continua funcionant.  


## Activitat 3. INNODB part II. REALITZA ELS SEGÜENTS APARTATS. ##

1.	Partint de l'esquema anterior configura el Percona Server perquè cada taula generi el seu propi tablespace en una carpeta anomenada ***tspaces*** *(aquesta pot estar situada a on vulgueu)*.  
	1.	Indica quins són els canvis de configuració que has realitzat.  
	[Documentació MYSQL Innodb_file_per_table](https://dev.mysql.com/doc/refman/5.5/en/innodb-multiple-tablespaces.html)  
	
	El paràmetre `innodb_file_per_table` ha d'estar activat per generar tablespaces `.ibd`.  
	![screenshot_ex3-1](./imgs/Act3_ex1-p1.png)  
	
	Fem un `service mysqld stop`.  
	
	Creem el nou directori i li otorguem permissos.  
	![screenshot_ex3-2](./imgs/Act3_ex1-p2.png)  
	![screenshot_ex3-3](./imgs/Act3_ex1-p3.png)  
	
	Editem el fitxer `/etc/my.cnf` i canviem el `data_dir` per el nou directori `/tspaces`. També comentem el que hem fet en l’anterior exercici.  
	![screenshot_ex3-4](./imgs/Act3_ex1-p4.png)  
	
	Copiem els fitxers al nou directori `cp -R -p /var/lib/mysql/* /tspaces`.  
	Afegim la seguretat SELinux al nou directori abans de engenar de nou el mysql.  
	`semanage fcontext -a -t mysqld_db_t "/tspaces(/.*)?"`.  
	`restorecon -R /tspaces`.  
	
	Engeguem el servei amb un `service mysqld start`.  
	Mirem si el directori ha canviat entrant al MYSQL i fent un `SELECT @@datadir;`  
	![screenshot_ex3-5](./imgs/Act3_ex1-p5.png)  	


	2.	Després del canvi què ha passat amb els fitxers que contenien les dades de la BD de Sakila? Fes les captures necesàries per complementar la resposta.  
	
	Els fitxers han canviat de directori, ara es generaran a `/tspaces`.  
	

## Activitat 4. INNODB part III. REALITZA ELS SEGÜENTS APARTATS. ##

1.	Crea un tablespace anomenat **'ts1'** situat a `/discs-mysql/disk1/` i col·loca les taules *actor*, *address* i *category* de la BD Sakila.  

Abans de tot, perque funcioni bé desfem el que haviem fet a l’activitat 3.  
![screenshot_ex4-1-1](./imgs/Act4_ex1-p1.png)  
I fem un `service mysqld restart` per aplicar els canvis.  

Ens posicionem a la base de dades sakila:  
`use sakila;`  

Creem el tablespace a `/discs-mysql/disk1`.  
`CREATE TABLESPACE ts1 ADD DATAFILE '/discs-mysql/disk1/ts1.ibd' ENGINE=InnoDB;`  
![screenshot_ex4-1-2](./imgs/Act4_ex1-p2.png)  

Amb les sentencies `ALTER TABLE` afegim les taules que ens demana:  

`ALTER TABLE actor TABLESPACE ts1;`  
`ALTER TABLE address TABLESPACE ts1;`  
`ALTER TABLE category TABLESPACE ts1;`  

![screenshot_ex4-1-3](./imgs/Act4_ex1-p3.png)  

2.	Crea un altre tablespace anomenat **'ts2'** situat a `/discs-mysql/disk2/` i col·loca-hi la resta de taules.  

Creem el tablespace a `/discs-mysql/disk2`.  
`CREATE TABLESPACE ts2 ADD DATAFILE '/discs-mysql/disk2/ts2.ibd' ENGINE=InnoDB;`  
![screenshot_ex4-2-1](./imgs/Act4_ex2-p1.png)  

Amb les sentencies `ALTER TABLE` afegim les taules que ens demana:  

`ALTER TABLE city TABLESPACE ts2;`  
`ALTER TABLE country TABLESPACE ts2;`  
`ALTER TABLE customer TABLESPACE ts2;`  
![screenshot_ex4-2-2](./imgs/Act4_ex2-p2.png)  

`ALTER TABLE film TABLESPACE ts2;`  
`ALTER TABLE film_actor TABLESPACE ts2;`  
`ALTER TABLE film_category TABLESPACE ts2;`  
`ALTER TABLE film_text TABLESPACE ts2;`  
`ALTER TABLE inventory TABLESPACE ts2;`  
![screenshot_ex4-2-3](./imgs/Act4_ex2-p3.png)  

`ALTER TABLE language TABLESPACE ts2;`  
![screenshot_ex4-2-4](./imgs/Act4_ex2-p4.png)  

`ALTER TABLE payment TABLESPACE ts2;`  
`ALTER TABLE rental TABLESPACE ts2;`  
![screenshot_ex4-2-5](./imgs/Act4_ex2-p5.png)  

`ALTER TABLE staff TABLESPACE ts2;`  
![screenshot_ex4-2-6](./imgs/Act4_ex2-p6.png)  

`ALTER TABLE store TABLESPACE ts2;`  
![screenshot_ex4-2-7](./imgs/Act4_ex2-p7.png)  

3.	Comprova que pots realitzar operacions DML a les taules dels dos tablespaces.  

Intentem fer operacions `DML` a les taules del tablesapace.  

Al tablespace `ts1`:  
`INSERT INTO actor(first_name, last_name)  
VALUES("patricia","lopez");`  
![screenshot_ex4-3-1](./imgs/Act4_ex3-p1.png)  

Al tablespace `ts2`:  
`INSERT INTO language(name) VALUES("ca");`  
![screenshot_ex4-3-2](./imgs/Act4_ex3-p2.png)  

4.	Quines comandes i configuracions has realitzat per fer els dos apartats anteriors?  

Hem utilitzat les comandes `CREATE TABLESPACE I ALTER TABLE` per crear 2 tablespaces, un a `/discs-mysql/disk1` i l’altre a `/discs-mysql/disk2`. Amb les diferents sentències `ALTER TABLE` hem pogut afegir algunes taules als tablespaces.  
Per intentar fer operaciones `DML`, hem utilitazat la sentència `INSERT INTO` per afegir dades a una taula.  

5.	**Checkpoint:** Mostra al professor els canvis realitzats i que la BD continua funcionant  

## Activitat 5. REDOLOG. REALITZA ELS SEGÜENTS APARTATS. ##

1.	Com podem comprovar (Innodb Log Checkpointing):  

	[Documentació REDOLOG](https://www.percona.com/blog/2012/02/17/the-relationship-between-innodb-log-checkpointing-and-dirty-buffer-pool-pages/)  
	
	Utilitzem la comanda `SHOW ENGINES INNODB STATUS\G;` i busquem la secció `LOG`.  
	![screenshot_ex5-1](./imgs/Act5_ex1-p1.png)  

	* LSN (Log Sequence Number)  
	
	El LSN és el log sequence number, el número 1216054.   
		
	* L'últim LSN actualitzat a disc  
	
	L’últim LSN actualitzat a disk és el 1216054.  
			
	* Quin és l'últim LSN que se li ha fet Checkpoint  
	
	L’últim LSN que se li ha fet checkpoint és el 1216054.
	 
3.	Com podem mirar el número de pàgines modificades (dirty pages)? I el número total de pàgines?  

	Utilitzem la comanda `SHOW ENGINES INNODB STATUS\G;` i busquem la secció `BUFFER POOL AND MEMORY`.  
	![screenshot_ex5-1](./imgs/Act5_ex3-p1.png)  
	
	El número de pàgines modificades ens ho dona el paràmetre `Modified db pages`, que en aquest cas en tenim 0.  
	Per veure el total de les pàgines que en tenim, el paràmetre `Databses pages` ens diu 157.  
	
4.	**Checkpoint:** Mostra al professor els canvis realitzats i que la BD continua funcionant.  

## Activitat 6. Implementar BD Distribuïdes.  ##

Com s'ha vist a classe MySQL proporciona el motor d'emmagatzemament FEDERATED que té com a funció permetre l'accés remot a bases de dades MySQL en un servidor local sense utilitzar tècniques de replicació ni clustering.  
  
![screenshot_ex6](./imgs/Act1_ex6.png)  

[Documentació FEDERATED Storage Engine](https://dev.mysql.com/doc/refman/5.7/en/federated-storage-engine.html)  
[Documentació MYSQL CREATE TABLE FEDERATED](https://dev.mysql.com/doc/refman/5.7/en/federated-create-server.html)  
  
1.	Prepara un Servidor Percona Server amb la BD de Sakila  
  
```
mysql -u root -ppatata
source ./sakila-schema.sql
```
![screenshot_ex6-1](./imgs/Act1_ex6-p1.png)  
  
2.	Prepara un segon servidor Percona Server a on hi hauran un conjunt de taules FEDERADES al primer servidor.  

![screenshot_ex6-2](./imgs/Act1_ex6-p2.png)  

3.	Per realitzar aquest link entre les dues BD podem fer-ho de dues maneres:  

Abans de tot, permitim al firewall el port 3306/tcp, on podem trobar informació a [Documentació Instal·lació CENTOS](https://devops.profitbricks.com/tutorials/install-mysql-on-centos-7/#firewall-rules) en la secció Firewall Rules.  

Creem un usuari al servidor 1 i li atorguem tots els privilegis:  
![screenshot_ex6-3](./imgs/Act1_ex6-p3.png)  

Deshabilitem la seguretat SELinux:  
![screenshot_ex6-3](./imgs/Act1_ex6-p3.png)  

1.	Opció1: especificar TOTA la cadena de connexió a CONNECTION  
	
Creem un link especificant tota la cadena de connexió a CONNECTION.  
	
Creem una taula federada en el servidor 2:
	
![screenshot_ex6-4](./imgs/Act1_ex6-p4.png)  
La ip correspon a la del servidor 1.  

2.	Opció2: especificar una connexió a un server a CONNECTION que prèviament s'ha creat mitjançant CREATE SERVER  

`CREATE SERVER primer  
FOREIGN DATA WRAPPER mysql  
OPTIONS (USER 'perepe', HOST '192.168.1.141', PORT 3306, DATABASE 'sakila');`

3.	Posa un exemple de 2 taules de cada opció.  
Tingues en compte els permisos a nivell de BD i de SO així com temes de seguretat com firewalls, etc...  

Exemple opció 1:  

Si inserim dades en el servidor 1 a la taula category:  
![screenshot_ex6-5](./imgs/Act1_ex6-p5.png)  

Com que en el servidor 2 hem creat una taula federada, hauria d’agafar les mateixes dades:  
![screenshot_ex6-6](./imgs/Act1_ex6-p6.png)   
Això és pot ser per un problema de permissos, en cara que hem fet totes les possibles solucions.  

Exemple opció 2:  
Creem una taula al servidor 2:  

`CREATE TABLE language (  
language_id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,  
name CHAR(20) NOT NULL,  
last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,  
PRIMARY KEY (language_id)  
)  
ENGINE=FEDERATED  
CONNECTION='primer/language';`  

El paràmetre `CONNECTION`correspón al nom que rep el `SERVER` que hem creat més la taula.

Hauriem de fer un `INSERT` a aquesta taula de servidor 2, i si ens anéssim al servidor 1, hauriem de poder veure aquest `insert` amb un `select`.  

4.	Detalla quines són els passos i comandes que has hagut de realitzar en cada màquina.  
	
Als dos servidors he hagut de permetre el port per no tenir-ne problemes amb el firewall. A més al servidor 1 hem creat un usuari amb tots els privilegis i hem desabilitat la seguretat SELinux.  

Per crear les taules federades hem hagut d'especificar al paràmetre `ENGINE` que es tratava d'una taula federada. A més, al paràmetre `CONNECTION` l'hem especificat de dues maneres:  
* La primera especificant una cadena de connexió: `CONNECTION='mysql://root:patata@192.168.1.41:3306/sakila/category';`  
* La segona especificant una connexió a un server a `CONNECTION` que prèviament s'ha creat mitjançant `CREATE SERVER`:  
`(USER 'perepe', HOST '192.168.1.141', PORT 3306, DATABASE 'sakila')` (per establir la connexió en el `CREATE SERVER`)  
`CONNECTION='primer/language';` (en la sentència `CREATE TABLE` hem afegit la connexió del `CREATE SERVER` i la taula federada.  

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
