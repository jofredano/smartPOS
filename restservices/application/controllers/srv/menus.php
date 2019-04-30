<?php
use Restserver\Libraries\REST_Controller;
defined('BASEPATH') OR exit('No direct script access allowed');

// This can be removed if you use __autoload() in config.php OR use Modular Extensions
/** @noinspection PhpIncludeInspection */
//To Solve File REST_Controller not found
require APPPATH . 'libraries/REST_Controller.php';
require APPPATH . 'libraries/Format.php';

/**
 * Implementacion de recursos a menus
 * 
 * @author jofre
 *
 */
class menus extends REST_Controller {

    function __construct() {
        parent::__construct();     
        $this->methods['users_get']['limit'] = 500; // 500 requests per hour per user/key
        $this->methods['users_post']['limit'] = 100; // 100 requests per hour per user/key
        $this->methods['users_delete']['limit'] = 50; // 50 requests per hour per user/key
    }
    
    //POST  se usa (seguro) cuando cada peticion devuelve una respuesta diferente
    //      ejemplo: cuando necesita hacer una consulta con filtros. (idempotencia)
	public function test_get() {
	    $output    = "Hola mundo: ";
	    $headers   = apache_request_headers();
	    foreach ($headers as $header => $value) {
	        $output = $output . "$header: $value \n";
	    }
	    //echo $this->header();
	    //Hacer como se pasa por encabezado informacion al recurso
	    $this->set_response($output, REST_Controller::HTTP_OK);
	}
}
