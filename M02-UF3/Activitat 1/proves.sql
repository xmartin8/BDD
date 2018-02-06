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
    
drop table reserves_pais;
create table reserves_pais (
	id int auto_increment primary key,
    any int,
    num_reserves int,
    nom_pais varchar(40) DEFAULT NULL
);

insert into reserves_pais (any, num_reserves, nom_pais)
select year(r.data_fi), count(r.reserva_id), p.nom
from reserves r
inner join clients c on c.client_id = r.client_id
inner join paisos p on p.pais_id = c.pais_origen_id
group by p.nom, year(r.data_fi);

truncate table reserves_pais;
select * from reserves_pais;

select year(r.data_fi), count(r.reserva_id), p.nom
from reserves r
inner join clients c on c.client_id = r.client_id
inner join paisos p on p.pais_id = c.pais_origen_id
where p.nom = "Alemania"
group by p.nom, year(r.data_fi);