<?php
defined('BASEPATH') || exit('No direct script access allowed');
require APPPATH . 'libraries/base/rest-controller.inc.php';

use Restserver\Libraries\REST_Controller;

/**
 * Implementacion de recursos a empleados
 *
 * @author jofre
 *
 */
class employees extends PathRestController {

	const AGGREMENT_ATTRIB = 'agreement';
	
	const USER_ATTRIB = 'user';
	
	function __construct() {
		parent::__construct();
		$this->load->database();
	}
	
	protected function checkContent($content) {
		return $content;
	}
	
	/**
	 * Recurso que crea un nuevo empleado en el sistema
	 */
	public function create_post() {
		$content    = $this->post();
		$output     = NULL;
		$codeStatus = REST_Controller::HTTP_OK;
		$token      = $this->getHeader(PathRestController::ATTRIB_AUTHORIZATION);
		if (!empty($token)) {
			//Se realiza proceso de creacion del empleado
			//1. Se verifica que el usuario logueado puede realizar esta operacion
			$status = $this->checkProfile($token, 'EMPLEADO.CREAR', $this->db);
			//Verifica si el codigo de usuario es mayor que cero (si obtuvo resultado)
			if ($status > 0) {
				//2. Se verifica que los campos obligatorios esten diligenciados
				$content 					= $this->checkContent( $content );
				
				//Se diligencia los datos para ser invocado el procedimiento
				$vin_ent_identificacion		= $content['id']['type']."-".$content['id']['number'];
				$vin_per_nombres			= $content['name'];
				$vin_per_apellidos			= $content['lastname'];
				$vin_per_fecha_nacimiento	= $content['birth'];
				$vin_ent_direccion			= $content['address'];
				$vin_ent_telefono			= $content['phone'];
				$vin_ent_correo				= $content['mail'];
				$vin_emp_tipo_contrato		= $content[self::AGGREMENT_ATTRIB]['type'];
				$vin_emp_numero_contrato	= $content[self::AGGREMENT_ATTRIB]['number'];
				$vin_emp_fecha_inicio 		= $content[self::AGGREMENT_ATTRIB]['begin'];
				$vin_emp_fecha_fin 			= $content[self::AGGREMENT_ATTRIB]['end'];
				$vin_usu_alias 				= $content[self::USER_ATTRIB]['name'];
				$vin_usu_clave 				= $content[self::USER_ATTRIB]['password'];
				$vin_roles					= $content[self::USER_ATTRIB]['role'];
				$vin_usuario_creador		= $status;

				//3. Se intenta crear el usuario con los datos suministrados
				$this->db->query("CALL smpos_prc_crear_empleado(".
						"'".$vin_ent_identificacion."', '".$vin_per_nombres."',  '".$vin_per_apellidos."',".
						"STR_TO_DATE ('".$vin_per_fecha_nacimiento."','%Y-%m-%d'),".
						"'".$vin_ent_direccion."',      '".$vin_ent_telefono."', '".$vin_ent_correo."',".
						"'".$vin_emp_tipo_contrato."',  '".$vin_emp_numero_contrato."',".
						"STR_TO_DATE('".$vin_emp_fecha_inicio."', '%Y-%m-%d'),".
						"STR_TO_DATE('".$vin_emp_fecha_fin."', '%Y-%m-%d'),".
						"'".$vin_usu_alias."',          '".$vin_usu_clave."',    '".$vin_roles."',".
						"".$vin_usuario_creador.",      @vou_entidad,        @vou_codigo,".
						"@vou_mensaje); ");
				$result = $this->db->query("SELECT @vou_entidad AS entidad, @vou_codigo AS codigo, @vou_mensaje AS mensaje;")->result_array();
				$output = $result[0];
				//Validamos si la respuesta fue adecuada
				if ($output[PathRestController::ATTRIB_CODE] == '200') {
					$codeStatus = REST_Controller::HTTP_OK;
				} else if ($output[PathRestController::ATTRIB_CODE] == '401') {
					$codeStatus = REST_Controller::HTTP_UNAUTHORIZED;
				} else {
					$codeStatus = REST_Controller::HTTP_INTERNAL_SERVER_ERROR;
				}
			} else {
				$output     = 'Usuario no esta autorizado para ejecutar este recurso';
				$codeStatus = REST_Controller::HTTP_UNAUTHORIZED;
			}
		} else {
			$output     = PathRestController::MSGNOTTOKEN_DATA;
			$codeStatus = REST_Controller::HTTP_INTERNAL_SERVER_ERROR;
		}
		$this->set_response($output, $codeStatus);
	}
}