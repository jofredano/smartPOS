DROP FUNCTION IF EXISTS smpos_fnc_obtener_categ_codigo;
DROP FUNCTION IF EXISTS smpos_fnc_obtener_categ_princip;
DROP FUNCTION IF EXISTS smpos_fnc_obtener_consec_rango_codigo;
DROP FUNCTION IF EXISTS smpos_fnc_obtener_rol_codigo;
DROP FUNCTION IF EXISTS smpos_fnc_obtener_prove_identificacion;
DROP FUNCTION IF EXISTS smpos_fnc_obtener_marca_codigo;
DROP FUNCTION IF EXISTS smpos_fnc_split_string;

DELIMITER $$
 
CREATE FUNCTION smpos_fnc_obtener_categ_codigo(
	categoria_abbr 				VARCHAR(200)) 
 RETURNS INT(11)
    DETERMINISTIC
 BEGIN
    DECLARE result INT(11);
 	SELECT 	IF(COUNT(c.cat_codigo) > 0, c.cat_codigo, 0) INTO result
 	FROM 	smpos_sis_categorias c
 	WHERE 	c.cat_abbreviatura = categoria_abbr;
 RETURN (result);
END$$

DELIMITER $$
 
CREATE FUNCTION smpos_fnc_obtener_categ_princip(
	categoria_abbr 				VARCHAR(200),
	categ_pri_abbr 				VARCHAR(200)) 
 RETURNS INT(11)
    DETERMINISTIC
 BEGIN
    DECLARE result INT(11);
 	SELECT 	IF(COUNT(c.cat_codigo) > 0, c.cat_codigo, 0) INTO result
 	FROM 	smpos_sis_categorias c, 
 			smpos_sis_categorias p
 	WHERE 	c.cat_principal		= p.cat_codigo
 	AND		c.cat_abbreviatura 	= categoria_abbr
 	AND 	p.cat_abbreviatura	= categ_pri_abbr;
 RETURN (result);
END$$

DELIMITER $$

CREATE FUNCTION smpos_fnc_obtener_consec_rango_codigo(
    vin_resolucion	VARCHAR(255)) 
 RETURNS INT(11)
    DETERMINISTIC
 BEGIN
    DECLARE result INT(11);
 	SELECT 	IF(COUNT(c.con_codigo) > 0, c.con_codigo, 0) INTO result
 	FROM 	smpos_csc_rangos c
 	WHERE 	c.con_codigo_resolucion = vin_resolucion;
 RETURN (result);
END$$

DELIMITER $$

CREATE FUNCTION smpos_fnc_obtener_rol_codigo(
    abbr_rol	VARCHAR(200)) 
 RETURNS INT(11)
    DETERMINISTIC
 BEGIN
    DECLARE result INT(11);
 	SELECT 	IF(COUNT(c.rol_codigo) > 0, c.rol_codigo, 0) INTO result
 	FROM 	smpos_sis_roles c
 	WHERE 	c.rol_abbreviatura = abbr_rol;
 RETURN (result);
END$$


DELIMITER $$

CREATE FUNCTION smpos_fnc_obtener_prove_identificacion(
    vin_identificacion	VARCHAR(25)) 
 RETURNS INT(11)
    DETERMINISTIC
 BEGIN
    DECLARE result INT(11);
 	SELECT 	IF(COUNT(e.rol_codigo) > 0, e.rol_codigo, 0) INTO result
	FROM 	smpos_con_entidades e, 
			smpos_con_proveedores p
	WHERE 	p.pro_entidad		 = e.ent_codigo
	AND 	e.ent_identificacion = vin_identificacion;
 RETURN (result);
END$$


DELIMITER $$

CREATE FUNCTION smpos_fnc_obtener_marca_codigo(
    abbr_marca	VARCHAR(200)) 
 RETURNS INT(11)
    DETERMINISTIC
 BEGIN
    DECLARE result INT(11);
 	SELECT 	IF(COUNT(c.mar_codigo) > 0, c.mar_codigo, 0) INTO result
 	FROM 	smpos_inv_marcas c
 	WHERE 	c.mar_abbreviatura = abbr_marca;
 RETURN (result);
END$$


DELIMITER $$

CREATE FUNCTION smpos_fnc_split_string (
	in_text			TEXT, 
	in_separator 	CHAR(1), 
	in_index 		INT(11)) 
 RETURNS VARCHAR(1024)
 	DETERMINISTIC 
 BEGIN
    DECLARE n INT ;
    -- obtiene el numero maximo de elementos --
	SET n = LENGTH(in_text) - LENGTH(REPLACE(in_text, in_separator, '')) + 1;
    -- si el argumento es mayor que la cantidad maxima de elementos --
	IF in_index > n THEN
        RETURN NULL;
	-- de lo contrario --
    ELSE
        RETURN SUBSTRING_INDEX(SUBSTRING_INDEX(in_text, in_separator, in_index) , in_separator , -1 );        
    END IF;
END$$

