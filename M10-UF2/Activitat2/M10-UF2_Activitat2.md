# Sara Caparrós Torres i Patricia López López (ASIX 2 - Curs 2017/18) #
# CONFIGURACIÓ SGBD

## ENUNCIAT ##

Partint del SGBD Percona Server instal·lat en l'activitat anterior realitza aquests canvis en el fitxer de configuració.


## REALITZA LES SEGÜENTS TASQUES DE CONFIGURACIÓ i COMPROVACIÓ DE LOGS (6 punts) ##

1.	Crea un fitxer de configuració a on:
*	Canvia el port per defecte de connexió al 3011.
*	Quins són els logs activats per defecte? Com ho has fet per comprovar-ho?
*	Activa si no ho estan i indica les configuracions necessàries per activar-los. Indica les rutes dels fitxer de log de Binary, Slow Query i General. Quins paràmetres has modificat?

2.	Comprova l'estat de les opcions de log que has utilitzat mitjançant una sessió de mysql client.
Exemple: (`mysql> SHOW GLOBAL VARIABLES LIKE '%log'`)

3.	Modifica el fitxer de configuració i desactiva els logs de binary, slow query i genral. Nota: Simplament desactiva'ls no borris altres paràmetres com la ruta dels fitxers, etc...

4.	Activa la els logs en temps d'execució mitjançant la sentència SET GLOBAL. També canvia el destí de log general a una taula (paràmetre log_output). Quines són les sentències que has utilitzat? A quina taula registres els logs general?

5.	Carrega la BD Sakila localitzada a la web de
    1.	Descarrega't el fitxer sakila-schema.sql del Moodle.
    2.	carrega la BD dins del MySQL utilitzant la sentència:
    `mysql> SOURCE <ruta_fitxer>/sakila-schema.sql;`

6.	Compte el numero de sentències CREATE TABLE dins del general log mitjançant:
		mysql> SELECT COUNT(*)
				FROM mysql.general_log
			  WHERE argument LIKE 'CREATE TABLE%';

7.	 Executa una query mitjançant la funció SLEEP(11) per tal de que es guardi en el log de Slow Query. Mostra el contingut del log demostrant-ho.

8.	Assegura't que el Binary Log estigui activat i borra tots els logs anteriors mitjançant la sentència RESET MASTER.
*	Crea i borra una base de dades anomenada foo. Utilitza la sentències:
        `mysql> CREATE DATABASE foo;`
		`mysql> DROP DATABASE foo;`

*	Mitjançant la sentència SHOW BINLOG EVENTS llista els events i comprova les sentències anteriors en quin fitxer de log estan.

*	Realitza un Rotate log mitjançant la sentència FLUSH LOGS

*	Crea i borra una altra base de dades com l'exemple anteior del foo. Però en aquest cas anomena la base de dades bar

*	Llista tots els fitxers de log i els últims canvis mitjançant la sentència SHOW. Quina sentència has utilitzat? Mostra'n el resultat.

*	Borra el primer binary log. Quina sentència has utilitzat?

*	Utilitza el programa mysqlbinlog per mostrar el fitxer mysql-bin.000002
-	Quin és el seu contingut?
-	Quin número d'event ha sigut el de la creació de la base de dades bar?

## CONFIGURACIÓ DEL SERVIDOR PERCONA SERVER PER REALITZAR CONNEXIONS SEGURES SOBRE SSL. (3 punts) ##