CALL smpos_prc_crear_consecutivos(
 	100000,
	1,
	50,
	'4560890',
	STR_TO_DATE('2019-01-01', '%Y-%m-%d'),
	@vou_codigo,
	@vou_mensaje);
SELECT @vou_codigo, @vou_mensaje;

CALL smpos_prc_crear_entidad(
	'PERSONA.TIPO.NATURAL',
	'CC-1111789100',
	'Henry Stivent',
	'Montaño Ramirez',
	STR_TO_DATE('1999-06-10', '%Y-%m-%d'),
	NULL,
	'Carrera 41 sur #1S-99',
	'3207010651',
	'henrystiven7@hotmail.com',
	@vou_entidad,
	@vou_codenti,
   	@vou_codigo,
	@vou_mensaje);
SELECT @vou_entidad, @vou_codenti, @vou_codigo, @vou_mensaje;

CALL smpos_prc_obtener_consecutivo(
 	@vou_consecutivo_codigo,
	@vou_consecutivo_numero,
   	@vou_codigo,
	@vou_mensaje);
SELECT 	@vou_consecutivo_codigo, @vou_consecutivo_numero, @vou_codigo, @vou_mensaje;

CALL smpos_prc_crear_usuario(
 	'jofreddyan',
	'jose123',
	NULL,
	'ROL.VENDEDOR',
	@vou_usuario,
   	@vou_codigo,
	@vou_mensaje);
SELECT 	@vou_usuario, @vou_codigo, @vou_mensaje;

CALL smpos_prc_crear_usuario(
	'hsmontanor',
	'juninho05',
	NULL,
	'ROL.ADMINISTRADOR',
	@vou_usuario,
   	@vou_codigo,
	@vou_mensaje);
SELECT 	@vou_usuario, @vou_codigo, @vou_mensaje;

CALL smpos_prc_crear_empleado(
	'CC-14477810',
	'Jose Freddy',
	'Angulo Ortega',
	STR_TO_DATE('1984-07-16', '%Y-%m-%d'),
	'Carrera 41 sur #1S-78',
	'3207010650',
	'jofredano@hotmail.com',
	'CONTRATO.TIPO.FIJO',
	'09134550',
	STR_TO_DATE('2019-05-02', '%Y-%m-%d'),
	STR_TO_DATE('2020-05-02', '%Y-%m-%d'),
 	'jofreddyan',
	'jose123',
	'ROL.ADMINISTRADOR',
	NULL,
	@vou_entidad,
   	@vou_codigo,
	@vou_mensaje);
SELECT 	@vou_entidad, @vou_codigo, @vou_mensaje;

CALL smpos_prc_crear_articulo(
	'ARTICULO.CATEGORIA.ACCESORIO' ,
	'MRC.SONY' ,
	'Mouse Optico (USB 3.0)' ,
	'Mouse Optico USB Version 3.0 ' ,
	'CC-16482024' ,
	100 ,
	NULL ,
	@vou_entidad ,
   	@vou_codigo  ,
	@vou_mensaje);
SELECT 	@vou_entidad, @vou_codigo, @vou_mensaje;


CALL smpos_prc_iniciar_sesion(
	'hmontano',
	'juninho05',
	30,
	@vou_token,
   	@vou_codigo,
	@vou_mensaje);
SELECT 	@vou_token, @vou_codigo, @vou_mensaje;

CALL smpos_prc_iniciar_sesion(
	'jofreddyan',
	'jose123',
	30,
	@vou_token,
   	@vou_codigo,
	@vou_mensaje);
SELECT 	@vou_token, @vou_codigo, @vou_mensaje;

CALL smpos_prc_finalizar_sesion(
 	'57640c7a-6f5e-11e9-9',
   	@vou_codigo,
	@vou_mensaje);
SELECT 	@vou_codigo, @vou_mensaje;

CALL smpos_prc_verificar_sesion(
 	'57640c7a-6f5e-11e9-9',
 	@vou_feini_acceso,
 	@vou_fefin_acceso,
 	@vou_nrmdu_acceso,
 	@vou_codus_acceso,
   	@vou_codigo,
	@vou_mensaje);
SELECT 	@vou_codigo, @vou_mensaje, @vou_feini_acceso, @vou_fefin_acceso, @vou_nrmdu_acceso, @vou_codus_acceso;


SET FOREIGN_KEY_CHECKS = 0;
CALL smpos_prc_obtener_menu(
 	'5c3e3128-713a-11e9-b',
   	@text_salida,
   	@vou_codigo,
	@vou_mensaje);
SELECT @text_salida, @vou_codigo, @vou_mensaje;

CALL smpos_prc_verificar_perfil(
 	'5c3e3128-713a-11e9-b',
 	'EMPLEADO.CREAR',
   	@vou_usuario,
 	@vou_codigo,
	@vou_mensaje);
SELECT @vou_usuario, @vou_codigo, @vou_mensaje;

CALL smpos_prc_obtener_categorias(
 	'PERSONA.TIPO, CONSECUTIVO.RANGO.ESTADO',
 	@vou_textResultSet,
   	@vou_codigo,
	@vou_mensaje);
SELECT @vou_textResultSet, @vou_codigo, @vou_mensaje;

	
