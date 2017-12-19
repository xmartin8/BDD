**Sara Caparrós Torres i Patricia López López (ASIX 2 - Curs 2017/18)**  
# ACTIVITAT CLUSTERING #
**Index**
* [Binlog](#replicaci%C3%93-via-binlog-3-punts)
* [GTID](#replicaci%C3%93-via-gtid-4-punts)
* [Opcionals](#punts-opcionals-m%C3%A0x-6-punts)
* [Preguntes](#respon-a-les-seg%C3%BCents-preguntes-en-el-cas-de-binlog-i-gtid)


# CLUSTERING (6 punts)

Donada  la configuració d'un MySQL Cluster es vol muntar un entron SGBD amb clustering  mitjançant Percona XtraDB Cluster.  
**Documentació a on podeu trobar certa informació:**  
https://www.percona.com/software/mysql-database/percona-xtradb-cluster  
https://www.percona.com/doc/percona-xtradb-cluster/5.5/index.html  
https://www.percona.com/doc/percona-xtradb-cluster/5.5/howtos/centos_howto.html  

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

 

# CLUSTERING  MySQL (8 punts)

Donada  la configuració d'un MySQL Cluster es vol muntar un entron SGBD amb clustering  mitjançant MySQL

## CONFIGURACIÓ MYSQL CLUSTER
*	Esquema d'instal·lació d'un MySQL Cluster amb 5 màquines virtuals amb 0,5/1 GB de RAM i CentOS 7
    +	2 Data Nodes
    +	2 SQL Nodes
    +	1 Management Node
*	Desactiva el firewall o permet la connexió als ports necessaris

Cal repartir els nodes com a mínim en 3 màquines físiques
Pots saber quines particions hi ha en una taula concreta?

## ENTREGA
Realitza la documentació de la instal·lació i configuració que has hagut de dur a terme per pereparar el Clúster. Mostra al professor la funcionalitat del Cluster.
Intenta de provar una parada d'una màquina i veure com es recupera de la parada.

# Balancejador / Proxy (3 punts)
Hi ha moltes eines que poden actuar de balancejadors o proxys per estar entre la nostra aplicació i un backend de MySQLs (Nodes).

Diagrames d'exemple:

Escull un dels més coneguts (ProxySQL, HAProxy, MySQL Router,...), proposa una arquitectura i documenta la seva instal·lació. Apropita't dels nodes creats en aquesta activitat de clustering o en l'activitat anterior de rèplica.

## ENTREGA
Realitza la documentació de l'arquitectura escollida, de la instal·lació i configuració que has hagut de dur a terme. Mostra al professor la seva funcionalitat

