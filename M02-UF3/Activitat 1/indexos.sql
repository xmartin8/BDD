ALTER TABLE hotels
	ADD INDEX categoria(categoria, nom, adreca);

ALTER table clients
	ADD INDEX nom_complet(nom, cognom1);

ALTER TABLE reserves
	ADD KEY covered(reserva_id, data_inici, data_fi, hab_id, client_id);

ALTER TABLE clients
	ADD KEY mes (mes_naix);

ALTER TABLE poblacions
	ADD INDEX nom (nom, poblacio_id);

ALTER TABLE reserves
	ADD INDEX diasetmana (diasetmana, data_inici, data_fi);

ALTER TABLE hotels
	ADD INDEX hotels (nom, categoria, habitacions);

ALTER TABLE reserves_pais
	ADD INDEX pais_reserves(any, num_reserves, nom_pais);

ALTER TABLE clients
	ADD INDEX cognom (cognom1, nom);