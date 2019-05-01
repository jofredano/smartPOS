INSERT INTO smpos_sis_categorias (cat_codigo, cat_abbreviatura, cat_descripcion, cat_estado, cat_principal)
	VALUES (1, 'ENTIDAD.ESTADO', 'Estado de una entidad', 1, NULL);
INSERT INTO smpos_sis_categorias (cat_codigo, cat_abbreviatura, cat_descripcion, cat_estado, cat_principal)
	VALUES (2, 'ENTIDAD.ESTADO.ACTIVO', 'Estado activo de una entidad', 1, 1); 
INSERT INTO smpos_sis_categorias (cat_codigo, cat_abbreviatura, cat_descripcion, cat_estado, cat_principal)
	VALUES (3, 'PERSONA.TIPO', 'Tipos de persona', 2, NULL); 
INSERT INTO smpos_sis_categorias (cat_codigo, cat_abbreviatura, cat_descripcion, cat_estado, cat_principal)
	VALUES (4, 'PERSONA.TIPO.NATURAL', 'Persona Natural', 2, 3); 
INSERT INTO smpos_sis_categorias (cat_codigo, cat_abbreviatura, cat_descripcion, cat_estado, cat_principal)
	VALUES (5, 'PERSONA.TIPO.JURIDICA', 'Persona Juridica', 2, 3); 
INSERT INTO smpos_sis_categorias (cat_codigo, cat_abbreviatura, cat_descripcion, cat_estado, cat_principal)
	VALUES (6, 'CONSECUTIVO.RANGO.ESTADO', 'Estados de rangos (consecutivo)', 2, NULL); 
INSERT INTO smpos_sis_categorias (cat_codigo, cat_abbreviatura, cat_descripcion, cat_estado, cat_principal)
	VALUES (7, 'CONSECUTIVO.RANGO.ESTADO.ACTIVO', 'Rango Activo', 2, 6); 
INSERT INTO smpos_sis_categorias (cat_codigo, cat_abbreviatura, cat_descripcion, cat_estado, cat_principal)
	VALUES (8, 'CONSECUTIVO.RANGO.ESTADO.ASIGNADO', 'Rango Asignado para consumirse', 2, 6); 
INSERT INTO smpos_sis_categorias (cat_codigo, cat_abbreviatura, cat_descripcion, cat_estado, cat_principal)
	VALUES (9, 'CONSECUTIVO.RANGO.ESTADO.INACTIVO', 'Rango Inactivo', 2, 6); 
INSERT INTO smpos_sis_categorias (cat_codigo, cat_abbreviatura, cat_descripcion, cat_estado, cat_principal)
	VALUES (10, 'CONSECUTIVO.RANGO.ESTADO.CONSUMIDO', 'Rango Consumido', 2, 6); 
INSERT INTO smpos_sis_categorias (cat_codigo, cat_abbreviatura, cat_descripcion, cat_estado, cat_principal)
	VALUES (11, 'CONSECUTIVO.NUMERO.ESTADO', 'Estado de un número de consecutivo', 2, NULL); 
INSERT INTO smpos_sis_categorias (cat_codigo, cat_abbreviatura, cat_descripcion, cat_estado, cat_principal)
	VALUES (12, 'CONSECUTIVO.NUMERO.ESTADO.ACTIVO', 'Estado activo de un número', 2, 11); 
INSERT INTO smpos_sis_categorias (cat_codigo, cat_abbreviatura, cat_descripcion, cat_estado, cat_principal)
	VALUES (13, 'CONSECUTIVO.NUMERO.ESTADO.ASIGNADO', 'Estado asignado de un número', 2, 11); 
INSERT INTO smpos_sis_categorias (cat_codigo, cat_abbreviatura, cat_descripcion, cat_estado, cat_principal)
	VALUES (14, 'CONSECUTIVO.NUMERO.ESTADO.INACTIVO', 'Estado inactivo de un número', 2, 11); 
INSERT INTO smpos_sis_categorias (cat_codigo, cat_abbreviatura, cat_descripcion, cat_estado, cat_principal)
	VALUES (15, 'CONSECUTIVO.NUMERO.ESTADO.CONSUMIDO', 'Estado consumido de un número', 2, 11); 
INSERT INTO smpos_sis_categorias (cat_codigo, cat_abbreviatura, cat_descripcion, cat_estado, cat_principal)
	VALUES (16, 'MENU.ESTADO', 'Estados de las opciones de menu', 2, NULL); 
INSERT INTO smpos_sis_categorias (cat_codigo, cat_abbreviatura, cat_descripcion, cat_estado, cat_principal)
	VALUES (17, 'MENU.ESTADO.ACTIVO', 'Estado activo de la opción del menu', 2, 16); 
INSERT INTO smpos_sis_categorias (cat_codigo, cat_abbreviatura, cat_descripcion, cat_estado, cat_principal)
	VALUES (18, 'MENU.ESTADO.INACTIVO', 'Estado inactivo de la opción del menu', 2, 16); 
INSERT INTO smpos_sis_categorias (cat_codigo, cat_abbreviatura, cat_descripcion, cat_estado, cat_principal)
	VALUES (19, 'CONTRATO.TIPO', 'Tipos de contrato', 2, NULL);
INSERT INTO smpos_sis_categorias (cat_codigo, cat_abbreviatura, cat_descripcion, cat_estado, cat_principal)
	VALUES (20, 'CONTRATO.TIPO.FIJO', 'Fijo', 2, 19);
INSERT INTO smpos_sis_categorias (cat_codigo, cat_abbreviatura, cat_descripcion, cat_estado, cat_principal)
	VALUES (21, 'CONTRATO.TIPO.INDEFINIDO', 'Indefinido', 2, 19);
INSERT INTO smpos_sis_categorias (cat_codigo, cat_abbreviatura, cat_descripcion, cat_estado, cat_principal)
	VALUES (22, 'EMPLEADO.ESTADO', 'Estados del empleado', 2, NULL);
INSERT INTO smpos_sis_categorias (cat_codigo, cat_abbreviatura, cat_descripcion, cat_estado, cat_principal)
	VALUES (23, 'EMPLEADO.ESTADO.ACTIVO', 'Empleado activo', 2, 22);
INSERT INTO smpos_sis_categorias (cat_codigo, cat_abbreviatura, cat_descripcion, cat_estado, cat_principal)
	VALUES (24, 'EMPLEADO.ESTADO.INACTIVO', 'Empleado inactivo', 2, 22);
INSERT INTO smpos_sis_categorias (cat_codigo, cat_abbreviatura, cat_descripcion, cat_estado, cat_principal)
	VALUES (25, 'EMPLEADO.ESTADO.LICENCIA', 'Empleado en licencia', 2, 22);
INSERT INTO smpos_sis_categorias (cat_codigo, cat_abbreviatura, cat_descripcion, cat_estado, cat_principal)
	VALUES (26, 'EMPLEADO.ESTADO.INCAPACITADO', 'Empleado incapacitado', 2, 22);

