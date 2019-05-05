<?php
use Restserver\Libraries\REST_Controller;
defined('BASEPATH') OR exit('No direct script access allowed');

/** @noinspection PhpIncludeInspection */
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
        $this->load->database();
        $this->methods['users_get']['limit'] = 500; // 500 requests per hour per user/key
        $this->methods['users_post']['limit'] = 100; // 100 requests per hour per user/key
        $this->methods['users_delete']['limit'] = 50; // 50 requests per hour per user/key
    }
    
    //POST  se usa (seguro) cuando cada peticion devuelve una respuesta diferente
    //      ejemplo: cuando necesita hacer una consulta con filtros. (idempotencia)
	public function test_get() {
	    $output    = "Hola mundo: ";
	    $headers   = apache_request_headers();
	    if (array_key_exists("Authorization", $headers) ) {
	       $headers["Authorization"];
	    } else {
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
}
