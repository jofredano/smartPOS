
 DROP PROCEDURE IF EXISTS smpos_prc_obtener_consecutivo;
 DROP PROCEDURE IF EXISTS smpos_prc_crear_consecutivos;
 DROP PROCEDURE IF EXISTS smpos_prc_crear_entidad;
 DROP PROCEDURE IF EXISTS smpos_prc_crear_empleado;
 DROP PROCEDURE IF EXISTS smpos_prc_crear_usuario;
 DROP PROCEDURE IF EXISTS debug_msg;
 
 -- Procedimiento para crear un rango de consecutivos -- 
 DELIMITER //
 
 CREATE PROCEDURE debug_msg(enabled INTEGER, msg VARCHAR(255))
  BEGIN
  	IF enabled THEN 
  		BEGIN
    		SELECT CONCAT("** ", msg) AS '** DEBUG:';
  		END; 
  	END IF;
  END//
 
 CREATE PROCEDURE smpos_prc_crear_consecutivos(
 	IN 		vin_con_base					INT(11),
	IN 		vin_con_inicio					INT(11),
	IN 		vin_con_fin						INT(11),
	IN 		vin_con_codigo_resolucion		VARCHAR(255),
	IN 		vin_con_fecha_resolucion		DATE,
	OUT 	vou_codigo						INT(11),
	OUT		vou_mensaje						TEXT)
 BEGIN
 	DECLARE CESRANG_ACTIVO INT(11) DEFAULT 0;
 	DECLARE CESCONS_ACTIVO INT(11) DEFAULT 0;
 	DECLARE CNUMERO_CON_IN INT(11) DEFAULT 0;
 	DECLARE CNUMERO_CON_FI INT(11) DEFAULT 0;
 	DECLARE CCODIGO_INGRES INT(11) DEFAULT 0;
 	DECLARE CODRANG_CONSEC INT(11) DEFAULT 0;
 	
 	SET CESRANG_ACTIVO = smpos_fnc_obtener_categ_codigo('CONSECUTIVO.RANGO.ESTADO.ACTIVO');
 	SET CESCONS_ACTIVO = smpos_fnc_obtener_categ_codigo('CONSECUTIVO.NUMERO.ESTADO.ACTIVO');
 	
 	-- Valida si existe un rango con esta resolucion --
 	SET CODRANG_CONSEC = smpos_fnc_obtener_consec_rango_codigo( vin_con_codigo_resolucion );
 
 	IF  CODRANG_CONSEC > 0 THEN 
		SET vou_codigo  = 507;
		SET vou_mensaje = CONCAT('Ya existe un rango de consecutivos con esta resolucion', ' (', vin_con_codigo_resolucion, ')');
 	ELSE 
	 	-- Definicion del rango de consecutivos --
	 	INSERT INTO smpos_csc_rangos 
	 		(con_base, con_inicio, con_fin, con_fecha_creacion, con_codigo_resolucion, con_fecha_resolucion, con_estado)
	 	VALUES 
	 		(vin_con_base, vin_con_inicio, vin_con_fin, NOW(), vin_con_codigo_resolucion, vin_con_fecha_resolucion, CESRANG_ACTIVO);
	 	SET CCODIGO_INGRES = LAST_INSERT_ID();
	 	
		-- Definicion de cada consecutivo --
		SET CNUMERO_CON_IN = vin_con_base + vin_con_inicio;
		SET CNUMERO_CON_FI = vin_con_base + vin_con_fin;
		WHILE CNUMERO_CON_IN  <= CNUMERO_CON_FI DO
		    INSERT INTO smpos_csc_consecutivos
		    	(con_consecutivo, con_numero, con_estado)
		    VALUES 
		    	(CCODIGO_INGRES, CNUMERO_CON_IN, CESCONS_ACTIVO);
		    SET  CNUMERO_CON_IN = CNUMERO_CON_IN + 1; 
		END WHILE;
	
		SET vou_codigo  = 200;
		SET vou_mensaje = 'Consecutivos creados con exito';
 	END IF;
 END //
 
 CREATE PROCEDURE smpos_prc_obtener_consecutivo(
 	OUT 	vou_consecutivo_codigo		INT(11),
	OUT 	vou_consecutivo_numero		INT(11),
   	OUT 	vou_codigo 	 				INT(11),
	OUT 	vou_mensaje					TEXT)
 BEGIN
 	DECLARE CONSECU_CODIGO 	INT(11) DEFAULT 0;
 	DECLARE CONSECU_NUMERO 	INT(11) DEFAULT 0;
 	DECLARE CESCONS_ACTIVO 	INT(11) DEFAULT 0;
 	DECLARE CESCONS_ASIGNA 	INT(11) DEFAULT 0;
 	DECLARE CESRANG_CONSUM	INT(11)	DEFAULT 0;
 	DECLARE CESRANG_ACTIVO	INT(11)	DEFAULT 0;
 	
 	SET CESCONS_ACTIVO 	 = smpos_fnc_obtener_categ_codigo('CONSECUTIVO.NUMERO.ESTADO.ACTIVO');
 	SET CESCONS_ASIGNA 	 = smpos_fnc_obtener_categ_codigo('CONSECUTIVO.NUMERO.ESTADO.ASIGNADO');
 	SET CESRANG_CONSUM 	 = smpos_fnc_obtener_categ_codigo('CONSECUTIVO.RANGO.ESTADO.CONSUMIDO');
 	SET CESRANG_ACTIVO 	 = smpos_fnc_obtener_categ_codigo('CONSECUTIVO.RANGO.ESTADO.ACTIVO');
  	
  	-- Obtiene de la bolsa el siguiente consecutivo --
  	SELECT 	IF(COUNT(c.con_codigo) > 0, MIN(c.con_codigo), 0) INTO CONSECU_CODIGO
 	FROM 	smpos_csc_consecutivos c
 	WHERE 	c.con_estado 	= CESCONS_ACTIVO;
 	
 	-- Si el codigo del consecutivo es mayor que cero --
 	IF  CONSECU_CODIGO > 0 THEN 
	 	-- Actualiza el consecutivo --
	 	UPDATE 	smpos_csc_consecutivos 
	 	SET		con_estado   	= CESCONS_ASIGNA
	 	WHERE 	con_codigo 		= CONSECU_CODIGO;
	 	-- Entrega el consecutivo --
	  	SELECT 	IF(COUNT(c.con_codigo) > 0, c.con_numero, 0) INTO CONSECU_NUMERO
	 	FROM 	smpos_csc_consecutivos c
	 	WHERE 	c.con_codigo 	= CONSECU_CODIGO;
	 	-- Variables de salida --
	 	SET vou_consecutivo_numero = CONSECU_NUMERO;
	 	SET vou_consecutivo_codigo = CONSECU_CODIGO;
		SET vou_codigo  	 	   = 200;
		SET vou_mensaje 	 	   = 'Consecutivo entregado con exito';
	ELSE 
		-- Actualiza el rango de consecutivos --
		UPDATE 	smpos_csc_rangos
		SET 	con_estado	 	= CESRANG_CONSUM
		WHERE 	con_codigo IN (
			SELECT DISTINCT q.con_consecutivo 
			FROM (
				SELECT 	 c.con_consecutivo, c.con_estado, COUNT(c.con_codigo) CANTIDAD 
				FROM 	 smpos_csc_consecutivos c 
				GROUP BY c.con_consecutivo, c.con_estado
			) q WHERE q.con_estado NOT IN (CESCONS_ACTIVO) 
		);
		-- Significa que no hay mas consecutivos --
		SET vou_codigo  	 = 401;
		SET vou_mensaje 	 = 'No hay consecutivos para ser asignados';
 	END IF;
 	
 END //
  
 -- Procedimiento para crear una entidad -- 
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
	OUT 	vou_entidad					INT(11),
	OUT 	vou_codenti					INT(11),
   	OUT 	vou_codigo 	 				INT(11),
	OUT 	vou_mensaje					TEXT)
 BEGIN
 	DECLARE CODCATTIPO_IDEN_NATURAL		INT(11)	DEFAULT 0;
 	DECLARE CODCATTIPO_IDEN_JURIDIC		INT(11)	DEFAULT 0;
 	DECLARE CODENTIDAD_REGISTRADA		INT(11)	DEFAULT 0;
 	DECLARE CODCATESTA_ACTIVO			INT(11)	DEFAULT 0;
 	DECLARE CODCATTIPO_IDEN_INGRESA		INT(11)	DEFAULT 0;
 	
	DECLARE CONTINUE HANDLER FOR 1062
 		SELECT 	1062 AS vou_codigo,
 				0    AS vou_codenti,
				0    AS vou_entidad,
 				CONCAT('Entidad ya existente (', vin_ent_identificacion, ')') AS vou_mensaje;
 	
 	SET CODCATTIPO_IDEN_NATURAL	= smpos_fnc_obtener_categ_codigo('PERSONA.TIPO.NATURAL');
 	SET CODCATTIPO_IDEN_JURIDIC	= smpos_fnc_obtener_categ_codigo('PERSONA.TIPO.JURIDICA');
 	SET CODCATESTA_ACTIVO		= smpos_fnc_obtener_categ_codigo('ENTIDAD.ESTADO.ACTIVO');
 	SET CODCATTIPO_IDEN_INGRESA	= smpos_fnc_obtener_categ_codigo(vin_ent_tipo);
 	
 	IF (CODCATTIPO_IDEN_INGRESA IN (CODCATTIPO_IDEN_NATURAL, CODCATTIPO_IDEN_JURIDIC)) THEN 
		INSERT INTO smpos_con_entidades 
	 		(ent_identificacion, ent_tipo, ent_direccion, ent_telefono, ent_correo, ent_estado) 
	 	VALUES 
	 		(vin_ent_identificacion, CODCATTIPO_IDEN_INGRESA, vin_ent_direccion, vin_ent_telefono, vin_ent_correo, CODCATESTA_ACTIVO);
		SET CODENTIDAD_REGISTRADA = LAST_INSERT_ID();
		
		-- Este indica si debe definir una entidad o una persona --
		IF 	CODCATTIPO_IDEN_INGRESA = CODCATTIPO_IDEN_NATURAL THEN 
			-- smpos_con_personas --
			INSERT INTO smpos_con_personas 
				(per_entidad, per_nombres, per_apellidos, per_fecha_nacimiento, per_estado)
			VALUES 
				(CODENTIDAD_REGISTRADA, vin_per_nombres, vin_per_apellidos, vin_per_fecha_nacimiento, CODCATESTA_ACTIVO);
			SET vou_codenti = LAST_INSERT_ID();
		ELSE 
			INSERT INTO smpos_con_empresas 
				(emp_entidad, emp_razon_social, emp_estado)
			VALUES 
				(CODENTIDAD_REGISTRADA, vin_emp_razon_social, CODCATESTA_ACTIVO);
			SET vou_codenti = LAST_INSERT_ID();
		END IF;
		-- Fin del bloque --
		SET vou_entidad = CODENTIDAD_REGISTRADA;
		SET vou_codigo  = 200;
		SET vou_mensaje = 'Creacion de la entidad de manera exitosa';
	ELSE 
		SET vou_codenti = 0;
		SET vou_entidad = 0;
		SET vou_codigo  = 507;
		SET vou_mensaje = 'No es un tipo de persona valido para el sistema';
 	END IF;
 END //


 CREATE PROCEDURE smpos_prc_crear_usuario(
 	IN 		vin_usu_alias 				VARCHAR(25),
	IN 		vin_usu_clave 				VARCHAR(255),
	IN 		vin_usu_usuario_creador		INT(11),
	IN 		vin_roles					TEXT,
	OUT 	vou_usuario					INT(11),
   	OUT 	vou_codigo 	 				INT(11),
	OUT 	vou_mensaje					TEXT)
 BEGIN
	DECLARE CODCATESTA_ACTIVO			INT(11)			DEFAULT 0;
	DECLARE CODUSUARIO_REGIST			INT(11)			DEFAULT 0;
	DECLARE CANTIROLES_USUARI			INT(11)			DEFAULT 0;
	DECLARE TXTSEPARAT_ROLES			VARCHAR(1)		DEFAULT ',';
	DECLARE TXTROL_PARAUSUAR			VARCHAR(200)	DEFAULT '';
	DECLARE CODROL_PARAUSUAR			INT(11)			DEFAULT 0;
	DECLARE CANROL_PARAUSUAR			INT(11)			DEFAULT 1;
	DECLARE INDEX_ROL					INT(11)			DEFAULT 1;
	
	DECLARE CONTINUE HANDLER FOR 1062
 		SELECT 	1062 AS vou_usuario,
 				CONCAT('Usuario ya existente (', vin_usu_alias, ')') AS vou_mensaje
 		INTO 	vou_usuario, vou_mensaje;
 	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
 		SELECT 	SQLCODE,
 				CONCAT('Se presento un error general') AS vou_mensaje
 		INTO 	vou_usuario, vou_mensaje;
	
	SET @enabled 				= FALSE;
	SET CODCATESTA_ACTIVO		= smpos_fnc_obtener_categ_codigo('ENTIDAD.ESTADO.ACTIVO');

	-- Cantidad de veces que aparece el separador --
	SELECT LENGTH(vin_roles) - LENGTH(REPLACE(vin_roles, TXTSEPARAT_ROLES, '')) INTO CANTIROLES_USUARI;
	SET CANTIROLES_USUARI		= CANTIROLES_USUARI + 1;
	-- Escribir la cantidad de roles a asignar al usuario --
	call debug_msg(@enabled, CONCAT("Cantidad: ", CANTIROLES_USUARI));
	-- Valida si tiene roles --
	IF	(CANTIROLES_USUARI > 0 AND LENGTH(vin_roles) > 0) THEN
		-- Debug para crear usuario --
		call debug_msg(@enabled, "Procediendo a crear usuario.. ");
		-- Insertando datos del usuario --
		INSERT INTO smpos_sis_usuarios
			( usu_alias 		  , usu_clave 	  , usu_fecha_creacion  , 
			  usu_usuario_creador , usu_estado)
		VALUES ( 
			  vin_usu_alias		      , PASSWORD(vin_usu_clave), CURRENT_DATE,
			  vin_usu_usuario_creador , CODCATESTA_ACTIVO );
		-- Codigo asignado para el usuario --
		call debug_msg(@enabled, "Usuario insertado... ");
		-- Almacenando codigo usuario --
		SET CODUSUARIO_REGIST 	 	 = LAST_INSERT_ID();
		-- Codigo asignado para el usuario --
		call debug_msg(@enabled, CONCAT("Codigo del usuario ", CODUSUARIO_REGIST));
		-- Asigna el nuevo usuario --
		-- Logica para asignar roles al usuario --
		rolloop: WHILE INDEX_ROL <= CANTIROLES_USUARI DO
			-- Procedemos a realizar ciclo --
			call debug_msg(@enabled, CONCAT("Rol INDEX: ", INDEX_ROL));
			-- Obtiene la abreviatura del rol a asociar al usuario --
			SELECT SUBSTRING_INDEX(vin_roles, TXTSEPARAT_ROLES, INDEX_ROL) INTO TXTROL_PARAUSUAR;
			-- Rol leido --
			call debug_msg(@enabled, CONCAT("Rol: ", TXTROL_PARAUSUAR));
			-- Se realiza la consulta del identificador del rol --
			SET CODROL_PARAUSUAR	 = smpos_fnc_obtener_rol_codigo( TXTROL_PARAUSUAR );
			-- Valida si existe el rol definido --
			IF	CODROL_PARAUSUAR > 0 THEN
				-- Linea para debug --
				call debug_msg(@enabled, CONCAT("Intentando almacenar rol: ", TXTROL_PARAUSUAR));
				-- Insertar registro en base de datos --
				INSERT INTO smpos_sis_usuarios_x_roles 
					   (uxr_rol, uxr_usuario, uxr_estado)
				VALUES (CODROL_PARAUSUAR, CODUSUARIO_REGIST, CODCATESTA_ACTIVO);
				-- Incrementa para la siguiente posicion --
				SET INDEX_ROL 		 = INDEX_ROL + 1; 
			ELSE 
				SET vou_codigo  	 = 507;
				SET vou_mensaje 	 = CONCAT('No existe en el sistema el rol (', TXTROL_PARAUSUAR, ')');
				SET vou_usuario 	 = 0;
				LEAVE rolloop;
			END IF;
		END WHILE;
		
		IF 	CANROL_PARAUSUAR > 0 THEN
			SET vou_codigo  = 200;
			SET vou_mensaje = 'Creacion del usuario de manera exitosa';
		END IF;
	ELSE
		SET vou_usuario 	= 0; 
		SET vou_codigo  	= 500;
		SET vou_mensaje 	= 'No hay definido los roles asociados a este usuario';
	END IF;
 END //

 -- Procedimiento para crear un empleado -- 
 CREATE PROCEDURE smpos_prc_crear_empleado(
	IN 		vin_ent_identificacion		VARCHAR(25),
	IN		vin_per_nombres				VARCHAR(255),
	IN 		vin_per_apellidos			VARCHAR(255),
	IN 		vin_per_fecha_nacimiento	DATE,
	IN 		vin_emp_razon_social		VARCHAR(255),
	IN 		vin_ent_direccion			TEXT,
	IN 		vin_ent_telefono			TEXT,
	IN 		vin_ent_correo				TEXT,
	IN		vin_emp_tipo_contrato		VARCHAR(200),
	IN		vin_emp_numero_contrato		VARCHAR(255),
	IN		vin_emp_fecha_inicio 		DATE,
	IN		vin_emp_fecha_fin 			DATE,
 	IN 		vin_usu_alias 				VARCHAR(25),
	IN 		vin_usu_clave 				VARCHAR(255),
	IN 		vin_roles					TEXT,
	IN		vin_usuario_creador			INT(11),
	OUT 	vou_entidad					INT(11),
   	OUT 	vou_codigo 	 				INT(11),
	OUT 	vou_mensaje					TEXT)
  BEGIN
  	DECLARE CODENTID_PERSONA 		INT(11)	DEFAULT 0;
  	DECLARE CODENTID_ENTIDAD		INT(11) DEFAULT 0;
	DECLARE CODSALID_ESTADO			INT(11)	DEFAULT 0;
	DECLARE MSGSALID_ESTADO			TEXT	DEFAULT '';
	DECLARE CODCATTIPO_CONT			INT(11)	DEFAULT 0;
	DECLARE CODUSUARIO_REGI			INT(11)	DEFAULT 0;
	DECLARE CODCATESTA_ACTIVO		INT(11)	DEFAULT 0;
	DECLARE DEVOLVER_TODO			INT(11)	DEFAULT 0;

	SET @enabled 			= FALSE;	
	SET CODCATTIPO_CONT		= smpos_fnc_obtener_categ_codigo(vin_emp_tipo_contrato);
	SET CODCATESTA_ACTIVO	= smpos_fnc_obtener_categ_codigo('ENTIDAD.ESTADO.ACTIVO');
	
	START TRANSACTION; 
		CALL smpos_prc_crear_entidad(
			'PERSONA.TIPO.NATURAL',		vin_ent_identificacion,
			vin_per_nombres, 			vin_per_apellidos,
			vin_per_fecha_nacimiento, 	vin_emp_razon_social,
			vin_ent_direccion,			vin_ent_telefono,
			vin_ent_correo,				CODENTID_PERSONA,
			CODENTID_ENTIDAD,			CODSALID_ESTADO,
			MSGSALID_ESTADO);
		-- Debug para crear usuario --
		call debug_msg(@enabled, CONCAT('Entidad creada (', CODSALID_ESTADO, '-', MSGSALID_ESTADO, ')'));
		-- Validamos que la entidad fue creada --
		IF 	(CODSALID_ESTADO = 200 AND CODENTID_ENTIDAD > 0) THEN
			-- Se realiza creacion del usuario --
			CALL smpos_prc_crear_usuario(
			 	vin_usu_alias,		 vin_usu_clave,
				vin_usuario_creador, vin_roles,
				CODUSUARIO_REGI,	 CODSALID_ESTADO,
				MSGSALID_ESTADO);
			-- Debug para crear usuario --
			call debug_msg(@enabled, CONCAT('Usuario creado (', CODSALID_ESTADO, '-', MSGSALID_ESTADO, ')'));
			-- Condicion del registro --
			IF (CODSALID_ESTADO = 200 AND CODUSUARIO_REGI > 0) THEN
				INSERT INTO smpos_con_empleados 
					   ( emp_persona, 		emp_tipo_contrato, 	emp_numero_contrato, 	 emp_fecha_creacion,
						 emp_fecha_inicio,	emp_fecha_fin, 		emp_usuario,		 	 emp_usuario_creador, 
						 emp_estado )
				VALUES ( CODENTID_ENTIDAD, 		CODCATTIPO_CONT,	vin_emp_numero_contrato, NOW(), 
					     vin_emp_fecha_inicio,	vin_emp_fecha_fin,	CODUSUARIO_REGI,	 vin_usuario_creador,
					     CODCATESTA_ACTIVO);
				SET vou_entidad		= LAST_INSERT_ID();
				IF	vou_entidad > 0 THEN
					SET vou_codigo  = 200;
					SET vou_mensaje = 'Creacion del empleado exitosamente';
					COMMIT;
				END IF;
			ELSE
				SET vou_entidad	= 0; 
				SET vou_codigo  = CODSALID_ESTADO;
				SET vou_mensaje = MSGSALID_ESTADO;
			END IF;
		ELSE 
			SET vou_entidad		= 0;
			SET vou_codigo  	= CODSALID_ESTADO;
			SET vou_mensaje 	= MSGSALID_ESTADO;
		END IF;
  END //
  
 DELIMITER $$;