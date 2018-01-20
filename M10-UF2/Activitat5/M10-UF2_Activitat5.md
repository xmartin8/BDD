**Sara Caparrós Torres i Patricia López López (ASIX 2 - Curs 2017/18)**  
# ACTIVITAT CLUSTERING #
**Index**  
* [Clustering](#clustering)  
* [Clustering MySQL](#clustering--mysql)  
* [Balancejador / Proxy](#balancejador--proxy)  
  
# CLUSTERING
![Logo PerconaXDB cluster][2]  
Donada  la configuració d'un MySQL Cluster es vol muntar un entron SGBD amb clustering  mitjançant Percona XtraDB Cluster.  
**Documentació a on podeu trobar certa informació:**  
[URL Documentacio1](https://www.percona.com/software/mysql-database/percona-xtradb-cluster)  
[URL Documentacio2](https://www.percona.com/doc/percona-xtradb-cluster/5.5/index.html)  
[URL Documentacio3](https://www.percona.com/doc/percona-xtradb-cluster/5.5/howtos/centos_howto.html)  

## CONFIGURACIÓ MYSQL CLUSTER
Esquema d'instal·lació d'un MySQL Cluster amb  4 màquines virtuals amb 0,5/1 GB de RAM i CentOS Desactiva el firewall o permet la connexió als ports 3306, 4444, 4567, 4568  

IPs de cada Node (X són els 2 últim dígits del DNI d'un dels components del grup.):  
*	Node 1: nodeid = 1, hostname=percona1, IP=192.168.X.71  
*	Node 2: nodeid = 2, hostname=percona2, IP=192.168.X.72  
*	Node 3: nodeid = 3, hostname=percona3, IP=192.168.X.73  
*	Node 4: nodeid = 4, hostname=percona4, IP=192.168.X.74  

Cal repartir els nodes com a mínim en 3 màquines físiques  
Explica El Bootstrapping the cluster i el concepte split-brain  

## ENTREGA  
Realitza la documentació de la instal·lació i configuració que has hagut de dur a terme per pereparar un Percona XtraDB Cluster. Mostra al professor la funcionalitat del Cluster.  
Intenta de provar una parada d'una màquina i veure com es recupera de la parada.  

# CLUSTERING  MySQL  
![Logo MySQL][1]  
Donada  la configuració d'un MySQL Cluster es vol muntar un entron SGBD amb clustering  mitjançant MySQL  

## CONFIGURACIÓ MYSQL CLUSTER  
*	Esquema d'instal·lació d'un MySQL Cluster amb 5 màquines virtuals amb 0,5/1 GB de RAM i CentOS 7  
    +	2 Data Nodes  
    +	2 SQL Nodes  
    +	1 Management Node  
*	Desactiva el firewall o permet la connexió als ports necessaris  

Cal repartir els nodes com a mínim en 3 màquines físiques  
**Pots saber quines particions hi ha en una taula concreta?**  

### PRE-REQUISITS:

- Tots els nodes han de tenir la mateixa versió de Centos.  
- El Firewall ha d’estar desactivat o ha de permetre els ports 3306, 4444, 4567 i 4568  
    `systemctl disable firewalld`  
    `service firewalld stop`  


| Server | IP | Color Terminal |  
| :---------- | :----------: | :----------: |  
| Managment node (1)  | 10.92.254.107  | Negre  |  
| Data node (2)  | 10.92.255.74  | Blanc  |  
| Data node (3)  | 10.92.255.73  | Gris  |  
| SQL node (4)  | 10.92.255.72  | Blau  |  
| SQL node (5)  | 10.92.255.71  | Cian  |  

Per canviar el nom
`hostnamectl set-hostname "nou nom del host"`

### A TOTES LES MÀQUINES
#### Baixar el MYSQL Cluster software:
`wget http://dev.mysql.com/get/Downloads/MySQL-Cluster-7.4/MySQL-Cluster-gpl-7.4.10-1.el7.x86_64.rpm-bundle.tar`  
`tar -xvf MySQL-Cluster-gpl-7.4.10-1.el7.x86_64.rpm-bundle.tar`  
![M1-1][M1-1]  

#### Instal·lem i Esborrem paquets
Instal·lem el perl-Data-Dumper i esborrem el mariadb-libs, que pot entrar en conflicte amb el MySQL Cluster  
`yum -y install perl-Data-Dumper`  
![M1-2][M1-2]  
`yum -y remove mariadb-libs`  
![M1-3][M1-3]  

#### Instal·lem el MySQL Cluster
Instal·lem el servidor MySQL Cluster, el client, i el paquet compartit amb el rpm.
```
cd ~
rpm -Uvh MySQL-Cluster-client-gpl-7.4.10-1.el7.x86_64.rpm
rpm -Uvh MySQL-Cluster-server-gpl-7.4.10-1.el7.x86_64.rpm
rpm -Uvh MySQL-Cluster-shared-gpl-7.4.10-1.el7.x86_64.rpm
```
![M1-4][M1-4]  
`sudo yum install net-tools`  
![M1-5][M1-5]  
`rpm -Uvh MySQL-Cluster-server-gpl-7.4.10-1.el7.x86_64.rpm`  
![M1-6][M1-6]  

### Configuració del management node:

Creem un nou directori pels fitxers de configuració.  
`mkdir -p /var/lib/mysql-cluster`  
Creem un nou fitxer de configuració per el cluster del management anomenat **config.ini** en el directori **mysql-cluster**.  
`cd /var/lib/mysql-cluster`  
`nano config.ini`  
Copiem el següent:    
```
[ndb_mgmd default] 
#Directori del management node per fitxers de log
DataDir=/var/lib/mysql-cluster

[ndb_mgmd]
#Management Node1
HostName=10.92.254.107

[ndbd default]
NoOfReplicas=2          # Numero de repliques
DataMemory=256M         # Memoria allotjada pel data storage
IndexMemory=128M        # Memoria allotjada pel index storgae
#Directori pel Data Node
DataDir=/var/lib/mysql-cluster

[ndbd]
#Data Node2
HostName=10.92.255.74

[ndbd]
#Data Node3
HostName=10.92.255.73

[mysqld]
#SQL Node4
HostName=10.92.255.72

[mysqld]
#SQL Node5
HostName=10.92.255.71
```
![M1-7][M1-7]  
![M1-8][M1-8]  

Guardem i sortim.

### Iniciem el Management Node

El següent serà iniciar al management node amb la següent comanda:  
`ndb_mgmd --config-file=/var/lib/mysql-cluster/config.ini  `  
El resultat ha de ser similar a això:   
```
MySQL Cluster Management Server mysql-5.6.28 ndb-7.4.10  
2016-03-22 19:26:08 [MgmtSrvr] INFO 	-- The default config directory '/usr/mysql-cluster' does not exist. Trying to create it...
2016-03-22 19:26:08 [MgmtSrvr] INFO 	-- Successfully created config directory
```
![M1-9][M1-9]  

El management node està iniciat, ara es pot escriure la comanda `ndb_mgm` per controlar el node:  
```
ndb_mgm
show
```
![M1-10][M1-10]  

### Configuració dels data nodes:  
Creem un nou fitxer de configuració en el directori **/etc/**:  
`nano /etc/my.cnf`  
Copiem el següent:   
```
[mysqld]
ndbcluster
ndb-connectstring=10.92.254.107 	# IP del Management Node
 
[mysql_cluster]
ndb-connectstring=10.92.254.107 	# IP del Management Node
```
Guardem el fitxer i sortim.  

![M1-11][M1-11]  
![M1-12][M1-12]  

Creem un nou directori per les dades de la base de dades que vàrem definir al fitxer **config.ini**:  
`mkdir -p /var/lib/mysql-cluster`  
Iniciem el node:  
`ndbd`  
Els resutats:   
```
2016-03-22 19:35:56 [ndbd] INFO 	-- Angel connected to '192.168.1.120:1186'
2016-03-22 19:35:56 [ndbd] INFO 	-- Angel allocated nodeid: 2
```

![M1-13][M1-13]  

Un cop acabada aquesta configuració en un dels nodes la fem a l'altre.

### Configuració dels SQL nodes:
Creem un nou fitxer dintre del directori **/etc**, s’ha de dir **my.cnf**  
`sudo nano /etc/my.cnf` 
  
I dintre li escribim:  
```
[mysqld]
ndbcluster
ndb-connectstring=10.92.254.107   	# IP del management node
default_storage_engine=ndbcluster 	# Defineix el Storage Engine predeterminat utilitzat per MySQL
 
[mysql_cluster]
ndb-connectstring=10.92.254.107   	# IP del management node
```
  
Guardem el fitxer i sortim.  
![M1-14][M1-14]  
![M1-15][M1-15]  
Iniciem el SQL Node, iniciant el MySQL server:  
`service mysql start`  
![M1-16][M1-16]  
![M1-17][M1-17]  

## Monitorització del clúster
Amb la comanda `show` mostrem que estan totes les màquines connectades al clúster.
![M1-18][M1-18]  


### Testejem el cluster

Iniciem sessió en el node 4.
Canviem la contrasenya per defecte del MYSQL que es troba a directori .mysql_secret
![M1-19][M1-19]  
Canviem la contrasenya amb la següent comanda:
`mysql_secure_installation`
![M1-20][M1-20]  
![M1-21][M1-21]  
Un cop canviada, iniciem sessió en el MYSQL. Creem un nou usuari root que pugui accedir a MYSQL des de fora.  
![M1-22][M1-22]   
![M1-23][M1-23]  
Podem veure el nou usuari creat en la llista d’usuaris de MYSQL:
`SELECT user, host, password FROM mysql.user;`
![M1-24][M1-24]  
Donem permisos a aquest usuari root de llegir i escriure.  
![M1-25][M1-25]  
Per últim creem una base de dades en el node4 i la veurem replicada en el node5.  
![M1-26][M1-26]  
Mostrem la contrassenya del node 5 del mysql
![M1-27][M1-27]  
iniciem al mysql amb la contrasenya que ens ha sortit
![M1-28][M1-28]  
A continuació fem el `SET PASSWORD = PASSWORD(‘patata’);`
![M1-29][M1-29]  
Comprovem que es replica tot
![M1-30][M1-30]  

#### Desconnexió sobtada d’una màquina NODE 4
![M1-31][M1-31]  
un cop s’ha tornat a iniciar el node 4, tornem a comprovar que estigui connectat.
![M1-32][M1-32]  
En el cas que es desconnectés un DataNode, s'ha de tornar a fer el `ndbd` i ja es tornaria a connectar.

## ENTREGA
Realitza la documentació de la instal·lació i configuració que has hagut de dur a terme per pereparar el Clúster. Mostra al professor la funcionalitat del Cluster.
Intenta de provar una parada d'una màquina i veure com es recupera de la parada.


# Balancejador / Proxy
Hi ha moltes eines que poden actuar de balancejadors o proxys per estar entre la nostra aplicació i un backend de MySQLs (Nodes).

Diagrames d'exemple:

Escull un dels més coneguts (ProxySQL, HAProxy, MySQL Router,...), proposa una arquitectura i documenta la seva instal·lació. Apropita't dels nodes creats en aquesta activitat de clustering o en l'activitat anterior de rèplica.

## ENTREGA
Realitza la documentació de l'arquitectura escollida, de la instal·lació i configuració que has hagut de dur a terme. Mostra al professor la seva funcionalitat


[1]: imgs/MySQL.png
[2]: imgs/pxdbc-logo.png
[M1-1]: imgs/m1-1.png
[M1-2]: imgs/m1-2.png
[M1-3]: imgs/m1-3.png
[M1-4]: imgs/m1-4.png
[M1-5]: imgs/m1-5.png
[M1-6]: imgs/m1-6.png
[M1-7]: imgs/m1-7.png
[M1-8]: imgs/m1-8.png
[M1-9]: imgs/m1-9.png
[M1-10]: imgs/m1-10.png
[M1-11]: imgs/m1-11.png
[M1-12]: imgs/m1-12.png
[M1-13]: imgs/m1-13.png
[M1-14]: imgs/m1-14.png
[M1-15]: imgs/m1-15.png
[M1-16]: imgs/m1-16.png
[M1-17]: imgs/m1-17.png
[M1-18]: imgs/m1-18.png
[M1-19]: imgs/m1-19.png
[M1-20]: imgs/m1-20.png
[M1-21]: imgs/m1-21.png
[M1-22]: imgs/m1-22.png
[M1-23]: imgs/m1-23.png
[M1-24]: imgs/m1-24.png
[M1-25]: imgs/m1-25.png
[M1-26]: imgs/m1-26.png
[M1-27]: imgs/m1-27.png
[M1-28]: imgs/m1-28.png
[M1-29]: imgs/m1-29.png
[M1-30]: imgs/m1-30.png
[M1-31]: imgs/m1-31.png
[M1-32]: imgs/m1-32.png





