<?php
use Restserver\Libraries\REST_Controller;

/** @noinspection PhpIncludeInspection */
require APPPATH . 'libraries/REST_Controller.php';
require APPPATH . 'libraries/Format.php';

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

	public function getHeader($key) {
		$headers = apache_request_headers();
		return (array_key_exists($key, $headers))?str_replace("Bearer ", "", $headers[$key]):"";
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