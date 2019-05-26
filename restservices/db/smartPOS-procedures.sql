
 DROP PROCEDURE IF EXISTS smpos_prc_obtener_consecutivo;
 DROP PROCEDURE IF EXISTS smpos_prc_crear_consecutivos;
 DROP PROCEDURE IF EXISTS smpos_prc_crear_entidad;
 DROP PROCEDURE IF EXISTS smpos_prc_crear_empleado;
 DROP PROCEDURE IF EXISTS smpos_prc_crear_usuario;
 DROP PROCEDURE IF EXISTS smpos_prc_crear_proveedor;
 DROP PROCEDURE IF EXISTS smpos_prc_crear_articulo;
 DROP PROCEDURE IF EXISTS smpos_prc_iniciar_sesion;
 DROP PROCEDURE IF EXISTS smpos_prc_verificar_sesion;
 DROP PROCEDURE IF EXISTS smpos_prc_finalizar_sesion;
 DROP PROCEDURE IF EXISTS smpos_prc_obtener_menu;
 DROP PROCEDURE IF EXISTS smpos_prc_verificar_perfil;
 DROP PROCEDURE IF EXISTS smpos_prc_obtener_categorias;
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
	OUT 	vou_codigo						CHAR(5),
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
		SET vou_codigo  = '507';
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
	
		SET vou_codigo  = '200';
		SET vou_mensaje = 'Consecutivos creados con exito';
 	END IF;
 END //
 
 CREATE PROCEDURE smpos_prc_obtener_consecutivo(
 	OUT 	vou_consecutivo_codigo		INT(11),
	OUT 	vou_consecutivo_numero		INT(11),
   	OUT 	vou_codigo 	 				CHAR(5),
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
		SET vou_codigo  	 	   = '200';
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
		SET vou_codigo  	 = '401';
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
   	OUT 	vou_codigo 	 				CHAR(5),
	OUT 	vou_mensaje					TEXT)
 BEGIN
 	DECLARE CODCATTIPO_IDEN_NATURAL		INT(11)	DEFAULT 0;
 	DECLARE CODCATTIPO_IDEN_JURIDIC		INT(11)	DEFAULT 0;
 	DECLARE CODENTIDAD_REGISTRADA		INT(11)	DEFAULT 0;
 	DECLARE CODCATESTA_ACTIVO			INT(11)	DEFAULT 0;
 	DECLARE CODCATTIPO_IDEN_INGRESA		INT(11)	DEFAULT 0;
	DECLARE CODSAL_ERROR				CHAR(5)			DEFAULT '00000';
	DECLARE MSGSAL_ERROR				VARCHAR(255)	DEFAULT '';
 	
 	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
 		BEGIN
 			GET DIAGNOSTICS CONDITION 1
        		CODSAL_ERROR = RETURNED_SQLSTATE, 
        		MSGSAL_ERROR = MESSAGE_TEXT;
        	IF  STRCMP(CODSAL_ERROR, '23000') = 0 THEN
        		SET MSGSAL_ERROR = CONCAT('Entidad ya existente (', vin_ent_identificacion, ')');
        	END IF;
    	END;
 	
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
		
		IF 	CODENTIDAD_REGISTRADA > 0 THEN
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
			SET vou_codigo  = '200';
			SET vou_mensaje = 'Creacion de la entidad de manera exitosa';
		ELSE 
			SET vou_entidad = CODENTIDAD_REGISTRADA;
			SET vou_codigo  = CODSAL_ERROR;
			SET vou_mensaje = MSGSAL_ERROR;
		END IF;
	ELSE 
		SET vou_codenti = 0;
		SET vou_entidad = 0;
		SET vou_codigo  = '507';
		SET vou_mensaje = 'No es un tipo de persona valido para el sistema';
 	END IF;
 END //


 CREATE PROCEDURE smpos_prc_crear_usuario(
 	IN 		vin_usu_alias 				VARCHAR(25),
	IN 		vin_usu_clave 				VARCHAR(255),
	IN 		vin_usu_usuario_creador		INT(11),
	IN 		vin_roles					TEXT,
	OUT 	vou_usuario					INT(11),
   	OUT 	vou_codigo 	 				CHAR(5),
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
	DECLARE CODSAL_ERROR				CHAR(5)			DEFAULT '00000';
	DECLARE MSGSAL_ERROR				VARCHAR(255)	DEFAULT '';
	
 	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
 		BEGIN
 			GET DIAGNOSTICS CONDITION 1
        		CODSAL_ERROR = RETURNED_SQLSTATE, 
        		MSGSAL_ERROR = MESSAGE_TEXT;
        	IF  STRCMP(CODSAL_ERROR, '23000') = 0 THEN
        		SET MSGSAL_ERROR 	= CONCAT('Usuario ya existente (', vin_usu_alias, ')');
        	END IF;
    	END;
	
	SET @enabled 				= FALSE;
	SET CODCATESTA_ACTIVO		= smpos_fnc_obtener_categ_codigo('ENTIDAD.ESTADO.ACTIVO');

	-- Debug para crear usuario --
	call debug_msg(@enabled, "Procediendo a crear usuario.. ");
	-- Insertando datos del usuario --
	INSERT INTO smpos_sis_usuarios
		( usu_alias 		  , usu_clave 	  , usu_fecha_creacion  , 
		  usu_usuario_creador , usu_estado)
	VALUES ( 
		  vin_usu_alias		      , PASSWORD(vin_usu_clave), CURRENT_DATE,
		  vin_usu_usuario_creador , CODCATESTA_ACTIVO );
	-- Almacenando codigo usuario --
	SET CODUSUARIO_REGIST 	 	 	= LAST_INSERT_ID();
	-- Codigo asignado para el usuario --
	call debug_msg(@enabled, CONCAT("Usuario insertado... ", CODUSUARIO_REGIST));

	-- Valida la respuesta de la insercion --
	IF	STRCMP(CODSAL_ERROR, '00000') = 0 AND CODUSUARIO_REGIST > 0 THEN
		-- Cantidad de veces que aparece el separador --
		SELECT LENGTH(vin_roles) - LENGTH(REPLACE(vin_roles, TXTSEPARAT_ROLES, '')) INTO CANTIROLES_USUARI;
		SET CANTIROLES_USUARI		= CANTIROLES_USUARI + 1;
		-- Escribir la cantidad de roles a asignar al usuario --
		call debug_msg(@enabled, CONCAT("Cantidad: ", CANTIROLES_USUARI));
		-- Valida si tiene roles --
		IF	(CANTIROLES_USUARI > 0 AND LENGTH(vin_roles) > 0) THEN
			-- Codigo asignado para el usuario --
			call debug_msg(@enabled, CONCAT("Codigo del usuario ", CODUSUARIO_REGIST));
			-- Asigna el nuevo usuario --
			-- Logica para asignar roles al usuario --
			rolloop: WHILE INDEX_ROL <= CANTIROLES_USUARI DO
				-- Procedemos a realizar ciclo --
				call debug_msg(@enabled, CONCAT("Rol INDEX: ", INDEX_ROL));
				-- Obtiene la abreviatura del rol a asociar al usuario --
				SELECT smpos_fnc_split_string(vin_roles, TXTSEPARAT_ROLES, INDEX_ROL) INTO TXTROL_PARAUSUAR;
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
					SET INDEX_ROL 	 = INDEX_ROL + 1; 
				ELSE 
					SET vou_codigo   = '507';
					SET vou_mensaje  = CONCAT('No existe en el sistema el rol (', TXTROL_PARAUSUAR, ')');
					SET vou_usuario  = 0;
					LEAVE rolloop;
				END IF;
			END WHILE;
			
			IF 	CANROL_PARAUSUAR > 0 THEN
				SET vou_usuario	= CODUSUARIO_REGIST;
				SET vou_codigo  = '200';
				SET vou_mensaje = 'Creacion del usuario de manera exitosa';
			END IF;
		ELSE
			SET vou_usuario  = 0; 
			SET vou_codigo   = '500';
			SET vou_mensaje  = 'No hay definido los roles asociados a este usuario';
		END IF;
	ELSE 
		SET vou_codigo  	 = CODSAL_ERROR;
		SET vou_mensaje 	 = MSGSAL_ERROR;
		SET vou_usuario 	 = 0;
	END IF;
 END //

 -- Procedimiento para crear un empleado -- 
 CREATE PROCEDURE smpos_prc_crear_empleado(
	IN 		vin_ent_identificacion		VARCHAR(25),
	IN		vin_per_nombres				VARCHAR(255),
	IN 		vin_per_apellidos			VARCHAR(255),
	IN 		vin_per_fecha_nacimiento	DATE,
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
   	OUT 	vou_codigo 	 				CHAR(5),
	OUT 	vou_mensaje					TEXT)
  BEGIN
  	DECLARE CODENTID_PERSONA 		INT(11)	DEFAULT 0;
  	DECLARE CODENTID_ENTIDAD		INT(11) DEFAULT 0;
	DECLARE CODSALID_ESTADO			CHAR(5)	DEFAULT 0;
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
			vin_per_fecha_nacimiento, 	NULL,
			vin_ent_direccion,			vin_ent_telefono,
			vin_ent_correo,				CODENTID_PERSONA,
			CODENTID_ENTIDAD,			CODSALID_ESTADO,
			MSGSALID_ESTADO);
		-- Debug para crear usuario --
		call debug_msg(@enabled, CONCAT('Entidad (', CODENTID_ENTIDAD, '-', CODSALID_ESTADO, '-', MSGSALID_ESTADO, ')'));
		-- Validamos que la entidad fue creada --
		IF 	(STRCMP(CODSALID_ESTADO, '200') = 0 AND CODENTID_ENTIDAD > 0) THEN
			-- Debug para validar intento de crear usuario --
			call debug_msg(@enabled, 'Intento de creacion usuario...');
			-- Se realiza creacion del usuario --
			CALL smpos_prc_crear_usuario(
			 	vin_usu_alias,		 vin_usu_clave,
				vin_usuario_creador, vin_roles,
				CODUSUARIO_REGI,	 CODSALID_ESTADO,
				MSGSALID_ESTADO);
			-- Debug para crear usuario --
			call debug_msg(@enabled, CONCAT('Usuario creado (', CODSALID_ESTADO, '-', MSGSALID_ESTADO, ')'));
			-- Condicion del registro --
			IF (STRCMP(CODSALID_ESTADO, '200') = 0 AND CODUSUARIO_REGI > 0) THEN
				INSERT INTO smpos_con_empleados 
					   ( emp_persona, 		emp_tipo_contrato, 	emp_numero_contrato, 	 emp_fecha_creacion,
						 emp_fecha_inicio,	emp_fecha_fin, 		emp_usuario,		 	 emp_usuario_creador, 
						 emp_estado )
				VALUES ( CODENTID_ENTIDAD, 		CODCATTIPO_CONT,	vin_emp_numero_contrato, NOW(), 
					     vin_emp_fecha_inicio,	vin_emp_fecha_fin,	CODUSUARIO_REGI,	 vin_usuario_creador,
					     CODCATESTA_ACTIVO);
				SET vou_entidad		= LAST_INSERT_ID();
				IF	vou_entidad > 0 THEN
					SET vou_codigo  = '200';
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

 -- Procedimiento que crea un proveedor nuevo --
 CREATE PROCEDURE smpos_prc_crear_proveedor(
	IN 		vin_ent_tipo				VARCHAR(200),
	IN 		vin_ent_identificacion		VARCHAR(25),
	IN		vin_per_nombres				VARCHAR(255),
	IN 		vin_per_apellidos			VARCHAR(255),
	IN 		vin_per_fecha_nacimiento	DATE,
	IN 		vin_emp_razon_social		VARCHAR(255),
	IN 		vin_ent_direccion			TEXT,
	IN 		vin_ent_telefono			TEXT,
	IN 		vin_ent_correo				TEXT,
	IN 		vin_marcas					TEXT,
	IN		vin_usuario_creador			INT(11),
	OUT 	vou_entidad					INT(11),
   	OUT 	vou_codigo 	 				CHAR(5),
	OUT 	vou_mensaje					TEXT)
  BEGIN
	SET vou_entidad		= 0;
	SET vou_codigo  	= '200';
	SET vou_mensaje 	= 'OK';
  END //
  
 -- procedimiento que crea un nuevo articulo --
 CREATE PROCEDURE smpos_prc_crear_articulo(
	IN		vin_art_categoria			VARCHAR(200) ,
	IN		vin_art_marca 				VARCHAR(200) ,
	IN		vin_art_nombre				VARCHAR(255) ,
	IN		vin_art_descripcion 		TEXT 		 ,
	IN		vin_art_proveedor			VARCHAR(25)	 ,
	IN		vin_art_cantidad_maxima		INT(11)		 ,
	IN		vin_usuario_creador			INT(11)		 ,
	OUT 	vou_entidad					INT(11)		 ,
   	OUT 	vou_codigo 	 				CHAR(5)		 ,
	OUT 	vou_mensaje					TEXT)
  BEGIN
  	DECLARE CODCATEG_ARTICU 		INT(11)	DEFAULT 0;
  	DECLARE CODPROVE_ARTICU			INT(11) DEFAULT 0;
  	DECLARE CODMARCA_ARTICU			INT(11)	DEFAULT 0;
	DECLARE CODARTIC_ACTIVO 		INT(11)	DEFAULT 0;
	DECLARE CODSALID_ESTADO			CHAR(5)	DEFAULT '00000';
	DECLARE MSGSALID_ESTADO			TEXT	DEFAULT '';

 	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
 		BEGIN
 			GET DIAGNOSTICS CONDITION 1
        		CODSALID_ESTADO = RETURNED_SQLSTATE, 
        		MSGSALID_ESTADO = MESSAGE_TEXT;
        	IF  CODSALID_ESTADO = '23000' THEN
        		SET MSGSALID_ESTADO = CONCAT('Articulo ya existente (', vin_art_nombre, ')');
        	END IF;
    	END;

	SET @enabled 			= FALSE;	
	SET CODCATEG_ARTICU		= smpos_fnc_obtener_categ_princip(vin_art_categoria, 'ARTICULO.CATEGORIA');
	SET CODARTIC_ACTIVO		= smpos_fnc_obtener_categ_codigo('ENTIDAD.ESTADO.ACTIVO');
	SET CODMARCA_ARTICU		= smpos_fnc_obtener_marca_codigo( vin_art_marca );
	SET CODPROVE_ARTICU		= smpos_fnc_obtener_prove_identificacion( vin_art_proveedor );
	
	call debug_msg(@enabled, CONCAT('Categoria (', CODCATEG_ARTICU, ')'));
	call debug_msg(@enabled, CONCAT('Marca     (', CODMARCA_ARTICU, ')'));
	call debug_msg(@enabled, CONCAT('Proveedor (', CODPROVE_ARTICU, ')'));	

	IF	CODCATEG_ARTICU > 0 AND vin_art_cantidad_maxima > 0 THEN
		IF	CODMARCA_ARTICU > 0 THEN
			IF	CODPROVE_ARTICU > 0 THEN
				INSERT smpos_inv_articulos 
					(art_categoria,   	art_marca,     art_nombre, 
					 art_descripcion, 	art_proveedor, art_cantidad_maxima, 
					 art_estado) 
				VALUES 	
					(CODCATEG_ARTICU, 	  CODMARCA_ARTICU, vin_art_nombre, 
					 vin_art_descripcion, CODPROVE_ARTICU, vin_art_cantidad_maxima, 
					 CODARTIC_ACTIVO);
				SET vou_entidad		= LAST_INSERT_ID();
				IF	STRCMP(CODSALID_ESTADO, '00000') = 0 THEN
					SET vou_codigo  = '200';
					SET vou_mensaje = 'Creacion del articulo de manera exitosa';
				ELSE 
					SET vou_entidad	= 0; 
					SET vou_codigo  = CODSALID_ESTADO;
					SET vou_mensaje = MSGSALID_ESTADO;
				END IF;
			ELSE 
				SET vou_entidad	= 0;
				SET vou_codigo  = '509';
				SET vou_mensaje = CONCAT('El proveedor usado para el articulo no es valido (', vin_art_proveedor , ')');
			END IF;
		ELSE 
			SET vou_entidad	= 0;
			SET vou_codigo  = '508';
			SET vou_mensaje = CONCAT('La marca usada para el articulo no es valida (', vin_art_marca , ')');
		END IF;
	ELSEIF vin_art_cantidad_maxima < 0 THEN
		SET vou_entidad		= 0;
		SET vou_codigo  	= '510';
		SET vou_mensaje 	= CONCAT('La cantidad permitida de articulos debe ser mayor o igual a cero (', vin_art_cantidad_maxima , ')');
	ELSE
		SET vou_entidad		= 0;
		SET vou_codigo  	= '507';
		SET vou_mensaje 	= CONCAT('La categoria usada para el articulo no es valida (', vin_art_categoria , ')');
	END IF;
  END //

 CREATE PROCEDURE smpos_prc_iniciar_sesion(
	IN 		vin_usu_alias 				VARCHAR(25),
	IN 		vin_usu_clave 				VARCHAR(255),
	IN		vin_duracion				INT(11),
	OUT 	vou_token					TEXT,
   	OUT 	vou_codigo 	 				CHAR(5),
	OUT 	vou_mensaje					TEXT)
  BEGIN
	DECLARE CODENTID_ACTIVO 		INT(11)		DEFAULT 0;
	DECLARE DATUSUAR_ESTADO			INT(11)		DEFAULT 0;
	DECLARE DATUSUAR_CODIGO			INT(11)		DEFAULT 0;
	DECLARE PASUSUAR_CLAVE			TEXT		DEFAULT '';
	DECLARE CODSALID_ESTADO			CHAR(5)		DEFAULT '00000';
	DECLARE MSGSALID_ESTADO			TEXT		DEFAULT '';
	DECLARE CODTOKEN_ACCESO			TEXT		DEFAULT NULL;
	DECLARE FECINI_ACCESO			DATETIME	DEFAULT NULL;
	DECLARE FECFIN_ACCESO			DATETIME	DEFAULT NULL;
	DECLARE CANTAC_INGRESAD			INT(11)		DEFAULT 0;
	DECLARE CODACCES_ESACTI			INT(11)		DEFAULT 0;
	DECLARE CODACCES_ESCADU			INT(11)		DEFAULT 0;

	DECLARE CONTINUE HANDLER FOR NOT FOUND 
		BEGIN 
			SET CODSALID_ESTADO = '402'; 
        	SET MSGSALID_ESTADO = 'Usuario o clave no valido';
		END;
 	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
 		BEGIN
 			GET DIAGNOSTICS CONDITION 1
        		CODSALID_ESTADO = RETURNED_SQLSTATE, 
        		MSGSALID_ESTADO = MESSAGE_TEXT;
    	END;

	SET CODENTID_ACTIVO		= smpos_fnc_obtener_categ_codigo('ENTIDAD.ESTADO.ACTIVO');
	SET CODACCES_ESACTI		= smpos_fnc_obtener_categ_codigo('ACCESO.ESTADO.ACTIVO');
	SET CODACCES_ESCADU		= smpos_fnc_obtener_categ_codigo('ACCESO.ESTADO.CADUCADO');
	SET @enabled			= FALSE;
	-- Linea para depurar procedimiento --
	call debug_msg(@enabled, CONCAT('Entidad (', CODENTID_ACTIVO, ')'));
	-- Condicion para validar si tiene los argumentos necesarios para realizar el proceso --
	IF 	vin_usu_alias IS NOT NULL AND vin_usu_clave IS NOT NULL THEN
		-- Linea para depurar procedimiento --
		call debug_msg(@enabled, 'Procedemos a validar informacion usuario...');
		-- Consulta para validar la existencia del usuario --
		SELECT 	u.usu_codigo, 	 u.usu_clave, 	 u.usu_estado
		INTO	DATUSUAR_CODIGO, PASUSUAR_CLAVE, DATUSUAR_ESTADO
		FROM	smpos_sis_usuarios u
		WHERE 	u.usu_alias = vin_usu_alias;
		-- Linea para depurar procedimiento --
		call debug_msg(@enabled, CONCAT('Resultado-Usuario (', DATUSUAR_CODIGO, '-', CODSALID_ESTADO, ')')); 
		-- Valida si el estado de todo este proceso es exitoso --
 		IF	STRCMP(CODSALID_ESTADO, '00000') = 0 THEN 
 			-- Si corresponde la clave ingresada y si el estado del usuario es el indicado --
			IF	PASUSUAR_CLAVE	= PASSWORD(vin_usu_clave) AND DATUSUAR_ESTADO = CODENTID_ACTIVO THEN 
				-- Linea para depurar procedimiento --
				call debug_msg(@enabled, 'Asignando parametros acceso..');
				-- Asigna los valores requeridos para realizar el inicio de sesion --
				SET FECINI_ACCESO 	= NOW();
				SET FECFIN_ACCESO	= DATE_ADD(FECINI_ACCESO, INTERVAL vin_duracion MINUTE);
				-- Primero debemos buscar si hay una sesion para este usuario activa --
			 	SELECT 	IF(COUNT(a.acc_token) > 0, a.acc_token, NULL) INTO CODTOKEN_ACCESO
			 	FROM 	smpos_sis_accesos a
			 	WHERE 	a.acc_usuario = DATUSUAR_CODIGO
			 	AND 	FECINI_ACCESO BETWEEN a.acc_fecha_inicio AND a.acc_fecha_fin;
			 	-- Linea para depurar procedimiento --
				call debug_msg(@enabled, CONCAT('Token leido (', IFNULL(CODTOKEN_ACCESO, ''), ')'));
				-- Verifica si efectivamente lo encontro --
				IF 	CODTOKEN_ACCESO IS NOT NULL THEN 
					SET vou_token	= CODTOKEN_ACCESO;
					SET vou_codigo  = '200';
					SET vou_mensaje = 'OK';
				ELSE 
					SET CODTOKEN_ACCESO	= LEFT(UUID(), 20);
					-- Inserta el nuevo acceso --
					INSERT INTO smpos_sis_accesos 
							(acc_token,     acc_usuario,  acc_fecha_inicio, 
							 acc_fecha_fin, acc_duracion, acc_estado) 
					VALUES 	(CODTOKEN_ACCESO, DATUSUAR_CODIGO, FECINI_ACCESO, 
					         FECFIN_ACCESO,   vin_duracion,    CODACCES_ESACTI);
					-- Asigna la cantidad de accesos registrados --
					SET CANTAC_INGRESAD	= ROW_COUNT();
					-- Actualizar todos los accesos del usuario que esten activos --
					-- y que no tengan el token que acabamos de crear --
					UPDATE 	smpos_sis_accesos 
					SET		acc_fecha_fin	=  FECINI_ACCESO, 
							acc_estado		=  CODACCES_ESCADU
					WHERE 	acc_token		<> CODTOKEN_ACCESO
					AND 	acc_estado 		=  CODACCES_ESACTI;
					-- Valida si inserto la informacion --
					IF 	CANTAC_INGRESAD > 0 THEN
						SET vou_token	= CODTOKEN_ACCESO;
						SET vou_codigo  = '200';
						SET vou_mensaje = 'OK';
					ELSE 
						SET vou_token	= '';
						SET vou_codigo  = CODSALID_ESTADO;
						SET vou_mensaje = MSGSALID_ESTADO;						
					END IF;
				END IF;
			ELSEIF DATUSUAR_ESTADO != CODENTID_ACTIVO THEN
				SET vou_token	= '';
				SET vou_codigo  = '401';
				SET vou_mensaje = 'El estado del usuario no es valido';
			ELSE 
				SET vou_token	= '';
				SET vou_codigo  = '401';
				SET vou_mensaje = 'El usuario o la clave son invalidas';
			END IF;
 		ELSE 
			SET vou_token	= '';
			SET vou_codigo  = CODSALID_ESTADO;
			SET vou_mensaje = MSGSALID_ESTADO;
 		END IF;
	ELSE 
		SET vou_token		= '';
		SET vou_codigo  	= '501';
		SET vou_mensaje 	= 'Debe especificar usuario y clave';
	END IF;
  END //
  
 CREATE PROCEDURE smpos_prc_verificar_sesion(
 	IN 		vin_token					TEXT,
 	OUT		vou_feini_acceso			DATETIME,
 	OUT 	vou_fefin_acceso			DATETIME,
 	OUT		vou_nrmdu_acceso			INT(11),
 	OUT		vou_codus_acceso			INT(11),
   	OUT 	vou_codigo 	 				CHAR(5),
	OUT 	vou_mensaje					TEXT)
  BEGIN
	DECLARE CODACCES_ESACTI			INT(11)		DEFAULT 0;
	DECLARE CODACCES_ESFINA			INT(11)		DEFAULT 0;
	DECLARE CODACCES_ESCADU			INT(11)		DEFAULT 0;
	DECLARE CODUSUAR_ACCESO			INT(11)		DEFAULT 0;
	DECLARE NMRDURAC_ACCESO			INT(11)		DEFAULT 0;
	DECLARE CODESTAD_ACCESO			INT(11)		DEFAULT 0;
	DECLARE FECINI_ACCESO			DATETIME	DEFAULT NULL;
	DECLARE FECFIN_ACCESO			DATETIME	DEFAULT NULL;
	DECLARE FECACT_ACCESO			DATETIME	DEFAULT NULL;
	DECLARE CODSALID_ESTADO			CHAR(5)		DEFAULT '00000';
	DECLARE MSGSALID_ESTADO			TEXT		DEFAULT '';
	
	DECLARE CONTINUE HANDLER FOR NOT FOUND 
		BEGIN 
			SET CODSALID_ESTADO = '402'; 
        	SET MSGSALID_ESTADO = 'Sesion no encontrada';
		END;

	SET CODACCES_ESACTI		= smpos_fnc_obtener_categ_codigo('ACCESO.ESTADO.ACTIVO');
	SET CODACCES_ESCADU		= smpos_fnc_obtener_categ_codigo('ACCESO.ESTADO.CADUCADO');
	SET CODACCES_ESFINA		= smpos_fnc_obtener_categ_codigo('ACCESO.ESTADO.FINALIZADO');
	SET FECACT_ACCESO		= NOW();
	SET @enabled			= FALSE;
 	
 	-- Linea para depurar procedimiento --
	call debug_msg(@enabled, CONCAT('Token leido (', IFNULL(vin_token, ''), ')'));
	-- Validamos si el token esta especificado --
	IF 	vin_token IS NOT NULL THEN 
	 	-- Linea para depurar procedimiento --
		call debug_msg(@enabled, 'Procedemos a buscar info del acceso...');
		-- Ubicamos el token del acceso a finalizar --
		SELECT 	a.acc_usuario,   a.acc_fecha_inicio, a.acc_fecha_fin, a.acc_duracion,  a.acc_estado
		INTO 	CODUSUAR_ACCESO, FECINI_ACCESO,		 FECFIN_ACCESO,   NMRDURAC_ACCESO, CODESTAD_ACCESO
		FROM 	smpos_sis_accesos a
		WHERE 	a.acc_token		= vin_token
		AND 	a.acc_estado	= CODACCES_ESACTI;
	 	-- Linea para depurar procedimiento --
		call debug_msg(@enabled, CONCAT('Consulta realizada (', CODSALID_ESTADO, ')'));
		-- Valida si este bloque se ejecuto exitosamente --
		IF	STRCMP(CODSALID_ESTADO, '00000') = 0 THEN
			-- Establecer que estado deberia aplicar a esta sesion --
			IF	FECACT_ACCESO > FECFIN_ACCESO THEN 
				SET CODESTAD_ACCESO	= CODACCES_ESCADU;
			END IF;
		 	-- Linea para depurar procedimiento --
			call debug_msg(@enabled, CONCAT('Verificando la sesion (', CODESTAD_ACCESO, ')'));
			-- Valida si el estado esta activo --
			IF	CODESTAD_ACCESO = CODACCES_ESACTI THEN 
 				SET vou_feini_acceso	= FECINI_ACCESO;
 				SET vou_fefin_acceso	= FECFIN_ACCESO;
 				SET vou_nrmdu_acceso	= NMRDURAC_ACCESO;
 				SET vou_codus_acceso	= CODUSUAR_ACCESO;
				SET vou_codigo  		= '200';
				SET vou_mensaje 		= 'Sesion activa';
			ELSE 
 				SET vou_feini_acceso	= FECINI_ACCESO;
 				SET vou_fefin_acceso	= FECFIN_ACCESO;
 				SET vou_nrmdu_acceso	= NMRDURAC_ACCESO;
 				SET vou_codus_acceso	= CODUSUAR_ACCESO;
				SET vou_codigo  		= '501';
				SET vou_mensaje 		= 'Sesion ha caducado';
			END IF;
		ELSE 
			SET vou_feini_acceso		= NULL;
			SET vou_fefin_acceso		= NULL;
			SET vou_nrmdu_acceso		= 0;
			SET vou_codus_acceso		= 0;
			SET vou_codigo  			= CODSALID_ESTADO;
			SET vou_mensaje 			= MSGSALID_ESTADO;
		END IF;
	END IF;
  END //

 CREATE PROCEDURE smpos_prc_finalizar_sesion(
 	IN 		vin_token					TEXT,
   	OUT 	vou_codigo 	 				CHAR(5),
	OUT 	vou_mensaje					TEXT)
  BEGIN
	DECLARE CODACCES_ESACTI			INT(11)		DEFAULT 0;
	DECLARE CODACCES_ESFINA			INT(11)		DEFAULT 0;
	DECLARE CODACCES_ESCADU			INT(11)		DEFAULT 0;
	DECLARE CODUSUAR_ACCESO			INT(11)		DEFAULT 0;
	DECLARE NMRDURAC_ACCESO			INT(11)		DEFAULT 0;
	DECLARE CODESTAD_ACCESO			INT(11)		DEFAULT 0;
	DECLARE FECINI_ACCESO			DATETIME	DEFAULT NULL;
	DECLARE FECFIN_ACCESO			DATETIME	DEFAULT NULL;
	DECLARE FECACT_ACCESO			DATETIME	DEFAULT NULL;
	DECLARE CODSALID_ESTADO			CHAR(5)		DEFAULT '00000';
	DECLARE MSGSALID_ESTADO			TEXT		DEFAULT '';
	
	DECLARE CONTINUE HANDLER FOR NOT FOUND 
		BEGIN 
			SET CODSALID_ESTADO = '402'; 
        	SET MSGSALID_ESTADO = 'Sesion no encontrada';
		END;

	SET CODACCES_ESACTI		= smpos_fnc_obtener_categ_codigo('ACCESO.ESTADO.ACTIVO');
	SET CODACCES_ESCADU		= smpos_fnc_obtener_categ_codigo('ACCESO.ESTADO.CADUCADO');
	SET CODACCES_ESFINA		= smpos_fnc_obtener_categ_codigo('ACCESO.ESTADO.FINALIZADO');
	SET FECACT_ACCESO		= NOW();
	SET @enabled			= FALSE;
 	-- Linea para depurar procedimiento --
	call debug_msg(@enabled, CONCAT('Token leido (', IFNULL(vin_token, ''), ')'));
	-- Validamos si el token esta especificado --
	IF 	vin_token IS NOT NULL THEN 
	 	-- Linea para depurar procedimiento --
		call debug_msg(@enabled, 'Procedemos a buscar info del acceso...');
		-- Ubicamos el token del acceso a finalizar --
		SELECT 	a.acc_usuario,   a.acc_fecha_inicio, a.acc_fecha_fin, a.acc_duracion
		INTO 	CODUSUAR_ACCESO, FECINI_ACCESO,		 FECFIN_ACCESO,   NMRDURAC_ACCESO
		FROM 	smpos_sis_accesos a
		WHERE 	a.acc_token		= vin_token
		AND 	a.acc_estado	= CODACCES_ESACTI;
	 	-- Linea para depurar procedimiento --
		call debug_msg(@enabled, CONCAT('Consulta realizada (', CODSALID_ESTADO, ')'));
		-- Valida si este bloque se ejecuto exitosamente --
		IF	STRCMP(CODSALID_ESTADO, '00000') = 0 THEN 
			-- Establecer que estado deberia aplicar a esta sesion --
			IF	FECACT_ACCESO > FECFIN_ACCESO THEN 
				SET CODESTAD_ACCESO	= CODACCES_ESCADU;
			ELSE
				SET CODESTAD_ACCESO	= CODACCES_ESFINA;
				SET NMRDURAC_ACCESO	= TIMESTAMPDIFF(MINUTE, FECINI_ACCESO, FECACT_ACCESO)%60;
			END IF;
		 	-- Linea para depurar procedimiento --
			call debug_msg(@enabled, CONCAT('Preparando datos para actualizar (', CODESTAD_ACCESO, ')'));
			-- Se procede a actualizar el acceso --
			UPDATE 	smpos_sis_accesos 
			SET		acc_fecha_fin	=  FECACT_ACCESO, 
					acc_estado		=  CODESTAD_ACCESO,
					acc_duracion	=  NMRDURAC_ACCESO
			WHERE 	acc_token		=  vin_token
			AND 	acc_estado 		=  CODACCES_ESACTI;
			-- Validamos si actualizo registros --
			IF 	ROW_COUNT() > 0 THEN
			 	-- Linea para depurar procedimiento --
				call debug_msg(@enabled, CONCAT('Actualizacion realizada (', ROW_COUNT(), ')'));
				-- Estableciendo final de la sesion --
				SET vou_codigo  = '200';
				SET vou_mensaje = 'Sesion finalizada';
			ELSE 
			 	-- Linea para depurar procedimiento --
				call debug_msg(@enabled, 'No logro actualizar datos');
				-- Estableciendo final de la sesion --
				SET vou_codigo  = '200';
				SET vou_mensaje = 'Sin datos actualizados';
			END IF;
		ELSE 
			SET vou_codigo  = CODSALID_ESTADO;
			SET vou_mensaje = MSGSALID_ESTADO;
		END IF;
	ELSE 
		SET vou_codigo  = '500';
		SET vou_mensaje = 'Debe especificar el token';
	END IF;
  END //

  CREATE PROCEDURE smpos_prc_obtener_menu(
 	IN 		vin_token					TEXT,
 	OUT 	vou_textResultSet			TEXT,
   	OUT 	vou_codigo 	 				CHAR(5),
	OUT 	vou_mensaje					TEXT)
  BEGIN
	DECLARE CODSALID_ESTADO			CHAR(5)			DEFAULT '00000';
	DECLARE MSGSALID_ESTADO			TEXT			DEFAULT '';
	DECLARE NMRDURAC_ACCESO			INT(11)			DEFAULT 0;
	DECLARE CODACCES_USUARI			INT(11)			DEFAULT 0;
	DECLARE FECINI_ACCESO			DATETIME		DEFAULT NULL;
	DECLARE FECFIN_ACCESO			DATETIME		DEFAULT NULL;
	DECLARE RESSET_MENUOPTS			TEXT 			DEFAULT '';
  	DECLARE CURSOR_DONE 			INT 			DEFAULT FALSE;
  
	DECLARE OPC_CODIGO				INT(11)			DEFAULT 0;
	DECLARE OPC_NOMBRE				VARCHAR(90)		DEFAULT NULL;
	DECLARE OPC_TITULO				VARCHAR(255)	DEFAULT NULL;
	DECLARE OPC_ABREVI				VARCHAR(200)	DEFAULT NULL;
	DECLARE OPC_DESCRI				TEXT			DEFAULT NULL;
	DECLARE OPC_RUTAUR				TEXT			DEFAULT NULL;
	DECLARE OPC_PRINCI				INT(11)			DEFAULT 0;
	DECLARE OPC_ORDEN				INT(11)			DEFAULT 0;
	DECLARE OPC_ESTADO				INT(11)			DEFAULT 0;
	
	DECLARE cur_menus 				CURSOR FOR 
		SELECT opc.opc_codigo, 		opc.opc_nombre,
			   opc.opc_titulo,		opc.opc_abreviatura,
			   opc.opc_descripcion,	opc.opc_ruta,
			   opc.opc_principal,	opc.opc_orden,
			   opc.opc_estado 	 
		FROM   smpos_sis_accesos acc,
			   smpos_sis_usuarios_x_roles uxr,
			   smpos_sis_roles_x_perfiles rxp,
			   smpos_men_opciones_x_perfiles oxp,
			   smpos_men_opciones opc
		WHERE  acc.acc_usuario = uxr.uxr_usuario
		AND    uxr.uxr_rol     = rxp.rxp_rol 
		AND    oxp.oxp_perfil  = rxp.rxp_perfil
		AND    opc.opc_codigo  = oxp.oxp_opcion
		AND    acc.acc_token   = vin_token
		ORDER BY opc.opc_orden ASC;
	
	DECLARE CONTINUE HANDLER FOR NOT FOUND 
		SET CURSOR_DONE = TRUE;
	
	SET @enabled	= FALSE;
 	-- Linea para depurar procedimiento --
	call debug_msg(@enabled, CONCAT('Token leido (', IFNULL(vin_token, ''), ')'));
	-- Validamos si el token esta especificado --
	IF 	vin_token IS NOT NULL THEN 
	 	-- Linea para depurar procedimiento --
		call debug_msg(@enabled, 'Validar si el acceso existe...');
		-- Verifica si el acceso es valido --
		CALL smpos_prc_verificar_sesion(
		 	vin_token,       FECINI_ACCESO,
		 	FECFIN_ACCESO,   NMRDURAC_ACCESO,
		 	CODACCES_USUARI, CODSALID_ESTADO,
			MSGSALID_ESTADO);
	 	-- Linea para depurar procedimiento --
		call debug_msg(@enabled, CONCAT('Validacion realizada (', CODSALID_ESTADO, ')'));
		-- Verifica respuesta del procedimiento --
		IF	STRCMP(CODSALID_ESTADO, '200') = 0 THEN 
			-- Se procede a entregar el menu para este usuario --
			OPEN  cur_menus;
				read_loop: LOOP
					-- Lee un registro del cursor --
					FETCH cur_menus INTO OPC_CODIGO, OPC_NOMBRE, OPC_TITULO, 
										 OPC_ABREVI, OPC_DESCRI, OPC_RUTAUR,
										 OPC_PRINCI, OPC_ORDEN,  OPC_ESTADO;
					-- Determina si continua el loop --
				    IF 	CURSOR_DONE THEN
				      	LEAVE read_loop;
				    END IF;
					-- Construye la salida parcial --
					SET RESSET_MENUOPTS	= CONCAT(
						RESSET_MENUOPTS,
						'	<row>',
						'		<field name="opc_codigo">', OPC_CODIGO, '</field>',
						'		<field name="opc_nombre">', OPC_NOMBRE, '</field>',
						'		<field name="opc_titulo">', OPC_TITULO, '</field>',
						'		<field name="opc_abreviatura">', OPC_ABREVI, '</field>',
						'		<field name="opc_descripcion">', OPC_DESCRI, '</field>',
						'		<field name="opc_ruta">', OPC_RUTAUR, '</field>',
						'		<field name="opc_principal">', OPC_PRINCI, '</field>',
						'		<field name="opc_orden">', OPC_ORDEN, '</field>',
						'		<field name="opc_estado">', OPC_ESTADO, '</field>',
						'	</row>');
				END LOOP;
			CLOSE cur_menus;
			-- 	Verifica la salida si se puede entregar --
			IF	RESSET_MENUOPTS IS NOT NULL AND RESSET_MENUOPTS <> '' THEN
				-- 	Valida si quedo con informacion para entregar la salida --
				SET vou_textResultSet 	= CONCAT(
					'<?xml version="1.0" encoding="UTF-8"?>',
					'<rows>', RESSET_MENUOPTS, '</rows>');
				-- Salida cuando hay error --
				SET vou_codigo  		= '200';
				SET vou_mensaje 		= 'Carga de menu exitosa';
			ELSE 
				SET vou_textResultSet 	= NULL;
				SET vou_codigo  		= '402';
				SET vou_mensaje 		= 'No hay opciones en el menu parametrizadas';
			END IF;
		ELSE 
			-- Salida cuando hay error --
			SET vou_codigo  = CODSALID_ESTADO;
			SET vou_mensaje = MSGSALID_ESTADO;
		END IF;
	ELSE 
		SET vou_codigo  	= '600';
		SET vou_mensaje 	= 'Debe especificar el token';
	END IF;
  END //

  CREATE PROCEDURE smpos_prc_verificar_perfil(
 	IN 		vin_token					TEXT,
 	IN 		vin_abbr_perfil				VARCHAR(200),
 	OUT 	vou_usuario					INT(11),
   	OUT 	vou_codigo 	 				CHAR(5),
	OUT 	vou_mensaje					TEXT)
  BEGIN
	DECLARE CODSALID_ESTADO			CHAR(5)			DEFAULT '00000';
	DECLARE MSGSALID_ESTADO			TEXT			DEFAULT '';
	DECLARE NMRDURAC_ACCESO			INT(11)			DEFAULT 0;
	DECLARE CODACCES_USUARI			INT(11)			DEFAULT 0;
	DECLARE NMPERFIL_USUARI			INT(11)			DEFAULT 0;
	DECLARE FECINI_ACCESO			DATETIME		DEFAULT NULL;
	DECLARE FECFIN_ACCESO			DATETIME		DEFAULT NULL;

	SET @enabled	= FALSE;
 	-- Linea para depurar procedimiento --
	call debug_msg(@enabled, CONCAT('Token leido (', IFNULL(vin_token, ''), ')'));
	-- Validamos si el token esta especificado --
	IF 	vin_token IS NOT NULL THEN
	 	-- Linea para depurar procedimiento --
		call debug_msg(@enabled, 'Validar si el acceso existe...');
		-- Verifica si el acceso es valido --
		CALL smpos_prc_verificar_sesion(
		 	vin_token,       FECINI_ACCESO,
		 	FECFIN_ACCESO,   NMRDURAC_ACCESO,
		 	CODACCES_USUARI, CODSALID_ESTADO,
			MSGSALID_ESTADO);
	 	-- Linea para depurar procedimiento --
		call debug_msg(@enabled, CONCAT('Validacion realizada (', CODSALID_ESTADO, ')'));
		-- Verifica respuesta del procedimiento --
		IF	STRCMP(CODSALID_ESTADO, '200') = 0 THEN
			-- Se procede a validar si el usuario posee dicho perfil --
			SELECT 	COUNT(uxr.uxr_rol) INTO NMPERFIL_USUARI
			FROM 	smpos_sis_usuarios_x_roles uxr, 
					smpos_sis_roles_x_perfiles rxp, 
					smpos_sis_perfiles         per
			WHERE 	uxr.uxr_rol				=	rxp.rxp_rol
			AND 	rxp.rxp_perfil			=	per.per_codigo
			AND 	uxr.uxr_usuario			=	CODACCES_USUARI
			AND 	per.per_abbreviatura	=	vin_abbr_perfil;
			-- Valida si existe el perfil para este usuario --
			IF	NMPERFIL_USUARI > 0 THEN
				SET vou_usuario = CODACCES_USUARI;
				SET vou_codigo  = '200';
				SET vou_mensaje = 'El usuario tiene asignado el perfil';
			ELSE 
				SET vou_usuario = 0;
				SET vou_codigo  = '402';
				SET vou_mensaje = CONCAT('El perfil (', vin_abbr_perfil, ') no lo tiene asignado este usuario');
			END IF;
		ELSE 
			-- Salida cuando hay error --
			SET vou_usuario = 0;
			SET vou_codigo  = CODSALID_ESTADO;
			SET vou_mensaje = MSGSALID_ESTADO;
		END IF;
	ELSE 
		SET vou_usuario 	= 0;
		SET vou_codigo  	= '600';
		SET vou_mensaje 	= 'Debe especificar el token';
	END IF;
  END //
  
  CREATE PROCEDURE smpos_prc_obtener_categorias(
 	IN 		vin_cod_categoria			INT(11),
 	IN 		vin_abbr_categoria			VARCHAR(200),
 	OUT 	vou_textResultSet			TEXT,
   	OUT 	vou_codigo 	 				CHAR(5),
	OUT 	vou_mensaje					TEXT)
  BEGIN 
	DECLARE CODSALID_ESTADO			CHAR(5)			DEFAULT '00000';
	DECLARE MSGSALID_ESTADO			TEXT			DEFAULT '';
	DECLARE RESSET_CATEOPTS			TEXT 			DEFAULT '';
  	DECLARE CURSOR_DONE 			INT 			DEFAULT FALSE;
  	DECLARE CAT_FILT_BUSQUE			INT(11)			DEFAULT 0;
  	
	DECLARE CAT_CODIGO				INT(11)			DEFAULT 0;
	DECLARE CAT_ABREVI				VARCHAR(200)	DEFAULT NULL;
	DECLARE CAT_DESCRI				TEXT			DEFAULT NULL;
	DECLARE CAT_PRINCI				INT(11)			DEFAULT 0;
	DECLARE CAT_ESTADO				INT(11)			DEFAULT 0;

	DECLARE cur_categorias 			CURSOR FOR 
		SELECT cc.cat_codigo
		     , cc.cat_abbreviatura
			 , cc.cat_descripcion
			 , cc.cat_estado
			 , IFNULL(cc.cat_principal, 0) cat_principal 
		FROM   smpos_sis_categorias cc 
		WHERE  cc.cat_codigo    = IFNULL(@CATEG_CODIGO, @CAT_FILTRO)
        UNION ALL
		SELECT cc.cat_codigo
		     , cc.cat_abbreviatura
			 , cc.cat_descripcion
			 , cc.cat_estado
			 , @CATEG_CODIGO   := IFNULL(cc.cat_principal, 0) 
		FROM   smpos_sis_categorias cc 
		WHERE  cc.cat_principal = IFNULL(@CATEG_CODIGO, @CAT_FILTRO);
	
	DECLARE CONTINUE HANDLER FOR NOT FOUND 
		SET CURSOR_DONE = TRUE;
		
    -- Flag para activar debug del procedimiento --
	SET @enabled	= FALSE;
 	-- Linea para depurar procedimiento --
	call debug_msg(@enabled, CONCAT('Categoria a buscar (', IFNULL(vin_cod_categoria, ''), '-', IFNULL(vin_abbr_categoria, ''), ')'));
	-- Verificar que uno de los dos parametros contenga informacion --
	IF	vin_cod_categoria IS NOT NULL OR vin_abbr_categoria IS NOT NULL THEN 
		-- Procede a buscar la categoria a extraer --
	 	SELECT 	IF(COUNT(a.cat_codigo) > 0, a.cat_codigo, 0) INTO CAT_FILT_BUSQUE
	 	FROM 	smpos_sis_categorias a
	 	WHERE 	IF(vin_cod_categoria  IS NULL,  1 , a.cat_codigo)       = IFNULL(vin_cod_categoria  , 1)
	 	AND 	IF(vin_abbr_categoria IS NULL, '1', a.cat_abbreviatura) = IFNULL(vin_abbr_categoria , '1');
	 	-- Linea para depurar procedimiento --
		call debug_msg(@enabled, CONCAT('Categoria real a buscar (', CAT_FILT_BUSQUE, ')'));
		-- Se procede a verificar si realmente existe la categoria --
		IF 	CAT_FILT_BUSQUE > 0 THEN
		    -- Asigna la informacion a la variable --
		    SET @CAT_FILTRO  = CAT_FILT_BUSQUE;
		 	-- Linea para depurar procedimiento --
			call debug_msg(@enabled, CONCAT('Categoria filtro de busqueda (', @CAT_FILTRO, ')'));
			-- Se procede a entregar las categorias para esta consulta --
			OPEN  cur_categorias;
				read_loop: LOOP
					-- Lee un registro del cursor --
					FETCH cur_categorias INTO CAT_CODIGO, CAT_ABREVI, CAT_DESCRI, 
										 	  CAT_ESTADO, CAT_PRINCI;
					-- Determina si continua el loop --
				    IF 	CURSOR_DONE THEN
					 	-- Linea para depurar procedimiento --
						call debug_msg(@enabled, CONCAT('Termino el cursor (', CURSOR_DONE, ')'));
				      	-- Abandone el cursor --
				      	LEAVE read_loop;
				    END IF;
					-- Construye la salida parcial --
					SET RESSET_CATEOPTS	= CONCAT(
						RESSET_CATEOPTS,
						'	<row>',
						'		<field name="cat_codigo">', CAT_CODIGO, '</field>',
						'		<field name="cat_abbreviatura">', CAT_ABREVI, '</field>',
						'		<field name="cat_descripcion">', CAT_DESCRI, '</field>',
						'		<field name="cat_principal">', CAT_PRINCI, '</field>',
						'		<field name="cat_estado">', CAT_ESTADO, '</field>',
						'	</row>');
				END LOOP;
			CLOSE cur_categorias;
			-- 	Verifica la salida si se puede entregar --
			IF	RESSET_CATEOPTS IS NOT NULL AND RESSET_CATEOPTS <> '' THEN
				-- 	Valida si quedo con informacion para entregar la salida --
				SET vou_textResultSet 	= CONCAT(
					'<?xml version="1.0" encoding="UTF-8"?>',
					'<rows>', RESSET_CATEOPTS, '</rows>');
				-- Salida cuando hay error --
				SET vou_codigo  		= '200';
				SET vou_mensaje 		= 'Carga de categorias de manera exitosa';
			ELSE 
				SET vou_textResultSet 	= NULL;
				SET vou_codigo  		= '402';
				SET vou_mensaje 		= 'No hay categorias parametrizadas';
			END IF;
		ELSE 
			SET vou_textResultSet 	= NULL;
			SET vou_codigo  		= '402';
			SET vou_mensaje 		= 'Categoria no existe';
		END IF;
	ELSE 
		SET vou_textResultSet 		= NULL;
		SET vou_codigo  			= '402';
		SET vou_mensaje 			= 'Debe especificar el codigo o abreviatura de la categoria';
	END IF;
  END //

 DELIMITER $$;