<?php
use Restserver\Libraries\REST_Controller;

/** @noinspection PhpIncludeInspection */
require APPPATH . 'libraries/REST_Controller.php';
require APPPATH . 'libraries/Format.php';
/**
 * Inclusion de objetos de transferencia
 * */
require APPPATH . 'libraries/dto/dto.inc.php';

/**
 * Clase personalizada para recursos restfull
 * 
 * @author joseanor
 *
 */
class PathRestController extends REST_Controller {
	
	const ATTRIB_CODE          = 'codigo';
	
	const ATTRIB_LIMIT         = 'limit';
	
	const MSGNOTTOKEN_DATA     = "Debe especificar el token para realizar proceso";
	
	const ATTRIB_AUTHORIZATION = 'Authorization';
	
	function __construct() {
		parent::__construct();
		$this->methods['users_get'][ATTRIB_LIMIT]    = 500; // 500 requests per hour per user/key
		$this->methods['users_post'][ATTRIB_LIMIT]   = 100; // 100 requests per hour per user/key
		$this->methods['users_delete'][ATTRIB_LIMIT] = 50; // 50 requests per hour per user/key
	}
	
	/**
	 * Verifica si el usuario tiene asignado este perfil
	 * @param  string $token
	 * @param  string $profile
	 * @param  $database
	 * $param  $postFunction | NULL
	 * @return boolean
	 */
	public function checkProfile(string $token, string $profile, $database, $postFunction) {
		//Procedemos a realizar llamado a base de datos
		$output = NULL;
		$codeStatus = 0;
		$database->query("CALL smpos_prc_verificar_perfil('".$token."', '".$profile."', @vou_usuario, @vou_codigo, @vou_mensaje); ");
		$result = $database->query("SELECT @vou_usuario AS usuario, @vou_codigo AS codigo, @vou_mensaje AS mensaje;")->result_array();
		$output = $result[0];
		//Validamos si la respuesta fue exitosa
		if ($output[self::ATTRIB_CODE] == '200') {
			//Estado de la respuesta
			$codeStatus = $output['usuario'];
			//Funcion que se ejcuta
			if (!is_null($postFunction)) {
				$postFunction($codeStatus, $output['usuario']);				
			}
		} else if ($output[self::ATTRIB_CODE] == '401') {
			$codeStatus = 0;
		} else {
			$codeStatus = 0;
		}
		return $codeStatus;
	}

	/**
	 * Obtiene la informacion de encabezado
	 * @param string $key
	 * @return string|mixed
	 */
	public function getHeader(string $key) {
		$value = $this->getValue($key, apache_request_headers());
		return ($value != null)?str_replace("Bearer ", "", $value):"";
	}
	
	/**
	 * Obtiene el valor de una lista
	 * @param string $key
	 * @param $items
	 * @return NULL|string
	 */
	public function getValue(string $key, array $items) {
	    $result = null;
	    if (count($items) > 0) {
	        foreach($items as $k => $v) {
	            if (strcasecmp($k, $key) == 0) {
	                $result = $v;
	                break;
	            }
	        }
	    }
	    return $result;
	}
	
	/**
	 * Obtiene una lista de datos basado en el texto como xml
	 * @param string $text
	 * @return NULL
	 */
	public function prepareResultSetText(string $text) {
		$result 	 = array();
		$xmlData     = simplexml_load_string($text);
		$xmlRows     = $xmlData->children();
		foreach ($xmlRows as $row) {
			$rowData = new \stdClass;
			foreach ($row->children() as $field) {
				$fieldName  		  = $field->attributes()["name"];
				$fieldValue 		  = "$field";
				$rowData->$fieldName  = $fieldValue;
			}
			array_push($result, $rowData);
		}
		return $result;
	}
	
}