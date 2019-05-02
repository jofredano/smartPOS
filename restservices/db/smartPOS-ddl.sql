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
	VALUES (11, 'CONSECUTIVO.NUMERO.ESTADO', 'Estado de un n�mero de consecutivo', 2, NULL); 
INSERT INTO smpos_sis_categorias (cat_codigo, cat_abbreviatura, cat_descripcion, cat_estado, cat_principal)
	VALUES (12, 'CONSECUTIVO.NUMERO.ESTADO.ACTIVO', 'Estado activo de un n�mero', 2, 11); 
INSERT INTO smpos_sis_categorias (cat_codigo, cat_abbreviatura, cat_descripcion, cat_estado, cat_principal)
	VALUES (13, 'CONSECUTIVO.NUMERO.ESTADO.ASIGNADO', 'Estado asignado de un n�mero', 2, 11); 
INSERT INTO smpos_sis_categorias (cat_codigo, cat_abbreviatura, cat_descripcion, cat_estado, cat_principal)
	VALUES (14, 'CONSECUTIVO.NUMERO.ESTADO.INACTIVO', 'Estado inactivo de un n�mero', 2, 11); 
INSERT INTO smpos_sis_categorias (cat_codigo, cat_abbreviatura, cat_descripcion, cat_estado, cat_principal)
	VALUES (15, 'CONSECUTIVO.NUMERO.ESTADO.CONSUMIDO', 'Estado consumido de un n�mero', 2, 11); 
INSERT INTO smpos_sis_categorias (cat_codigo, cat_abbreviatura, cat_descripcion, cat_estado, cat_principal)
	VALUES (16, 'MENU.ESTADO', 'Estados de las opciones de menu', 2, NULL); 
INSERT INTO smpos_sis_categorias (cat_codigo, cat_abbreviatura, cat_descripcion, cat_estado, cat_principal)
	VALUES (17, 'MENU.ESTADO.ACTIVO', 'Estado activo de la opci�n del menu', 2, 16); 
INSERT INTO smpos_sis_categorias (cat_codigo, cat_abbreviatura, cat_descripcion, cat_estado, cat_principal)
	VALUES (18, 'MENU.ESTADO.INACTIVO', 'Estado inactivo de la opci�n del menu', 2, 16); 
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

INSERT smpos_sis_roles (rol_codigo, rol_titulo, rol_abbreviatura, rol_descripcion, rol_estado) VALUES (1, 'Rol de administrador', 'ROL.ADMINISTRADOR', 'Rol que representa a un administrador en el sistema', 2);
INSERT smpos_sis_roles (rol_codigo, rol_titulo, rol_abbreviatura, rol_descripcion, rol_estado) VALUES (2, 'Rol de vendedor', 'ROL.VENDEDOR', 'Rol que representa a un vendedor en el sistema', 2);

INSERT smpos_sis_perfiles (per_codigo, per_titulo, per_abbreviatura, per_descripcion, per_estado) VALUES (1, 'Creaci�n de usuarios', 'USUARIO.CREAR', 'Perfil que permite crear usuarios en el sistema', 2);
INSERT smpos_sis_perfiles (per_codigo, per_titulo, per_abbreviatura, per_descripcion, per_estado) VALUES (2, 'Creaci�n de art�culos', 'ARTICULO.CREAR', 'Perfil que permite crear nuevos art�culos en el sistema', 2);
INSERT smpos_sis_perfiles (per_codigo, per_titulo, per_abbreviatura, per_descripcion, per_estado) VALUES (3, 'Creaci�n de empleados', 'EMPLEADO.CREAR', 'Perfil que permite crear nuevos empleados en el sistema', 2);
INSERT smpos_sis_perfiles (per_codigo, per_titulo, per_abbreviatura, per_descripcion, per_estado) VALUES (4, 'Creaci�n de consecutivos', 'CONSECUTIVO.RANGO.CREAR', 'Perfil que permite crear nuevos rangos de consecutivos en el sistema para venta', 2);
INSERT smpos_sis_perfiles (per_codigo, per_titulo, per_abbreviatura, per_descripcion, per_estado) VALUES (5, 'Consulta de usuarios', 'USUARIO.CONSULTAR', 'Perfil que permite consultar usuarios en el sistema', 2);
INSERT smpos_sis_perfiles (per_codigo, per_titulo, per_abbreviatura, per_descripcion, per_estado) VALUES (6, 'Consulta de art�culos', 'ARTICULO.CONSULTAR', 'Perfil que permite consultar art�culos en el sistema', 2);
INSERT smpos_sis_perfiles (per_codigo, per_titulo, per_abbreviatura, per_descripcion, per_estado) VALUES (7, 'Consulta de consecutivos', 'CONSECUTIVO.RANGO.CONSULTAR', 'Perfil que permite consultar rango de consecutivos en el sistema', 2);
INSERT smpos_sis_perfiles (per_codigo, per_titulo, per_abbreviatura, per_descripcion, per_estado) VALUES (8, 'Modificaci�n de usuarios', 'USUARIO.MODIFICAR', 'Perfil que permite modificar informaci�n de usuarios en el sistema', 2);
INSERT smpos_sis_perfiles (per_codigo, per_titulo, per_abbreviatura, per_descripcion, per_estado) VALUES (9, 'Modificaci�n de art�culos', 'ARTICULO.MODIFICAR', 'Perfil que permite modificar art�culos en el sistema', 2);
INSERT smpos_sis_perfiles (per_codigo, per_titulo, per_abbreviatura, per_descripcion, per_estado) VALUES (10, 'Modificaci�n de empleados', 'EMPLEADO.MODIFICAR', 'Perfil que permite modificar informaci�n de empleados en el sistema', 2);
INSERT smpos_sis_perfiles (per_codigo, per_titulo, per_abbreviatura, per_descripcion, per_estado) VALUES (11, 'Modificaci�n de consecutivos', 'CONSECUTIVO.RANGO.MODIFICAR', 'Perfil que permite modificar rango de consecutivos en el sistema', 2);
INSERT smpos_sis_perfiles (per_codigo, per_titulo, per_abbreviatura, per_descripcion, per_estado) VALUES (12, 'Venta de art�culos', 'VENTA.CREAR', 'Perfil que permite realizar ventas en el sistema', 2);

INSERT INTO smpos_sis_roles_x_perfiles (rxp_codigo, rxp_rol, rxp_perfil, rxp_estado) VALUES (1, 1, 1, 2); 
INSERT INTO smpos_sis_roles_x_perfiles (rxp_codigo, rxp_rol, rxp_perfil, rxp_estado) VALUES (2, 1, 2, 2); 
INSERT INTO smpos_sis_roles_x_perfiles (rxp_codigo, rxp_rol, rxp_perfil, rxp_estado) VALUES (3, 1, 3, 2); 
INSERT INTO smpos_sis_roles_x_perfiles (rxp_codigo, rxp_rol, rxp_perfil, rxp_estado) VALUES (4, 1, 4, 2); 
INSERT INTO smpos_sis_roles_x_perfiles (rxp_codigo, rxp_rol, rxp_perfil, rxp_estado) VALUES (5, 1, 5, 2); 
INSERT INTO smpos_sis_roles_x_perfiles (rxp_codigo, rxp_rol, rxp_perfil, rxp_estado) VALUES (6, 1, 6, 2); 
INSERT INTO smpos_sis_roles_x_perfiles (rxp_codigo, rxp_rol, rxp_perfil, rxp_estado) VALUES (7, 1, 7, 2); 
INSERT INTO smpos_sis_roles_x_perfiles (rxp_codigo, rxp_rol, rxp_perfil, rxp_estado) VALUES (8, 1, 8, 2); 
INSERT INTO smpos_sis_roles_x_perfiles (rxp_codigo, rxp_rol, rxp_perfil, rxp_estado) VALUES (9, 1, 9, 2); 
INSERT INTO smpos_sis_roles_x_perfiles (rxp_codigo, rxp_rol, rxp_perfil, rxp_estado) VALUES (10, 1, 10, 2); 
INSERT INTO smpos_sis_roles_x_perfiles (rxp_codigo, rxp_rol, rxp_perfil, rxp_estado) VALUES (11, 1, 11, 2); 
INSERT INTO smpos_sis_roles_x_perfiles (rxp_codigo, rxp_rol, rxp_perfil, rxp_estado) VALUES (12, 2, 12, 2); 

