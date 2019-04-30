
-- Informacion general de la base de datos --
-- Nombre de la base de datos: 			smpos_db --
-- Usuario sugerido de base de datos: 	smpos_user --
-- Clave de usuario de base de datos:	9ZfTpGWEg6N1KTPD --

-- Tablas del sistema (aplicacion) --

CREATE TABLE IF NOT EXISTS smpos_sis_categorias (
	cat_codigo 					INT(11)			NOT NULL		AUTO_INCREMENT 	COMMENT 'Codigo unico de la categoria',
	cat_abbreviatura			VARCHAR(200)									COMMENT 'Abreviatura de la categoria',
	cat_descripcion 			TEXT			NOT NULL						COMMENT 'Descripcion de la categoria',
	cat_estado 					INT(11)											COMMENT 'Estado de la categoria',
	cat_principal				INT(11)											COMMENT 'Si posee categoria principal (padre)',
	PRIMARY KEY (cat_codigo),
	FOREIGN KEY (cat_principal) 			REFERENCES smpos_sis_categorias (cat_codigo)
) Engine=InnoDB COMMENT = 'Tabla que guarda las categorias';

CREATE TABLE IF NOT EXISTS smpos_sis_perfiles (
	per_codigo					INT(11)			NOT NULL 		AUTO_INCREMENT	COMMENT 'Codigo unico del perfil',
	per_titulo 					VARCHAR(255)	NOT NULL 						COMMENT 'Titulo del perfil',
	per_abbreviatura			VARCHAR(200)									COMMENT 'Abreviatura del perfil',
	per_descripcion 			TEXT 			NOT NULL 						COMMENT 'Descripcion del perfil',
	per_estado 					INT(11)											COMMENT 'Estado del perfil',
	PRIMARY KEY (per_codigo)
) Engine=InnoDB COMMENT = 'Tabla que guarda los perfiles de usuario';

CREATE TABLE IF NOT EXISTS smpos_sis_roles (
	rol_codigo					INT(11)			NOT NULL 		AUTO_INCREMENT	COMMENT 'Codigo unico del rol',
	rol_titulo 					VARCHAR(255)	NOT NULL 						COMMENT 'Titulo del rol',
	rol_abbreviatura			VARCHAR(200)									COMMENT 'Abreviatura del rol',
	rol_descripcion 			TEXT 			NOT NULL 						COMMENT 'Descripcion del rol',
	rol_estado 					INT(11)											COMMENT 'Estado del rol',
	PRIMARY KEY (rol_codigo)
) Engine=InnoDB COMMENT = 'Tabla que guarda los roles que maneja el sistema';

CREATE TABLE IF NOT EXISTS smpos_sis_roles_x_perfiles (
	rxp_codigo					INT(11)			NOT NULL 		AUTO_INCREMENT	COMMENT 'Codigo unico del rol por perfil',
	rxp_rol 					INT(11)			NOT NULL						COMMENT 'Codigo del rol',
	rxp_perfil					INT(11)			NOT NULL 						COMMENT 'Codigo del perfil',
	rxp_estado 					INT(11)			NOT NULL 						COMMENT 'Estado del registro',
	PRIMARY KEY (rxp_codigo),
	FOREIGN KEY (rxp_rol) 					REFERENCES smpos_sis_roles   	(rol_codigo),
	FOREIGN KEY (rxp_perfil) 				REFERENCES smpos_sis_perfiles   (per_codigo),
	FOREIGN KEY (rxp_estado) 				REFERENCES smpos_sis_categorias (cat_codigo)
) Engine=InnoDB COMMENT = 'Tabla que guarda los roles por perfiles';

CREATE TABLE IF NOT EXISTS smpos_sis_usuarios (
	usu_codigo					INT(11)			NOT NULL		AUTO_INCREMENT	COMMENT 'Codigo unico del usuario',
	usu_alias 					VARCHAR(25)		NOT NULL						COMMENT 'Nombre de usuario',
	usu_clave 					VARCHAR(255)	NOT NULL						COMMENT 'Clave del usuario',
	usu_fecha_creacion			DATETIME 										COMMENT 'Fecha de creacion del usuario',
	usu_fecha_modificado		DATETIME 										COMMENT 'Fecha en la que se hizo la ultima modificacion',
	usu_usuario_creador			INT(11)											COMMENT 'Codigo del usuario creador',
	usu_usuario_modificador		INT(11)											COMMENT 'Codigo del usuario que hizo la ultima modificacion en el usuario',
	usu_estado 					INT(11)											COMMENT 'Estado asociado al usuario',
	PRIMARY KEY (usu_codigo),
	FOREIGN KEY (usu_estado) 				REFERENCES smpos_sis_categorias (cat_codigo)
) Engine=InnoDB COMMENT = 'Tabla que posee informacion de los usuarios del sistema';

CREATE TABLE IF NOT EXISTS smpos_sis_usuarios_x_roles (
	uxr_codigo					INT(11)			NOT NULL 		AUTO_INCREMENT	COMMENT 'Codigo del registro',
	uxr_rol						INT(11)			NOT NULL 						COMMENT 'Codigo del rol',
	uxr_usuario					INT(11)			NOT NULL 						COMMENT 'Codigo del usuario',
	uxr_estado					INT(11)											COMMENT 'Estado del registro',
	PRIMARY KEY (uxr_codigo),
	FOREIGN KEY (uxr_usuario) 				REFERENCES smpos_sis_usuarios   (usu_codigo),
	FOREIGN KEY (uxr_rol) 					REFERENCES smpos_sis_roles      (rol_codigo),
	FOREIGN KEY (uxr_estado) 				REFERENCES smpos_sis_categorias (cat_codigo)
) Engine=InnoDB COMMENT = 'Tabla que posee informacion de los usuarios por perfiles';

CREATE TABLE IF NOT EXISTS smpos_sis_conceptos (
	con_codigo					INT(11)			NOT NULL		AUTO_INCREMENT	COMMENT 'Codigo del concepto',
	con_abreviatura				VARCHAR(255)	NOT NULL						COMMENT 'Abreviatura del concepto',
	con_descripcion				TEXT			NOT NULL						COMMENT 'Descripcion del concepto',
	con_afecta					INT(11)			NOT NULL 						COMMENT 'Indica como afecta el concepto (aumenta la venta o la disminuye)',
	con_estado 					INT(11)											COMMENT 'Estado del concepto',
	PRIMARY KEY (con_codigo),
	FOREIGN KEY (con_afecta) 				REFERENCES smpos_sis_categorias (cat_codigo),
	FOREIGN KEY (con_estado) 				REFERENCES smpos_sis_categorias (cat_codigo)
) Engine=InnoDB COMMENT = 'Tabla que posee los conceptos soportados por el sistema';

CREATE TABLE IF NOT EXISTS smpos_sis_accesos (
	acc_token 					VARCHAR(255)	NOT NULL 						COMMENT 'Codigo de acceso',
	acc_usuario					INT(11)			NOT NULL						COMMENT 'Codigo del usuario asociado al acceso',
	acc_fecha_inicio			DATETIME 		NOT NULL						COMMENT 'Fecha de inicio del acceso',
	acc_fecha_fin				DATETIME										COMMENT 'Fecha de finalizacion del acceso',
	acc_duracion				INT(11)			NOT NULL						COMMENT 'Duracion en milisegundos del acceso',
	PRIMARY KEY (acc_token),
	FOREIGN KEY (acc_usuario) 				REFERENCES smpos_sis_usuarios   (usu_codigo)
) Engine=InnoDB COMMENT = 'Tabla que posee la informacion de los accesos al sistema';

CREATE TABLE IF NOT EXISTS smpos_men_opciones (
	opc_codigo					INT(11)			NOT NULL 		AUTO_INCREMENT	COMMENT 'Codigo unico del menu',
	opc_nombre					VARCHAR(90)		NOT NULL						COMMENT 'Nombre del menu',
	opc_titulo					VARCHAR(255)	NOT NULL						COMMENT 'Titulo del menu',
	opc_abreviatura				VARCHAR(200)									COMMENT 'Abreviatura del menu',
	opc_descripcion 			TEXT											COMMENT 'Describe detalladamente la opcion que realiza esta opcion',
	opc_ruta 					TEXT											COMMENT 'Ruta a la que dirije el menu',
	opc_principal				INT(11)											COMMENT 'Opcion principal asociada a esta',
	opc_estado 					INT(11)											COMMENT 'Estado de esta opcion de menu',
	PRIMARY KEY (opc_codigo),
	FOREIGN KEY (opc_principal) 			REFERENCES smpos_men_opciones (opc_codigo)
) Engine=InnoDB COMMENT = 'Tabla que guarda el menu que puede manejarse en el sistema';

CREATE TABLE IF NOT EXISTS smpos_men_opciones_x_perfiles (
	oxp_codigo					INT(11)			NOT NULL		AUTO_INCREMENT	COMMENT 'Codigo de la asociacion entre opcion y perfil',
	oxp_perfil					INT(11)			NOT NULL						COMMENT 'Perfil asociado a esta opcion',
	oxp_opcion					INT(11)			NOT NULL 						COMMENT 'Opcion asociada a este registro',
	oxp_estado					INT(11)			NOT NULL 						COMMENT 'Estado de este registro',
	PRIMARY KEY (oxp_codigo),
	FOREIGN KEY (oxp_perfil) 				REFERENCES smpos_sis_perfiles   (per_codigo),
	FOREIGN KEY (oxp_opcion) 				REFERENCES smpos_men_opciones   (opc_codigo),
	FOREIGN KEY (oxp_estado) 				REFERENCES smpos_sis_categorias (cat_codigo)
) Engine=InnoDB COMMENT = 'Tabla que guarda las opciones del menu por perfiles';

-- Informacion relacionada con ventas --
CREATE TABLE IF NOT EXISTS smpos_con_entidades (
	ent_codigo					INT(11)			NOT NULL 		AUTO_INCREMENT	COMMENT 'Codigo unico de la entidad',
	ent_identificacion			VARCHAR(25)										COMMENT 'Identificacion de la entidad',
	ent_tipo					INT(11)											COMMENT 'Tipo de entidad natural/juridico',
	ent_direccion				TEXT											COMMENT 'Direccion de la entidad',
	ent_telefono				TEXT 											COMMENT 'Telefono de la entidad',
	ent_correo					TEXT 											COMMENT 'Correo electronico de la entidad',
	ent_estado 					INT(11)											COMMENT 'Estado de la entidad',
	PRIMARY KEY (ent_codigo),
	FOREIGN KEY (ent_tipo) 					REFERENCES smpos_sis_categorias  (cat_codigo), 
	FOREIGN KEY (ent_estado) 				REFERENCES smpos_sis_categorias  (cat_codigo)
) Engine=InnoDB COMMENT = 'Tabla que guarda la informacion general de la entidad';

CREATE TABLE IF NOT EXISTS smpos_con_personas (
	per_codigo					INT(11)			NOT NULL 		AUTO_INCREMENT	COMMENT 'Codigo unico de la persona',
	per_entidad 				INT(11)											COMMENT 'Entidad asociada a esta persona',
	per_nombres					VARCHAR(255)	NOT NULL 						COMMENT 'Nombres completos de la persona',
	per_apellidos				VARCHAR(255)									COMMENT 'Apellidos de la persona',
	per_fecha_nacimiento		DATE											COMMENT 'Fecha de nacimiento',
	per_estado 					INT(11)											COMMENT 'Estado de la persona',
	PRIMARY KEY (per_codigo), 
	FOREIGN KEY (per_entidad) 				REFERENCES smpos_con_entidades   (ent_codigo), 
	FOREIGN KEY (per_estado) 				REFERENCES smpos_sis_categorias  (cat_codigo)
) Engine=InnoDB COMMENT = 'Tabla que guarda la informacion de la entidad como persona (persona natural)';

CREATE TABLE IF NOT EXISTS smpos_con_empresas (
	emp_codigo					INT(11)			NOT NULL 		AUTO_INCREMENT	COMMENT 'Codigo unico de la empresa',
	emp_entidad 				INT(11)											COMMENT 'Entidad asociada a esta empresa',
	emp_razon_social			VARCHAR(255)	NOT NULL 						COMMENT 'Razon social de la empresa',
	emp_estado 					INT(11)											COMMENT 'Estado de la empresa',
	PRIMARY KEY (emp_codigo), 
	FOREIGN KEY (emp_entidad) 				REFERENCES smpos_con_entidades   (ent_codigo), 
	FOREIGN KEY (emp_estado) 				REFERENCES smpos_sis_categorias  (cat_codigo)
) Engine=InnoDB COMMENT = 'Tabla que guarda la informacion de la entidad como empresa (persona juridica)';

CREATE TABLE IF NOT EXISTS smpos_con_proveedores (
	pro_codigo					INT(11)			NOT NULL 		AUTO_INCREMENT	COMMENT 'Codigo unico del proveedor',
	pro_entidad 				INT(11)											COMMENT 'Codigo de la entidad',
	pro_estado 					INT(11)											COMMENT 'Estado del proveedor',
	PRIMARY KEY (pro_codigo), 
	FOREIGN KEY (pro_entidad) 				REFERENCES smpos_con_entidades   (ent_codigo), 
	FOREIGN KEY (pro_estado) 				REFERENCES smpos_sis_categorias  (cat_codigo)
) Engine=InnoDB COMMENT = 'Tabla que guarda los proveedores';

CREATE TABLE IF NOT EXISTS smpos_con_empleados (
	emp_codigo					INT(11)			NOT NULL 		AUTO_INCREMENT	COMMENT 'Codigo unico del vendedor',
	emp_persona 				INT(11)			NOT NULL 						COMMENT 'Codigo de la persona asociada como vendedor',
	emp_tipo_contrato			INT(11)											COMMENT 'Tipo de contrato del vendedor (Indefinido/Temporal)',
	emp_numero_contrato			VARCHAR(255)									COMMENT 'Numero de contrato del vendedor',
	emp_fecha_creacion			DATETIME 										COMMENT 'Fecha de creacion del vendedor',
	emp_fecha_modificacion		DATETIME 										COMMENT 'Fecha de la ultima modificacion del empleado',
	emp_fecha_inicio 			DATE 											COMMENT 'Fecha inicio del contrato asociado al vendedor',
	emp_fecha_fin 				DATE 											COMMENT 'Fecha final del contrato asociado al vendedor',
	emp_usuario_creador			INT(11)											COMMENT 'Usuario que definio a este empleado',
	emp_usuario_modificador		INT(11)											COMMENT 'Usuario que hizo la ultima modificacion del empleado',
	emp_estado 					INT(11)											COMMENT 'Estado asociado al vendedor',
	PRIMARY KEY (emp_codigo),
	FOREIGN KEY (emp_tipo_contrato) 		REFERENCES smpos_sis_categorias  (cat_codigo),
	FOREIGN KEY (emp_usuario_creador) 		REFERENCES smpos_sis_usuarios  	 (usu_codigo),
	FOREIGN KEY (emp_usuario_modificador) 	REFERENCES smpos_sis_usuarios  	 (usu_codigo),
	FOREIGN KEY (emp_estado) 				REFERENCES smpos_sis_categorias  (cat_codigo)
) Engine=InnoDB COMMENT = 'Tabla que guarda los vendedores del sistema';

CREATE TABLE IF NOT EXISTS smpos_inv_articulos (
	art_codigo					INT(11)			NOT NULL 		AUTO_INCREMENT	COMMENT 'Codigo unico del articulo',
	art_categoria				INT(11)											COMMENT 'Categoria del producto',
	art_marca 					INT(11)											COMMENT 'Marca del articulo',
	art_nombre					VARCHAR(255)	NOT NULL 						COMMENT 'Nombre del articulo',
	art_descripcion 			TEXT 											COMMENT 'Descripcion del articulo',
	art_proveedor				INT(11)											COMMENT 'Codigo del proveedor asociado al articulo',
	art_cantidad_maxima			INT(11)											COMMENT 'Cantidad limite que se puede tener del articulo',
	art_estado 					INT(11)											COMMENT 'Estado del articulo',
	PRIMARY KEY (art_codigo),
	FOREIGN KEY (art_categoria) 			REFERENCES smpos_sis_categorias  (cat_codigo),
	FOREIGN KEY (art_marca) 				REFERENCES smpos_sis_categorias  (cat_codigo),
	FOREIGN KEY (art_proveedor) 			REFERENCES smpos_con_proveedores (pro_codigo),
	FOREIGN KEY (art_estado) 				REFERENCES smpos_sis_categorias  (cat_codigo)
) Engine=InnoDB COMMENT = 'Tabla que guarda los articulos';

-- Diseñarlo asi­ puede tener lo siguiente: --
-- 1.	En un mes antes se compro 4 teclados para vender a 10.000 --
-- 2.	Se vendieron 3 teclados de los 4 adquiridos --
-- 3.	En un mes sigue se compro 4 teclados para vender a 15.000 --
-- 4.	Llega un cliente para comprar 4 teclados, entonces vendera 1 a 10.000 y los otros dos a 15.000 --
-- 5. 	La solucion es darle un manejo (gestion) a la venta de este tipo de productos y con el articulo y la cantidad (determina por mas cantidad de productos el que se vendera) --
-- 6. 	Antes de reportar el nuevo producto (compra) en el inventario, realizar una prevalidacion de una compra anterior e informar (notificar) que hubo una alteracion superior o inferior --
-- 7.   se elimina campo cantidad para establecer control sobre cada producto añadido al inventario--
-- 8.   cuando se vaya definir la cantidad de elementos dentro del inventario cada producto es un registro independiente en esta tabla para control de devoluciones --

CREATE TABLE IF NOT EXISTS smpos_inv_inventarios (
	inv_codigo					INT(11)			NOT NULL 		AUTO_INCREMENT	COMMENT 'Codigo unico asociado a esta adquisicion',
	inv_articulo				INT(11)			NOT NULL 						COMMENT 'Codigo asociado al articulo',
	inv_precio_compra			FLOAT 			NOT NULL 						COMMENT 'Precio de compra',
	inv_precio_venta			FLOAT 											COMMENT 'Precio de venta',
	inv_fecha_compra			DATETIME 		NOT NULL 						COMMENT 'Fecha y hora de compra del articulo',
	inv_fecha_caducidad			DATETIME 										COMMENT 'Fecha en la que caduca el producto adquirido',
	inv_iva_precio_compra		FLOAT 											COMMENT 'Porcentaje de iva aplicado a la compra',
	inv_usuario_compra			INT(11)											COMMENT 'Codigo del usuario que realizo la compra',
	inv_estado 					INT(11)											COMMENT 'Estado de esta adquisicion',
	PRIMARY KEY (inv_codigo),
	FOREIGN KEY (inv_articulo) 				REFERENCES smpos_inv_articulos   (art_codigo),
	FOREIGN KEY (inv_usuario_compra) 		REFERENCES smpos_sis_usuarios    (usu_codigo),
	FOREIGN KEY (inv_estado) 				REFERENCES smpos_sis_categorias  (cat_codigo)
) Engine=InnoDB COMMENT = 'Tabla que guarda las compras realizadas (asociada a inventario)';

CREATE TABLE IF NOT EXISTS smpos_ven_consecutivos (
	con_codigo					INT(11)			NOT NULL 		AUTO_INCREMENT	COMMENT 'Codigo unico asociado al consecutivo',
	con_base					INT(11)			NOT NULL 						COMMENT 'Numero base del consecutivo',
	con_inicio					INT(11)			NOT NULL 						COMMENT 'Numero de inicio',
	con_fin						INT(11)			NOT NULL 						COMMENT 'Numero final',
	con_codigo_resolucion		VARCHAR(255)	NOT NULL						COMMENT 'Resolucion entregada por la DIAN',
	con_fecha_resolucion		DATE			NOT NULL 						COMMENT 'Fecha de emision de la resolucion DIAN',
	con_estado 					INT(11)											COMMENT 'Estado del consecutivo',
	PRIMARY KEY (con_codigo),
	FOREIGN KEY (con_estado) 				REFERENCES smpos_sis_categorias  (cat_codigo)
) Engine=InnoDB COMMENT = 'Tabla que guarda los consecutivos para la venta';

CREATE TABLE IF NOT EXISTS smpos_ven_ventas (
	ven_codigo					INT(11)			NOT NULL 		AUTO_INCREMENT	COMMENT 'Codigo unico de la venta',
	ven_consecutivo_codigo		INT(11)			NOT NULL 						COMMENT 'Consecutivo asignado a la venta (codigo)',
	ven_consecutivo_numero		VARCHAR(200)	NOT NULL 						COMMENT 'Consecutivo asignado a la venta (numero)',
	ven_fecha					DATETIME 		NOT NULL 						COMMENT 'Fecha/hora de la venta',
	ven_total					FLOAT 											COMMENT 'Total de la venta',
	ven_porcentaje_descuento	FLOAT 											COMMENT 'Porcentaje de descuento a la venta',
	ven_porcentaje_iva			FLOAT 											COMMENT 'Porcentaje de IVA aplicado a la venta',
	ven_cliente_codigo 			INT(11)											COMMENT 'Codigo del cliente',
	ven_cliente_nombre			TEXT 			NOT NULL						COMMENT 'Nombre del cliente asociado a la venta',
	ven_cliente_identificacion	VARCHAR(25)										COMMENT 'Identificacion del cliente asociado a la venta',
	ven_vendedor				INT(11)											COMMENT 'Codigo del vendedor',
	ven_estado					INT(11)											COMMENT 'Estado asociado a esta venta',
	PRIMARY KEY (ven_codigo),
	FOREIGN KEY (ven_consecutivo_codigo)	REFERENCES smpos_ven_consecutivos(con_codigo),
	FOREIGN KEY (ven_cliente_codigo) 		REFERENCES smpos_con_entidades   (ent_codigo),
	FOREIGN KEY (ven_vendedor) 				REFERENCES smpos_con_empleados   (emp_codigo),
	FOREIGN KEY (ven_estado) 				REFERENCES smpos_sis_categorias  (cat_codigo)
) Engine=InnoDB COMMENT = 'Tabla que guarda las ventas realizadas en el punto de venta';

CREATE TABLE IF NOT EXISTS smpos_ven_pagos (
	pag_codigo    				INT(11)  	 NOT NULL		AUTO_INCREMENT     COMMENT  'Codigo unico del pago',
	pag_venta					INT(11)		 NOT NULL						   COMMENT  'Codigo asociado a la venta',
	pag_fecha					DATETIME	 NOT NULL						   COMMENT  'feha del pago asignado a la venta',	
	pag_valor					FLOAT		 NOT NULL						   COMMENT  'Valor de la venta',
	pag_tipo                    INT(11)      NOT NULL						   COMMENT  'tipo de pago: efectivo, tarjeta:debito, credito, bono',
    pag_estado                  INT(11)      	                               COMMENT  'estado asociado al pago',
    PRIMARY KEY (pag_codigo),
	FOREIGN KEY (pag_venta)					REFERENCES smpos_ven_ventas      (ven_codigo),
	FOREIGN KEY (pag_estado) 				REFERENCES smpos_sis_categorias  (cat_codigo),
	FOREIGN KEY (pag_tipo)      			REFERENCES smpos_sis_categorias  (cat_codigo)
) Engine=InnoDB COMMENT = 'Tabla que guarda los pagos asociados a las ventas realizadas en el punto de venta';

-- con relación al campo tipo se creará una tabla diferente llamada sisconceptos ya que es necesario determinar si el concepto deduce o aduce a la venta un valor --
CREATE TABLE IF NOT EXISTS smpos_ven_conceptos (
	con_codigo					INT(11)			NOT NULL 		AUTO_INCREMENT	COMMENT 'Codigo unico del concepto',
	con_venta 					INT(11)			NOT NULL 						COMMENT 'Codigo de la venta asociado a este concepto',
	con_tipo 					INT(11)			NOT NULL 						COMMENT 'Codigo del concepto aplicado a la venta (IVA)',
	con_valor					FLOAT 			NOT NULL 						COMMENT 'Valor del concepto aplicado a esta venta',
	con_estado 					INT(11)											COMMENT 'Estado asociado al concepto',
	PRIMARY KEY (con_codigo),
	FOREIGN KEY (con_venta) 				REFERENCES smpos_ven_ventas   	 (ven_codigo),
	FOREIGN KEY (con_tipo) 					REFERENCES smpos_sis_conceptos   (con_codigo),
	FOREIGN KEY (con_estado) 				REFERENCES smpos_sis_categorias  (cat_codigo)
) Engine=InnoDB COMMENT = 'Tabla que guarda los conceptos aplicados a la venta (IVA, etc)';

CREATE TABLE IF NOT EXISTS smpos_ven_elementos (
	ele_codigo					INT(11)			NOT NULL 		AUTO_INCREMENT	COMMENT 'Codigo unico del elemento asociado a la venta',
	ele_venta					INT(11)			NOT NULL 						COMMENT 'Codigo de la venta asociada a este elemento',
	ele_inventario				INT(11)			NOT NULL 						COMMENT 'Codigo del inventario asociado al producto vendido',
	ele_articulo				INT(11)			NOT NULL 						COMMENT 'Codigo del articulo asociado a la venta',
	ele_precio 					FLOAT 			NOT NULL 						COMMENT 'Precio por unidad del articulo',
	ele_cantidad 				INT(11)			NOT NULL 						COMMENT 'Cantidad de elementos asociados al articulo',
	ele_subtotal				FLOAT											COMMENT 'Subtotal de la venta de este producto',
	ele_estado 					INT(11)											COMMENT 'Estado asociado a este elemento en la venta',
	PRIMARY KEY (ele_codigo),
	FOREIGN KEY (ele_venta) 				REFERENCES smpos_ven_ventas   	 (ven_codigo),
	FOREIGN KEY (ele_inventario) 			REFERENCES smpos_inv_inventarios (inv_codigo),
	FOREIGN KEY (ele_articulo) 				REFERENCES smpos_inv_articulos   (art_codigo),
	FOREIGN KEY (ele_estado) 				REFERENCES smpos_sis_categorias  (cat_codigo)
) Engine=InnoDB COMMENT = 'Tabla que guarda los elementos asociados a la venta';


