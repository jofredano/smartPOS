<?php
use Restserver\Libraries\REST_Controller;
defined('BASEPATH') OR exit('No direct script access allowed');

/** @noinspection PhpIncludeInspection */
require APPPATH . 'libraries/REST_Controller.php';
require APPPATH . 'libraries/Format.php';

/**
 * Implementacion de recursos a usuarios
 *
 * @author jofre
 *
 */
class users extends REST_Controller {
    
    const TIMELIMIT_SESSION = 50;
    const MSGNOTTOKEN_DATA  = "Debe especificar el token para realizar proceso";
    
    function __construct() {
        parent::__construct();
        $this->load->database();
        $this->methods['users_get']['limit'] = 500; // 500 requests per hour per user/key
        $this->methods['users_post']['limit'] = 100; // 100 requests per hour per user/key
        $this->methods['users_delete']['limit'] = 50; // 50 requests per hour per user/key
    }
    
    /**
     * Metodo que realiza inicio de sesion
     */
    public function login_post() {
        //Funcion que obtiene en metodo POST como body
        $content    = $this->post();
        $output     = NULL;
        $codeStatus = 0;
        try {
            if (is_null($content)) {
                $output = "No posee los argumentos necesarios";
                $codeStatus = REST_Controller::HTTP_BAD_REQUEST;
            } else {
                //Procedemos a realizar llamado a base de datos
                $status = $this->db->query("CALL smpos_prc_iniciar_sesion('".$content["username"]."', '".$content["password"]."', ".self::TIMELIMIT_SESSION.", @vou_token, @vou_codigo,@vou_mensaje); ");
                if ($status) {
                    $result = $this->db->query("SELECT @vou_token AS token, @vou_codigo AS codigo, @vou_mensaje AS mensaje;")->result_array();
                    $output = $result[0];
                    //Validamos si la respuesta fue adecuada
                    if ($output->codigo == '200') {
                        $codeStatus = REST_Controller::HTTP_OK;
                    } else if ($output->codigo == '401') {
                        $codeStatus = REST_Controller::HTTP_UNAUTHORIZED;
                    } else {
                        $codeStatus = REST_Controller::HTTP_INTERNAL_SERVER_ERROR;
                    }
                }
            }
        } catch (Exception $e) {
            $output = $e->getMessage();
            $codeStatus = REST_Controller::HTTP_INTERNAL_SERVER_ERROR;
        }
        //Se valida informacion de la sesion
        $this->set_response($output, $codeStatus);
    }
    
    /**
     * Metodo que verifica si una sesion esta activa
     */
    public function check_get() {
        $output     = NULL;
        $codeStatus = REST_Controller::HTTP_OK;
        $headers    = apache_request_headers();
        if (array_key_exists("Authorization", $headers) ) {
            //Tratando informacion del token
            $token  = str_replace("Bearer ", "", $headers["Authorization"]);
            //Procedemos a validar el token
            try {
                //Procedemos a realizar llamado a base de datos
                $status = $this->db->query("CALL smpos_prc_verificar_sesion('".$token."', @vou_feini_acceso, @vou_fefin_acceso, @vou_nrmdu_acceso, @vou_codus_acceso, @vou_codigo, @vou_mensaje); ");
                if ($status) {
                    $result = $this->db->query("SELECT @vou_codigo AS codigo, @vou_mensaje AS mensaje, @vou_feini_acceso AS fecini_acceso, @vou_fefin_acceso AS fecfin_acceso, @vou_nrmdu_acceso AS nrmdu_acceso, @vou_codus_acceso AS codus_acceso;")->result_array();
                    $output = $result[0];
                    //Validamos si la respuesta fue adecuada
                    if ($output->codigo == '200') {
                        $codeStatus = REST_Controller::HTTP_OK;
                    } else if ($output->codigo == '401') {
                        $codeStatus = REST_Controller::HTTP_UNAUTHORIZED;
                    } else {
                        $codeStatus = REST_Controller::HTTP_INTERNAL_SERVER_ERROR;
                    }
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

    /**
     * Metodo que finaliza la sesion
     */
    public function logout_get() {
        $output     = NULL;
        $codeStatus = REST_Controller::HTTP_OK;
        $headers    = apache_request_headers();
        if (array_key_exists("Authorization", $headers) ) {
            //Tratando informacion del token
            $token  = str_replace("Bearer ", "", $headers["Authorization"]);
            //Procedemos a validar el token
            try {
                //Procedemos a realizar llamado a base de datos
                $status = $this->db->query("CALL smpos_prc_finalizar_sesion('".$token."', @vou_codigo, @vou_mensaje); ");
                if ($status) {
                    $result = $this->db->query("SELECT @vou_codigo AS codigo, @vou_mensaje AS mensaje;")->result_array();
                    $output = $result[0];
                    //Validamos si la respuesta fue adecuada
                    if ($output->codigo == '200') {
                        $codeStatus = REST_Controller::HTTP_OK;
                    } else if ($output->codigo == '401') {
                        $codeStatus = REST_Controller::HTTP_UNAUTHORIZED;
                    } else {
                        $codeStatus = REST_Controller::HTTP_INTERNAL_SERVER_ERROR;
                    }
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

