#### Sara Caparrós Torres i Patricia López López (ASIX 2 - Curs 2017/18) ####
# **Part I - INSTAL·LACIÓ SGBD MySQL Percona** #
![Percona Server for MySql](https://www.percona.com/sites/default/files/ps-logo.png)

## ENUNCIAT ##
Partint d'una màquina CentOS 7 minimal proporcionada pel professor realitza la instal·lació d'un SGBD Percona Server mitjançant el gestor de paquets YUM.

## ENLLAÇOS ##
**Percona Server 5.7 Doc**
<http://www.percona.com/doc/percona-server/5.7>

**Instal·lació Percona Server 5.7via YUM Repository**  
<http://www.percona.com/doc/percona-server/5.7/installation/yum_repo.html>

**Instal·lació MySQL via YUM Repository**
<http://www.tecmint.com/install-latest-mysql-on-rhel-centos-and-fedora/>

## **Documentació per la instal·lació** ##
Iniciem sessió:
![screenshot1](./imgs/Act1-screenshot1.PNG)  

Per instal·lar el repositori de Percona s'ha de posar:  
`yum install http://www.percona.com/downloads/percona-release/redhat/0.1-4/percona-release-0.1-4.noarch.rpm`  
![screenshot2](./imgs/Act1-screenshot2.PNG)  

Per veure si els repositoris estan disponibles fem:  
`yum list | grep percona`  
![screenshot3](./imgs/Act1-screenshot3.PNG)  

Per instal·lar el servidor fem:  
`yum install Percona-Server-server-57`  
![screenshot4](./imgs/Act1-screenshot4.PNG)  

Un cop instal·lat el servidor Percona, l'iniciem.  
`service mysql start`  

Per descarregar el repositori YUM del MySQL 5.7  
`wget http://dev.mysql.com/get/mysql57-community-release-el7-7.noarch.rpm`  
![screenshot5](./imgs/Act1-screenshot5.PNG)  

Per instal·lar el paquet hem d'escriure:  
`yum localinstall mysql57-community-release-el7-7.noarch.rpm`  
![screenshot6](./imgs/Act1-screenshot6.PNG)  

Per verificar que el repositori s'ha afegit correctament:  
`yum repolist enabled | grep "mysql.*-community.*"`  
![screenshot7](./imgs/Act1-screenshot7.PNG)  

Seguidament instal·lem l'última versió de MySQL  
`yum install mysql-community-server`  
![screenshot8](./imgs/Act1-screenshot8.PNG)  

Per començar el MySQL Server, un cop s'ha instal·lat tot  
`service mysqld start`  

Per comprovar l'estat del servidor  
`service mysqld status`  
![screenshot9](./imgs/Act1-screenshot9.PNG)  

Per acabar, verifiquem la versió del MySQL  
`mysql --version`  
![screenshot10](./imgs/Act1-screenshot10.PNG)  

Actualitzar MySQL via YUM  
`yum update mysql-server`  
![screenshot15](./imgs/Act1-screenshot15.PNG)  

Si hi ha noves actualitzacions per MySQL, s'instal·laran automàticament.  

## **Preguntes a respondre** ##
1. Un cop realitzada la instal·lació realitza una securització de la mateixa. Quin programa realitza aquesta tasca? Realitza una securització de la instal·lació indicant que la contrasenya de root sigui patata.

Abans de realitzar una securització del MySQL, Mysql 5.7 o superior generen una contrasenya aleatòria temporal quan s'instal·la  
`grep 'temporary password' /var/log/mysqld.log`  
![screenshot11](./imgs/Act1-screenshot11.PNG)  

Un cop sabem la contrasenya temporal, introduïm la comanda per fer una securització del MySQL  
`mysql_secure_installation`  
![screenshot12](./imgs/Act1-screenshot12.PNG)  
Pass: *P@ssw0rd*  
![screenshot13](./imgs/Act1-screenshot13.PNG)  

Connectar-se al servidor MySQL posant un usuari i contrasenya  
`mysql -u root -p`  
![screenshot14](./imgs/Act1-screenshot14.PNG)  

No ens deixa posar la contrasenya *patata* perquè no compleix els requisits de la política de contrasenyes, per tant l'hem de modificar.  
Entrem al mysql i posem `SHOW VARIABLES LIKE 'validate_password%';` perquè ens mostri les variables que hi han que comencen en forma de validar la contrasenya.   
![screenshot16](./imgs/Act1-screenshot16.PNG)  

A continuació modifiquem la variable de longitud amb: `SET GLOBAL validate_password_length=4;`  
![screenshot17](./imgs/Act1-screenshot17.PNG)  
I la variable de policy la canviem a *baix* amb: `SET GLOBAL validate_password_policy=LOW;`  
![screenshot18](./imgs/Act1-screenshot18.PNG)  
A continuació tornem a veure les variables en quin estat estan amb el `SHOW VARIABLES LIKE 'validate_password%';`  
![screenshot19](./imgs/Act1-screenshot19.PNG)  
Un cop realitzats aquests canvis, ja podem tornar a fer una securització per canviar la contrasenya a ***patata***
![screenshot20](./imgs/Act1-screenshot20.PNG)  
Li donem a **sí** a totes les preguntes fins que acabi.  
*El programa que realitza aquesta securització és el **mysql_secure_installation**.*


2. Quines són les instruccions per arrancar / verificar status / apagar servei de la base de dades de Percona Server.

Per arrancar el Percona Server escrivim  
`service mysql start`  
Per verificar l'estat del servidor  
`service mysql status`  
Per apagar el servidor  
`service mysql stop`  

3. A on es troba i quin nom rep el fitxer de configuració del SGBD Percona Server?

El fitxer de configuració del SGBD Percona Server es diu **my.cnf** i es troba a `/etc/my.cnf`.
![screenshot21](./imgs/Act1-screenshot21.PNG)

4. A on es troben físicament els fitxers de dades (per defecte)

Es trobem al directori `/var/lib/mysql` per defecte. Es pot saber introduint `select @@datadir;`.
![screenshot22](./imgs/Act1-screenshot22.PNG)

5. Crea un usuari anomenat **asix** en el sistema operatiu i en SGBD de tal manera que aquest usuari del sistema operatiu no hagi d'introduir l'usuari i password cada vegada que cridem al client mysql?
  * http://dev.mysql.com/doc/refman/5.7/en/password-security-user.html
  * Usuari SO-→ asix / patata
  * Usuari MySQL → asix / patata

Primer de tot, creem l'usuari asix en el sistema operatiu  
![screenshot23](./imgs/Act1-screenshot23.PNG)

Un cop creat l'usuari, hem de canviar la política de les contrasenyes perque es pugui posar **patata**.  
Per canviar-ho s'ha d'anar a `/etc/security` i editar el fitxer `pwquality.cnf`.  
![screenshot25](./imgs/Act1-screenshot25.PNG)

S'ha de canviar la longitud mínima per un altre.  
![screenshot26](./imgs/Act1-screenshot26.PNG)

Un cop fet, amb la comanda `passwd` posem que la contrasenya sigui **patata**.  
![screenshot27](./imgs/Act1-screenshot27.PNG)  
**Nota:** Encara que digues incorrecte la primera vegada, a la segona ho ha fet.  
![screenshot28](./imgs/Act1-screenshot28.PNG)

Ara que l'usuari **asix** ja està creat, creem l'usuari pel MYSQL, però abans hem de canviar la política de les contrasenyes del MYSQL amb el `SHOW VARIABLES LIKE 'validate_password%;`. Quan estiguin canviades, creem l'usuari amb el `CREATE USER`.
![screenshot29](./imgs/Act1-screenshot29.PNG)

Ja tenim l'usuari **asix** creat al MYSQL, però cada vegada que volem entrar hem de posar l'usuari i contrasenya. Per treure això, hem de crear un fitxer anomenat `.my.cnf` a la carpeta de l'usuari.  
![screenshot30](./imgs/Act1-screenshot30.PNG)

Dins el fitxer escrivim el següent:  
![screenshot31](./imgs/Act1-screenshot31.PNG)

Atorguem permisos al fitxer i un cop fet tot això podrem entrar dins el MYSQL només escrivint `mysql`.
![screenshot32](./imgs/Act1-screenshot32.PNG)


6.	El servei de MySQL (mysqld) escolta al port 3306. Quina modificació/passos caldrien fer per canviar aquest port a 33306 per exemple? Important: No realitzis els canvis. Només indica els passos que faries.

Per canviar el port, hem d’editar el fitxer `/etc/my.cnf`, que és el Global Mysql Configuration File. Un cop dins, afegim el port 33306, `port=33306`. Guardem els canvis i reiniciem el servidor.  
  
  
---
  
  
# **PART II - INSTAL·LACIÓ SGBD MongoDB (màx. 3 punts)** #
![MongoDB](https://webassets.mongodb.com/_com_assets/cms/mongodb-logo-rgb-j6w271g1xn.jpg)

## ENUNCIAT ##
Partint d'una màquina CentOS 7 minimal proporcionada pel professor realitza la instal·lació d'un SGBD NoSQL MongoDB (última versió).

## ENLLAÇOS ##
**Documentació oficial d’instal·lació  MongoDB (RedHat 7)**  
<https://docs.mongodb.com/master/tutorial/install-mongodb-on-red-hat/>

## **Documentació per la instal·lació** ##
Per instal·lar MongoDB, primer hem de configurar el sistema de gestió de paquets via yum. Per fer-ho hem de crear un fitxer a  
`/etc/yum.repos.d/mongodb-org-3.4.repo`  
![screenshotMDB1](./imgs/Act1mongoscreenshot1.PNG)

Per aconseguir l’última versió estable de MongoDB, al fitxer escrivim  
![screenshotMDB2](./imgs/Act1mongoscreenshot2.PNG)

Instal·lem els paquets MongoDB i les eines associades  
`sudo yum install -y mongodb-org`
![screenshotMDB3](./imgs/Act1mongoscreenshot3.PNG)

Hem de configurar el SELinux perquè els límits dels recursos del sistema en sistemes operatius Unix poden afectar negativament al funcionament. Es pot configurar de 3 maneres diferents.  

* Una manera és habilitant els ports amb la comanda `semanage port -a -t mongod_port_t -p tcp 27017`. Però el problema que es troba és que no reconeix la comanda `semanage`.
  ![screenshotMDB11](./imgs/Act1mongoscreenshot11.PNG)

  Per instal·lar `semanage` hem de posar una sèrie de comandes.

  `yum provides /usr/sbin/semanage`  
  ![screenshotMDB12](./imgs/Act1mongoscreenshot12.PNG)

  Hem d’instal·lar `policycoreutils-python-2.2.5-11.el7_0.1.x86_64` per aconseguir la comanda `semanage`.  
  `yum install policycoreutils-python`
  ![screenshotMDB13](./imgs/Act1mongoscreenshot13.PNG)  
  ![screenshotMDB14](./imgs/Act1mongoscreenshot14.PNG)

  Un cop instal·lat ja es pot utilitzar la comanda `semanage`.  
  `semanage port -a -t mongod_port_t -p tcp 27017`  
  **Nota:** un problema que es pot tenir és que falli la comanda. Al reiniciar el sistema no hauria d’haver-hi cap problema.

* Un altre és editant el fitxer `/etc/selinux/config`. Canviem la línia de `SELINUX=enforcing` a `SELINUX=disabled`.  
  ![screenshotMDB8](./imgs/Act1mongoscreenshot8.PNG)  
  ![screenshotMDB9](./imgs/Act1mongoscreenshot9.PNG)

* L’altre és també  editant el fitxer `/etc/selinux/config`. Canviem la línia de `SELINUX=enforcing` a `SELINUX=permissive`.

  El servidor podrà iniciar sense cap problema.  
  **Nota:** un dels problemes que es pot tenir és que la primera vegada que es vulgui entrar falli.  
  ![screenshotMDB10](./imgs/Act1mongoscreenshot10.PNG)

Per iniciar el servidor  
`sudo service mongod start`  
![screenshotMDB4](./imgs/Act1mongoscreenshot4.PNG)

Per comprovar que MongoDB ha iniciat correctament hem de mirar el fitxer `/var/log/mongodb/mongod.log`. Ens hem de posicionar a l’última línia que diu `[initandlisten] waiting for connections on port <port>`, on el port és el que està configurat per defecte a `/etc/mongod.conf, 27017`.  
![screenshotMDB5](./imgs/Act1mongoscreenshot5.PNG)

Opcionalment, per assegurar-se que MongoDB iniciï després d’un reinici de servidor  
`sudo chkconfig mongod on`  
![screenshotMDB6](./imgs/Act1mongoscreenshot6.PNG)

Per apagar el servidor  
`sudo service mongod stop`  
![screenshotMDB7](./imgs/Act1mongoscreenshot7.PNG)

Per reiniciar el servidor  
`sudo service mongod restart`

Perquè el servidor MongoDB comenci quan s'engega el servidor:  
`systemctl enable mongod.service`






