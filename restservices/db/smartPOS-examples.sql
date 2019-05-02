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


CALL smpos_prc_crear_empleado(
	'CC-14477810',
	'Jose Freddy',
	'Angulo Ortega',
	STR_TO_DATE('1984-07-16', '%Y-%m-%d'),
	NULL,
	'Carrera 41 sur #1S-78',
	'3207010650',
	'jofredano@hotmail.com',
	'CONTRATO.TIPO.FIJO',
	'09134550',
	STR_TO_DATE('2019-05-02', '%Y-%m-%d'),
	STR_TO_DATE('2020-05-02', '%Y-%m-%d'),
 	'jofreddyan',
	'jose123',
	'ROL.VENDEDOR',
	NULL,
	@vou_entidad,
   	@vou_codigo,
	@vou_mensaje);
SELECT 	@vou_usuario, @vou_codigo, @vou_mensaje;
