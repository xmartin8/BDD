**Sara Caparrós Torres i Patricia López López (ASIX 2 - Curs 2017/18)**  
# ACTIVITAT REPLICACIÓ #

## REPLICACIÓ via Binlog (3 punts)
**MASTER fons negre; SLAVE fons blanc!**  
Es vol muntar entorn SGBD MySQL Percona amb rèplica. Es vol tenir un MySQL master a on s'aniran enviant totes les instruccions SQL d'inserció, modificació i esborrat. Es vol tenir un MySQL  esclau del master anteriorment esmentat.  
Cal que que al realitzar un INSERT en el master veiem les dades a l'esclau al cap d'un instant de temps.

### CONFIGURACIÓ MASTER

* Realitza una còpia del fitxer de configuració del MySQL /etc/my.conf → /etc/my.conf.bkp  
Fem la cópia del fitxer `/ect/my.cnf`.  
![Screenshot part1-1][1]  
![Screenshot part1-2][2]  
* Modifica el fitxer `/etc/my.conf` i activa el paràmetre `log-bin` (tal i com vàreu fer a M02).  
    * Amb el nom: `<PRIMER LLETRA DEL NOM + 1r COGNOM>rep`  
    * Exemple: `log-bin=rventurarep`  
![Screenshot part1-3][3]  
El nom correspón a la primera lletra del nom més dues lletres del cognom.  
* Verifica que el paràmetre `server-id` té un valor numèric (per defecte és 1).  
Verifiquem el paràmetre `server-id`.  
![Screenshot part1-4][4]  
* Verifica que tots els paràmetres de InnoDB estiguin descomentats  
* Canvia el paràmetre `innodb_log_buffer` a `10M`  
![Screenshot part1-5][5]  
![Screenshot part1-6][6]  
* Canvia o afegeix el paràmetre `innodb_log_files_in_group` a `2`  
![Screenshot part1-7][7]  
![Screenshot part1-8][8]  
* Para el servei de MySQL  
`service mysqld stop`.  
* Borra tots ***els fitxers de log*** InnoDB del directory `/var/lib/mysql`  
![Screenshot part1-9][9]  
* Engega el servei de MySQL.  
`service mysqld start`.  
* Quants fitxers comencen amb el nom `<PRIMER LLETRA DEL NOM + 1r COGNOM>` rep dins el directori `/var/lib/mysql`? Digues quins són  
![Screenshot part1-10][10]  
Tenim 6 fitxers:  
Els *scaplorep.000001-5* i *scaplorep.index*.  
* Realitza un instrucció DML, per exemple INSERT,UPDATE o DELETE  
![Screenshot part1-11][11]  
* Obre un altre terminal i utilitzant l'eina **mysqlbinlog** mira el contingut del fitxer `<PRIMER LLETRA DEL NOM + 1r COGNOM>rep.000001`  
    `mysqlbinlog <PRIMER LLETRA DEL NOM + 1r COGNOM>rep.000001`  
    * Quin és el seu contingut?  
![Screenshot part1-12][12]  
És un fitxer binlog on podem veure quan ha iniciat sessió.  
* Fes un FLUSH DELS LOGS utilitzant la comanda **FLUSH LOGS** dins del MySQL  
    `mysql> FLUSH LOGS;`  
![Screenshot part1-13][13]  
* Realitza una comprovació dels logs com a master mitjançant **SHOW MASTER LOGS**  
    `mysql> SHOW MASTER LOGS;`  
![Screenshot part1-14][14]  
S'ha creat un altre log, el *scaplorep.000006*.  



### CONFIGURACIÓ SLAVE i MASTER

* Realitza una còpia de la màquina virtual a on tinguis SGBD MySQL. Aquesta nova màquina serà que farà d'eslau.  
* Esbrina quina IP tenen cadascuna de les màquines (master, slave).  

| Server | IP | Color Terminal |  
| :---------- | :----------: | :----------: |  
| Master   | 10.92.254.44  | Negro  |  
| Slave   | 10.92.254.129  | Blanco  |  

* Crea un backup de la BD a la màquina master utilitzant:  
    `$> mysqldump –u root –p -–master-data=2 sakila > /tmp/master_backup.sql`  
[Documentació Backups](http://librosweb.es/tutorial/como-hacer-copias-de-seguridad-de-una-base-de-datos-mysql/)  
![Screenshot part1-15][15]  
![Screenshot part1-16][16]  
* Edita el fitxer master_backup.sql i busca la línia que comenci per --CHANGE MASTER TO.... i busca els valors MASTER_LOG_FILE i MASTER_LOG_POS.  
![Screenshot part1-17][17]  
* **SLAVE**  
    * Para el servei de MySQL.  
    ![Screenshot part1-18][18]  
    * Modifica el fitxer de configuració /etc/my.conf  
        * Comenta els paràmetres log-bin i binlog_format. D'aquesta manera desactivarem el sistema de log-bin.  
        * Assigna un valor al paràmetre  server-id (diferent que el del Master)  
        ![Screenshot part1-19][19]  
        * Torna engegar el servei MySQL. 
        ![Screenshot part1-20][20]  
* **MASTER**  
    * Afegeix l'usuari slave amb la IP de la màquina slave  
        ```
        mysql> CREATE USER 'slave'@'IP-SERVIDOR-SLAVE'  
        -> IDENTIFIED BY 'patata';  
        ```
    ![Screenshot part1-22][22]  
    * Afegix el permís de REPLICATION SLAVE a l'usuari que acabes de crear.  
        ```
        mysql> GRANT REPLICATION SLAVE ON *.*  
        -> TO 'slave'@'IP-SERVIDOR-SLAVE';  
        mysql> FLUSH PRIVILEGES;  
        ```
     ![Screenshot part1-23][23]  
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
![Screenshot part1-21][21]  

Si des del master fem un **insert** a una taula, al slave haurà de sortir:  
![Screenshot part1-24][24]  
En el slave sortirà també aquest insert:  
![Screenshot part1-25][25]  
![Screenshot part1-26][26]  


## REPLICACIÓ via GTID (4 punts)
Es vol muntar un entorn SGBD MySQL Percona amb rèplica similar a l’anterior, però aquesta vegada es vol realitzar mitjançant GTID.  
Un cop la rèplica funciona, Mostra l’exemple del contingut del fitxer binary log.  
[Documentació GTID](https://dev.mysql.com/doc/refman/5.6/en/replication-gtids-howto.html)  
[Documentació2 GTID](https://dev.mysql.com/doc/refman/5.7/en/replication-mode-change-online-enable-gtids.html)  
Fer que els servidor només siguin de lectura. `SET @@global.read_only = ON;`  
![Screenshot part2-1][30]  
![Screenshot part2-2][31]  
Aturar els dos servidors amb mysqladmin. `mysqladmin -uroot -p shutdown`  
![Screenshot part2-3][32]  
![Screenshot part2-4][33]  
Modifiquem el fitxer `/etc/my.cnf` i afegim això al fitxer:  
```
gtid-mode=ON
enforce-gtid-consistency = true
```
![Screenshot part2-5][34]  
![Screenshot part2-6][35]  
Reiniciem els serveis dels dos servidors.  

**SLAVE:**
![Screenshot part2-7][36]  
![Screenshot part2-8][37]  
En els dos servidors s’ha de fer:  
![Screenshot part2-9][38]  

Si dona molts problemes, desactivar el firewall:  
`service firewalld stop;`  


## PUNTS OPCIONALS (màx. 6 punts)
* Entorn amb replicació semisíncrona amb master passiu (3 punts)  
* Entorn amb múltiples orígens (2 punts)  
* Topologia de Slave Relay via BlackHole (2 punts)  
* Instal·la i explica com funciona alguna d’aquestes eines (Percona Toolkit) (2 punts, 1 punt per eina):  
    * [pt-table-checksum](https://www.percona.com/doc/percona-toolkit/2.1/pt-table-checksum.html)  
    * [pt-table-sync](https://www.percona.com/doc/percona-toolkit/2.1/pt-table-sync.html)  

## Respon a les següents preguntes en el cas de Binlog i GTID:
* Si iniciem una transacció en el master a on hi ha una sèrie d’operacions DML (INSERT, UPDATE o DELETE) . Aquestes es guarden en el binlog?  
   Si.  
* Comprova mitjançant SHOW SLAVE STATUS, quins valors et dóna?  

[Documentació SHOW SLAVE STATUS](https://dev.mysql.com/doc/refman/5.7/en/show-slave-status.html)  
![Screenshot part1-27a][27a]  
![Screenshot part1-27b][27b]  

**Slave_IO_State:** Indica l’estat del slave.  
**Master_Host:** el master anfitrió el qual s’està connectant el slave.  
**Master_user:** El nom d'usuari del compte utilitzat per connectar-se al master.  
**Master_Port:** EL port utilitzat per connectar-se al master.  
**Connect_Retry:** EL número de connexions que el slave intenta connectar-se al master.  
**Master_Log_File:** El nom del fitxer binari del master que està llegint el slave.  
**Read_Master_Log_Pos:** La posició del fitxer binari del master.  
**Relay_Log_File:** El nom del fitxer de registre del relé des del qual la seqüència de SQL està llegint i executant actualment.  
**Relay_Log_Pos:** La posició en el fitxer de registre de relleu actual fins al qual la seqüència de SQL s'ha llegit i executat.  
**Relay_Master_Log_File:** El nom del fitxer binari master que conté l'esdeveniment més recent executat per la cadena SQL.  
**Slave_IO_Running:** Indica si s’ha connectat correctament al master.  
**Slave_SQL_Running:** Si s'inicia la cadena SQL.  
**Last_Errno:** Mostra si hi ha hagut algun errror.  
**Skip_Counter:** El valor actual de la variable del sistema `sql_slave_skip_counter`.   
**Exec_Master_Log_Pos:** La posició en el fitxer binari master actual al qual s'ha llegit i executat el fil SQL, marcant l'inici de la propera transacció o esdeveniment que es processarà.  
**Relay_Log_Space:** La mida total combinada de tots els fitxers de registre relleus existents.  
**Until_Log_Pos:** L’última posició en el fitxer binari master que el slave llegirà.  
**Master_SSL_Allowed:** Defineix si es pot una connexió SSL al master.  
**Seconds_Behind_Master:** Mostra si hi ha algun esdeveniment que s’està processant actualment al slave.  
**Master_SSL_Verify_Server_Cert:** Defineix si es pot una connexió SSL al master.  
**Last_SQL_Errno:** El número d'error i el missatge d'error de l'error més recent que va provocar que el fil de SQL s'aturés.   
**Master_Server_Id:** El valor del paràmetre `server_id` del master.  
**Master_UUID:** El valor del paràmetre `server_uuid` del master.  
**Master_Info_File:** La localització del fitxer `master.info`.  
**SQL_Delay:** El nombre de segons que el slave ha de retardar el master.  
**SQL_Remaining_Delay:** Quan `Slave_SQL_Running_State` està esperant fins a `MASTER_DELAY` segons després de l'esdeveniment executat principal, aquest camp conté el nombre de segments de retard que queden.  
**Slave_SQL_Running_State:** L'estat del fil de SQL.  
**Master_Retry_Count:** El nombre de vegades que el slave pot intentar tornar a connectar amb el master en cas d'una connexió perduda.   
**Auto_Position:** 1 si s'utilitza l'autoposicionament; en cas contrari 0.  

* Quin significat té l’opció `MASTER_CONNECT_RETRY` en la comanda `CHANGE MASTER TO`?  

[Documentació variables de replicació](https://dev.mysql.com/doc/refman/5.7/en/replication-options-slave.html)  
Es tracta del número de vegades que el slave intenta conectar-se al master abans de donar-se per vençut. S’intentarà connectar de nou segons l’interval establert al paràmetre. El valor predeterminat és 86400. El valor 0 significa infinit, el slave s’intentarà connectar sempre.  

* Què fa la comanda `RESET MASTER` en el cas de no utilitzar GTID i utilitzar-lo?  

[Documentació RESET MASTER](https://dev.mysql.com/doc/refman/5.7/en/reset-master.html)  
Elimina tots els fitxers binaris que estan dintre del fitxer index, deixa el fitxer index buit i en crea un de nou.  

* Mira’t alguna de les taules (`SHOW TABLES LIKE 'repl%'`) del `PERFORMANCE_SCHEMA`;    

![Screenshot part1-28][28]  
![Screenshot part1-29][29] 

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
[28]: imgs/1-28.png
[29]: imgs/1-29.png
[30]: imgs/2-1.png
[31]: imgs/2-2.png
[32]: imgs/2-3.png
[33]: imgs/2-4.png
[34]: imgs/2-5.png
[35]: imgs/2-6.png
[36]: imgs/2-7.png
[37]: imgs/2-8.png
[38]: imgs/2-9.png