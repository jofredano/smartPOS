
 DROP PROCEDURE IF EXISTS smpos_prc_crear_entidad;
 -- Creamos un procedimiento que recibe un número de documento y un entero 
 -- como parámetro de entrada y salida
 DELIMITER //
 CREATE PROCEDURE smpos_prc_crear_entidad(
	IN 		vin_ent_tipo				VARCHAR(200),
	IN 		vin_ent_identificacion		VARCHAR(25),
	IN		vin_per_nombres				VARCHAR(255),
	IN 		vin_per_apellidos			VARCHAR(255),
	IN 		vin_per_fecha_nacimiento	DATE,
	IN 		vin_emp_razon_social		VARCHAR(255),
	IN 		vin_ent_direccion			TEXT,
	IN 		vin_ent_telefono			TEXT,
	IN 		vin_ent_correo				TEXT,
   	OUT 	vou_codigo 	 				INT(11),
	OUT 	vou_mensaje					TEXT)
 BEGIN
	NULL;
 END //
 DELIMITER;