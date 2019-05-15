<?php 
class Utils {
	
	/**
	 * Expresion para indicar que puede ser un email
	 * @var string
	 */
	const CHCK_EMAIL_REG = "/^([a-zA-Z0-9])+([a-zA-Z0-9\._-])*@([a-zA-Z0-9_-])+([a-zA-Z0-9\._-]+)+$/";

	/**
	 * Expresion para indicar que puede ser un documento de identificacion (TIP-NUM)
	 * @var string
	 */
	const CHCK_IDENT_REG = "/^([a-zA-Z]{2,3})-([0-9]{4,12})$/";
	
	/**
	 * Aplica funcionalidad para determinar si el valor es nulo (sino entrega valor por defecto)
	 * @param  $value	Valor a verificar
	 * @param  $default	Valor por defecto a asignar (si el primer parametro es nulo)
	 * @return unknown
	 */
	public static function nvl($value, $default) {
		return (isset($value))?$value:$default;
	}
	
	/**
	 * Determina si el valor corresponde a una estructura de correo (email)
	 * @param  string $value
	 * @return bool
	 */
	public static function checkEmail(string $value) {
		return preg_match(self::CHCK_EMAIL_REG, $value);
	}

	/**
	 * Determina si el valor corresponde a una estructura de identificacion
	 * @param string $value
	 * @return bool
	 */
	public static function checkIdentification(string $value) {
		return preg_match(self::CHCK_IDENT_REG, $value);
	}

}
?>