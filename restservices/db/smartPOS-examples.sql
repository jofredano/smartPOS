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
	'Henry Stiven',
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