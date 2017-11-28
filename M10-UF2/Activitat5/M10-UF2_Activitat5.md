**Sara Caparrós Torres i Patricia López López (ASIX 2 - Curs 2017/18)**  
# ACTIVITAT REPLICACIÓ #

## REPLICACIÓ via Binlog (3 punts)
**MASTER fons negre; SLAVE fons blanc!**
Es vol muntar entorn SGBD MySQL Percona amb rèplica. Es vol tenir un MySQL master a on s'aniran enviant totes les instruccions SQL d'inserció, modificació i esborrat. Es vol tenir un MySQL  esclau del master anteriorment esmentat.  
Cal que que al realitzar un INSERT en el master veiem les dades a l'esclau al cap d'un instant de temps.

### CONFIGURACIÓ MASTER

* Realitza una còpia del fitxer de configuració del MySQL /etc/my.conf → /etc/my.conf.bkp  
![Screenshot part1-1][1]  
![Screenshot part1-2][2] 
* Modifica el fitxer `/etc/my.conf` i activa el paràmetre `log-bin` (tal i com vàreu fer a M02).  
    * Amb el nom: `<PRIMER LLETRA DEL NOM + 1r COGNOM>rep`  
    * Exemple: `log-bin=rventurarep`  
* Verifica que el paràmetre `server-id` té un valor numèric (per defecte és 1).  
* Verifica que tots els paràmetres de InnoDB estiguin descomentats  
* Canvia el paràmetre `innodb_log_buffer` a `10M`  
* Canvia o afegeix el paràmetre `innodb_log_files_in_group` a `2`  
* Para el servei de MySQL  
* Borra tots ***els fitxers de log*** InnoDB del directory `/var/lib/mysql`  
* Engega el servei de MySQL.  
* Quants fitxers comencen amb el nom `<PRIMER LLETRA DEL NOM + 1r COGNOM>` rep dins el directori `/var/lib/mysql`? Digues quins són  
* Realitza un instrucció DML, per exemple INSERT,UPDATE o DELETE  
* Obre un altre terminal i utilitzant l'eina **mysqlbinlog** mira el contingut del fitxer `<PRIMER LLETRA DEL NOM + 1r COGNOM>rep.000001`  
    `mysqlbinlog <PRIMER LLETRA DEL NOM + 1r COGNOM>rep.000001`  
    * Quin és el seu contingut?  
* Fes un FLUSH DELS LOGS utilitzant la comanda **FLUSH LOGS** dins del MySQL  
    `mysql> FLUSH LOGS;`  
* Realitza una comprovació dels logs com a master mitjançant **SHOW MASTER LOGS**  
    `mysql> SHOW MASTER LOGS;`  



### CONFIGURACIÓ SLAVE i MASTER

* Realitza una còpia de la màquina virtual a on tinguis SGBD MySQL. Aquesta nova màquina serà que farà d'eslau.  
* Esbrina quina IP tenen cadascuna de les màquines (master, slave).  
* Crea un backup de la BD a la màquina master utilitzant:  
    `$> mysqldump –-user=root –-password=vostrepwd -–master-data=2 sakila > /tmp/master_backup.sql`  
* Edita el fitxer master_backup.sql i busca la línia que comenci per --CHANGE MASTER TO.... i busca els valors MASTER_LOG_FILE i MASTER_LOG_POS.  
* SLAVE  
    * Para el servei de MySQL.  
    * Modifica el fitxer de configuració /etc/my.conf  
        * Comenta els paràmetres log-bin i binlog_format. D'aquesta manera desactivarem el sistema de log-bin.  
        * Assigna un valor al paràmetre  server-id (diferent que el del Master)  
        * Torna engegar el servei MySQL.  
* MASTER  
    * Afegeix l'usuari slave amb la IP de la màquina slave  
        ```
        mysql> CREATE USER 'slave'@'IP-SERVIDOR-SLAVE'  
        -> IDENTIFIED BY 'patata';  
        ```
    * Afegix el permís de REPLICATION SLAVE a l'usuari que acabes de crear.  
        ```
        mysql> GRANT REPLICATION SLAVE ON *.*  
        -> TO 'slave'@'IP-SERVIDOR-SLAVE';  
        mysql> FLUSH PRIVILEGES;  
        ```
* A la màquina SLAVE executa la següent comanda ajudant-te de les dades del pas 3 i 4:  
    ```
    mysql> CHANGE MASTER TO  
    -> MASTER_HOST = '<ip-servidor-master>',  
    -> MASTER_USER = 'slave',  
    -> MASTER_PASSWORD = 'patata',  
    -> MASTER_PORT = '3306',  
    -> MASTER_LOG_FILE = '<PRIMER LLETRA DEL NOM + 1r COGNOM>rep.000002',  
    -> MASTER_LOG_POS = <valor trobat en el pas 4>,  
    -> MASTER_CONNECT_RETRY = 10;  
    ```

## REPLICACIÓ via GTID (4 punts)
Es vol muntar un entorn SGBD MySQL Percona amb rèplica similar a l’anterior, però aquesta vegada es vol realitzar mitjançant GTID.  
Un cop la rèplica funciona, Mostra l’exemple del contingut del fitxer binary log.  

## PUNTS OPCIONALS (màx. 6 punts)
* Entorn amb replicació semisíncrona amb master passiu (3 punts)  
* Entorn amb múltiples orígens (2 punts)  
* Topologia de Slave Relay via BlackHole (2 punts)  
* Instal·la i explica com funciona alguna d’aquestes eines (Percona Toolkit) (2 punts, 1 punt per eina):  
    * [pt-table-checksum](https://www.percona.com/doc/percona-toolkit/2.1/pt-table-checksum.html)  
    * [pt-table-sync](https://www.percona.com/doc/percona-toolkit/2.1/pt-table-sync.html)  

## Respon a les següents preguntes en el cas de Binlog i GTID:
* Si iniciem una transacció en el master a on hi ha una sèrie d’operacions DML (INSERT, UPDATE o DELETE) . Aquestes es guarden en el binlog?  
* Comprova mitjançant SHOW SLAVE STATUS, quins valors et dóna?  
* Quin significat té l’opció `MASTER_CONNECT_RETRY` en la comanda `CHANGE MASTER TO`?  
* Què fa la comanda `RESET MASTER` en el cas de no utilitzar GTID i utilitzar-lo?  
* Mira’t alguna de les taules (`SHOW TABLES LIKE 'repl%'`) del `PERFORMANCE_SCHEMA`;    


\hola
[1]: imgs/1-1.png
[2]: imgs/1-2.png
[3]: imgs/1-3.png
[4]: imgs/1-4.png
[5]: imgs/1-5.png
[6]: imgs/1-6.png
[7]: imgs/1-7.png
[8]: imgs/1-8.png
[9]: imgs/1-9.png
[10]: imgs/1-10.png
[11]: imgs/1-11.png
[12]: imgs/1-12.png
[13]: imgs/1-13.png
[14]: imgs/1-14.png
[15]: imgs/1-15.png
[16]: imgs/1-16.png
[17]: imgs/1-17.png
[18]: imgs/1-18.png
[19]: imgs/1-19.png
[20]: imgs/1-20.png
[21]: imgs/1-21.png
[22]: imgs/1-22.png
[23]: imgs/1-23.png
[24]: imgs/1-24.png
[25]: imgs/1-25.png
[26]: imgs/1-26.png
[27a]: imgs/1-27a.png
[27b]: imgs/1-27b.png