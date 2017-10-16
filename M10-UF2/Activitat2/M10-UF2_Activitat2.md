#### Sara Caparrós Torres i Patricia López López (ASIX 2 - Curs 2017/18) ####
# CONFIGURACIÓ SGBD

## ENUNCIAT ##

Partint del SGBD Percona Server instal·lat en l'activitat anterior realitza aquests canvis en el fitxer de configuració.  


## REALITZA LES SEGÜENTS TASQUES DE CONFIGURACIÓ i COMPROVACIÓ DE LOGS ##

1.	Crea un fitxer de configuració a on:  
    *	Canvia el port per defecte de connexió al 3011.  
    ![screenshot_ex1-1](./imgs/Act2_ex1-1.png)  
    *	Quins són els logs activats per defecte? Com ho has fet per comprovar-ho?  
    ![screenshot_ex1-2](./imgs/Act2_ex1-2.png)  
    *	Activa si no ho estan i indica les configuracions necessàries per activar-los. Indica les rutes dels fitxers de log de Binary, Slow Query i General. Quins paràmetres has modificat?  
    ![screenshot_ex1-3](./imgs/Act2_ex1-3.png)  

2.	Comprova l'estat de les opcions de log que has utilitzat mitjançant una sessió de mysql client.  
        Exemple: (`mysql> SHOW GLOBAL VARIABLES LIKE '%log'`)  

3.	Modifica el fitxer de configuració i desactiva els logs de binary, slow query i genral. **Nota:** Simplement desactiva'ls no esborris altres paràmetres com la ruta dels fitxers, etc...  

4.	Activa els logs en temps d'execució mitjançant la sentència SET GLOBAL. També canvia el destí de log general a una taula (paràmetre `log_output`). Quines són les sentències que has utilitzat? A quina taula registres els logs general?  

5.	Carrega la BD Sakila localitzada a la web de  
    1.	Descarrega't el fitxer sakila-schema.sql del Moodle.  
    2.	Carrega la BD dins del MySQL utilitzant la sentència:  
    `mysql> SOURCE <ruta_fitxer>/sakila-schema.sql;`  

6.	Compte el número de sentències CREATE TABLE dins del general log mitjançant:  
		`mysql> SELECT COUNT(*)`  
				`FROM mysql.general_log`  
			  `WHERE argument LIKE 'CREATE TABLE%';`  

7.	 Executa una query mitjançant la funció SLEEP(11) per tal que es guardi en el log de Slow Query. Mostra el contingut del log demostrant-ho.  

8.	Assegura't que el *Binary Log* estigui activat i borra tots els logs anteriors mitjançant la sentència RESET MASTER.  
*	Crea i borra una base de dades anomenada foo. Utilitza les sentències:  
        `mysql> CREATE DATABASE foo;`  
		`mysql> DROP DATABASE foo;`  

*	Mitjançant la sentència `SHOW BINLOG EVENTS` llista els esdeveniments i comprova les sentències anteriors en quin fitxer de log estan.  

*	Realitza un Rotate log mitjançant la sentència `FLUSH LOGS`  

*	Crea i borra una altra base de dades com l'exemple anterior del `foo`. Però en aquest cas anomena la base de dades `bar`  

*	Llista tots els fitxers de log i els últims canvis mitjançant la sentència SHOW. Quina sentència has utilitzat? Mostra'n el resultat.  

*	Borra el primer binary log. Quina sentència has utilitzat?  

*	Utilitza el programa `mysqlbinlog` per mostrar el fitxer *mysql-bin.000002*  
    *	Quin és el seu contingut?  
    *	Quin número d'esdeveniment ha sigut el de la creació de la base de dades bar?  

## CONFIGURACIÓ DEL SERVIDOR PERCONA SERVER PER REALITZAR CONNEXIONS SEGURES SOBRE SSL. ##  
Primer de tot hem de crear els certificats i les claus SSL.  
A continuació estan totes les comandes i seguidament estan les captures de pantalla amb les comprovacions.  
  
Comandes:  
```
\# Creem un entorn net  
rm -rf newcerts  
mkdir newcerts && cd newcerts  
  
\# Creem el certificat CA  
openssl genrsa 2048 > ca-key.pem  
openssl req -new -x509 -nodes -days 3600 \  
        -key ca-key.pem -out ca.pem  

\# Creem els certificats del server, esborrem la frase de pas (contrasenya) i iniciem sessió  
\# server-cert.pem = public key, server-key.pem = private key  
openssl req -newkey rsa:2048 -days 3600 \  
        -nodes -keyout server-key.pem -out server-req.pem  
openssl rsa -in server-key.pem -out server-key.pem  
openssl x509 -req -in server-req.pem -days 3600 \  
        -CA ca.pem -CAkey ca-key.pem -set_serial 01 -out server-cert.pem  
  
\# Creem els certificats del client, esborrem la frase de pas (contrasenya) i iniciem sessió  
\# client-cert.pem = public key, client-key.pem = private key  
openssl req -newkey rsa:2048 -days 3600 \  
        -nodes -keyout client-key.pem -out client-req.pem  
openssl rsa -in client-key.pem -out client-key.pem  
openssl x509 -req -in client-req.pem -days 3600 \  
        -CA ca.pem -CAkey ca-key.pem -set_serial 01 -out client-cert.pem  
```
  
Després de generar els certificats, els verifiquem:  
`openssl verify -CAfile ca.pem server-cert.pem client-cert.pem`  
  
Captures de pantalla:  
![screenshot_P2-1](./imgs/Act2_P2-1.png)  
![screenshot_P2-2](./imgs/Act2_P2-2.png)  
![screenshot_P2-3](./imgs/Act2_P2-3.png)  
![screenshot_P2-4](./imgs/Act2_P2-4.png)  

Seguidament configurem el server. Començem editant el fitxer /etc/my.cnf afegint:  
```
[mysqld]  
ssl-ca=ca.pem  
ssl-cert=server-cert.pem  
ssl-key=server-key.pem  
```
![screenshot_P2-5](./imgs/Act2_P2-5.png)  
Creem un usuari el SSL estigui requerit:  
![screenshot_P2-6](./imgs/Act2_P2-6.png)  
*usuari: ssluser  *
*pass: P@ssw0rd  *
  
Per iniciar sessió amb l’usuari que te el SSL requerit (iniciem sessió com sempre, però afegim al final: --ssl-mode=REQUIRED ), sinó et diu que té l’accés denegat.  
![screenshot_P2-7](./imgs/Act2_P2-7.png)  
Per comprovar que funciona el xifrat, podem fer:  
    * `\s` (com en aquesta captura)
    ![screenshot_P2-8](./imgs/Act2_P2-8.png)  
    * `STATUS`  
    ![screenshot_P2-9](./imgs/Act2_P2-9.png)  
    * `SHOW SESSION STATUS LIKE 'Ssl_cipher';`  
    ![screenshot_P2-10](./imgs/Act2_P2-10.png)  