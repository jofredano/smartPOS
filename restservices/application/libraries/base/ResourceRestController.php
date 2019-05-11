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
class ResourceRestController extends REST_Controller {
	
	function __construct() {
		parent::__construct();
		$this->methods['users_get']['limit']    = 500; // 500 requests per hour per user/key
		$this->methods['users_post']['limit']   = 100; // 100 requests per hour per user/key
		$this->methods['users_delete']['limit'] = 50; // 50 requests per hour per user/key
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