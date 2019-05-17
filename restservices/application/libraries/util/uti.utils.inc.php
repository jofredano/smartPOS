<?php 
namespace domain\util;

/**
 * Clase para control de utilidades 
 * 
 * @author joseanor
 *
 */
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
	 * Expresion para indicar que es un texto alfabetico
	 * @var string
	 */
	const CHCK_ALPHA_REG = "/^(([A-Za-zÁÉÍÓÚÜÑáéíóúüñ]+)(\s)?)+$/";
	
	/**
	 * Constante que define cualquier separador de datos (correo, telefono)
	 * @var string
	 */
	const CHCK_SEPAR_REG = "/(,|;)/";
	
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
		return Utils::checkDataSeparator(self::CHCK_EMAIL_REG, $value);
	}
	
	/**
	 * Determina si el valor corresponde a un texto alfabetico
	 * @param string $value
	 * @return bool
	 */
	public static function checkAlphabetic(string $value) {
		return preg_match(self::CHCK_ALPHA_REG, $value);
	}

	/**
	 * Determina si el valor corresponde a una estructura de identificacion
	 * @param string $value
	 * @return bool
	 */
	public static function checkIdentification(string $value) {
		return preg_match(self::CHCK_IDENT_REG, $value);
	}
	
	/**
	 * Metodo que realiza validacones asumiento que deba separar el texto
	 * @param  string $regex
	 * @param  string $value
	 * @return boolean
	 */
	public static function checkDataSeparator(string $regex, string $value) {
		$items  	= Utils::split_text(self::CHCK_SEPAR_REG, $value);
		$result 	= count($items) > 0;
		while($result && $data = current( $items )) {
			$result = $result && preg_match($regex, $data);
			next( $items );
		}
		return $result;
	}
	
	/**
	 * Metodo que divide un texto basado en una expresion regular
	 * @param string $regex
	 * @param string $data
	 */
	public static function split_text(string $regex, string $data) {
		$items = preg_split($regex, $data);
		//Se procede a ajustar los textos
		foreach($items as $item) {
			if (!empty($item)) {
				$items[] = trim( $item );
			}
		}
		return $items;
	}

}
?>