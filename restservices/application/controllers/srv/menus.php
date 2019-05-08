<?php
use Restserver\Libraries\REST_Controller;
defined('BASEPATH') OR exit('No direct script access allowed');

/** @noinspection PhpIncludeInspection */
require APPPATH . 'libraries/base/ResourceRestController.php';

/**
 * Implementacion de recursos a menus
 * 
 * @author jofre
 *
 */
class menus extends ResourceRestController {

    function __construct() {
        parent::__construct();
        $this->load->helper('xml');
    }
    
    //POST  se usa (seguro) cuando cada peticion devuelve una respuesta diferente
    //      ejemplo: cuando necesita hacer una consulta con filtros. (idempotencia)
	public function test_get() {
	    $output    = "Hola mundo: ";
	    $token      = $this->getHeader("Authorization");
	    if ($token == NULL) {
	        $output = "Debe especificar el token para realizar procesos"; 
	    }
	    //Hacer como se pasa por encabezado informacion al recurso
	    $this->set_response($output, REST_Controller::HTTP_OK);
	}
	
	public function create_post() {
	    $output    = "Hola mundo: ";
	    //Funcion que obtiene en metodo POST como body
	    $menu      = $this->post();
	    $output    = $output . json_encode($menu);
	    $this->set_response($output, REST_Controller::HTTP_OK);
	}
	
	public function list_get() {
	    $token      = $this->getHeader("Authorization");
	    $output     = NULL;
	    $codeStatus = REST_Controller::HTTP_OK;
	    //Debe estar definido el token para el menu
	    if (!empty($token)) {
	        try {
	            //Procedemos a realizar llamado a base de datos
	            $this->db->query("CALL smpos_prc_obtener_menu('".$token."', @vou_result, @vou_codigo, @vou_mensaje); ");
	            $result = $this->db->query("SELECT @vou_result AS resultSet, @vou_codigo AS codigo, @vou_mensaje AS mensaje;")->result_array();
	            $output = $result[0];
	            //Validamos si la respuesta fue adecuada
	            if ($output->codigo == '200') {
	                //Tratamiento del cursor como xml texto
	                //Investigar mañana con la ayuda de Dios
	                $codeStatus = REST_Controller::HTTP_OK;
	            } else if ($output->codigo == '401') {
	                $codeStatus = REST_Controller::HTTP_UNAUTHORIZED;
	            } else {
	                $codeStatus = REST_Controller::HTTP_INTERNAL_SERVER_ERROR;
	            }
	        } catch (Exception $e) {
	            $output = $e->getMessage();
	            $codeStatus = REST_Controller::HTTP_INTERNAL_SERVER_ERROR;
	        }
	    } else {
	        $output     = self::MSGNOTTOKEN_DATA;
	        $codeStatus = REST_Controller::HTTP_INTERNAL_SERVER_ERROR;
	    }
	    //Hacer como se pasa por encabezado informacion al recurso
	    $this->set_response($output, $codeStatus);
	}
}
