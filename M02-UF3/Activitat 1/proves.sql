USE db_hotels;
SHOW TABLES;
SELECT * FROM clients;
SELECT * FROM habitacions;
SELECT * FROM hotels;
SELECT * FROM paisos;
SELECT * FROM poblacions;
SELECT * FROM reserves;


SELECT h.nom
	FROM hotels h
	INNER JOIN habitacions hab ON hab.hotel_id = h.hotel_id
    INNER JOIN reserves r ON r.hab_id = hab.hab_id
WHERE h.categoria = 4;
    
SELECT h.nom 
FROM reserves r 
INNER JOIN habitacions hab ON hab.hab_id = r.hab_id
INNER JOIN hotels h ON h.hotel_id = hab.hotel_id
WHERE r.data_inici >= '2015-01-01' AND r.data_fi <= '2015-12-31'
	AND h.categoria = 4;
    

create table reserves_pais (
	id int auto_increment primary key,
    reserves_any14 int,
    reserves_any15 int,
    reserves_any16 int,
    nom_pais varchar(40) DEFAULT NULL
);

truncate table reserves_pais;
select * from reserves_pais;


insert into reserves_pais (reserves_any14, reserves_any15, reserves_any16, nom_pais);
select count(r.reserva_id) as '2014',null as '2015',null as '2016', p.nom
from reserves r
inner join clients c on c.client_id = r.client_id
inner join paisos p on p.pais_id = c.pais_origen_id
where year(r.data_fi) = 2014
group by p.nom
union
select null as '2014',count(r.reserva_id) as '2015',null as '2016', p.nom
from reserves r
inner join clients c on c.client_id = r.client_id
inner join paisos p on p.pais_id = c.pais_origen_id
where year(r.data_fi) = 2015
group by p.nom
union
select null as '2014', null as '2015', count(r.reserva_id) as '2016', p.nom
from reserves r
inner join clients c on c.client_id = r.client_id
inner join paisos p on p.pais_id = c.pais_origen_id
where year(r.data_fi) = 2016
group by p.nom;


