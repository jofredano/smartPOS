DROP FUNCTION IF EXISTS smpos_fnc_obtener_categ_codigo;
DROP FUNCTION IF EXISTS smpos_fnc_obtener_consec_rango_codigo;

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


