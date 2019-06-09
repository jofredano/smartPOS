<?php
defined('BASEPATH') || exit('No direct script access allowed');
require APPPATH . 'libraries/base/rest-controller.inc.php';

use Restserver\Libraries\REST_Controller;
use domain\exception\GeneralException;
use domain\util\Utils;

/**
 * Implementacion de recursos a empleados
 *
 * @author jofre
 *
 */
class employees extends PathRestController {

	const AGGREMENT_ATTRIB = 'agreement';
	
	const USER_ATTRIB = 'user';
	
	const MESSAGE_ATTRIB = 'mensaje';
	

	function __construct() {
		parent::__construct();
		$this->load->database();
	}
	
	/**
	 * Metodo que verifica la informacion del usuario
	 * @param  object $content
	 * @throws GeneralException
	 * @return string
	 */
	public static function checkContent($content) {
		if (is_null($content)) {
			throw new GeneralException('No posee informacion del empleado', 1040);
		} else {
			if (!isset($content['id'])) {
				throw new GeneralException('Empleado no posee identificacion', 1045);
			} else if (is_object($content['id']) && (!isset($content['id']['type']) || !isset($content['id']['number']))) {
				throw new GeneralException('Identificador no valido', 1046);
			} else {
				$content['id'] = $content['id']['type']."-".$content['id']['number'];
			}
			//Ahora se comienza a validar cada campo incluyendo la identificacion nuevamente
			if (!Utils::checkIdentification($content['id'])) {
				throw new GeneralException('No corresponde a un documento de identificacion', 1047);
			}
			if (!Utils::checkEmail($content['mails'])) {
				throw new GeneralException('No corresponde a un correo electronico', 1048);
			}
			if (!Utils::checkAlphabetic($content['name'])) {
				throw new GeneralException('No corresponde a un nombre de persona valido', 1049);
			}
			if (!Utils::checkAlphabetic($content['lastname'])) {
				throw new GeneralException('No corresponde a un apellido de persona valido', 1049);
			}
		}
		return $content;
	}
	
	/**
	 * Metodo que valida la respuesta
	 * @param  object $response
	 * @return boolean
	 */
	public static function checkResponse($response) {
		$codeStatus = REST_Controller::HTTP_INTERNAL_SERVER_ERROR;
		if ($response[PathRestController::ATTRIB_CODE] == '200') {
			$codeStatus = REST_Controller::HTTP_OK;
		} else if ($response[PathRestController::ATTRIB_CODE] == '401') {
			throw new GeneralException(
				$response[self::MESSAGE_ATTRIB], REST_Controller::HTTP_UNAUTHORIZED);
		} else {
			throw new GeneralException(
				$response[self::MESSAGE_ATTRIB], REST_Controller::HTTP_INTERNAL_SERVER_ERROR);
		}
		return $codeStatus;
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
			try {
				$callback   = function($result) use ($content) {
					//Variable de resultado
					$codeStatus = REST_Controller::HTTP_INTERNAL_SERVER_ERROR;
					//Verifica si el codigo de usuario es mayor que cero (si obtuvo resultado)
					if ($result['codigo'] == '200') {
						try {
							//2. Se verifica que los campos obligatorios esten diligenciados
							$content 					= self::checkContent( $content );
							//Se diligencia los datos para ser invocado el procedimiento
							$vin_ent_identificacion		= Utils::getValue($content, 'id',       "'#value'", 'NULL');
							$vin_per_nombres			= Utils::getValue($content, 'name',     "'#value'", 'NULL');
							$vin_per_apellidos			= Utils::getValue($content, 'lastname', "'#value'", 'NULL');
							$vin_per_fecha_nacimiento	= Utils::getValue($content, 'birth',    "STR_TO_DATE('#value','%Y-%m-%d')", 'NULL');
							$vin_ent_direccion			= Utils::getValue($content, 'address',  "'#value'", 'NULL');
							$vin_ent_telefono			= Utils::getValue($content, 'phones',   "'#value'", 'NULL');
							$vin_ent_correo				= Utils::getValue($content, 'mails',    "'#value'", 'NULL');
							$vin_emp_tipo_contrato		= Utils::getValue($content[self::AGGREMENT_ATTRIB], 'type',     "'#value'", 'NULL');
							$vin_emp_numero_contrato	= Utils::getValue($content[self::AGGREMENT_ATTRIB], 'number',   "'#value'", 'NULL');
							$vin_emp_fecha_inicio 		= Utils::getValue($content[self::AGGREMENT_ATTRIB], 'begin',    "STR_TO_DATE('#value','%Y-%m-%d')", 'NULL');
							$vin_emp_fecha_fin 			= Utils::getValue($content[self::AGGREMENT_ATTRIB], 'end',      "STR_TO_DATE('#value','%Y-%m-%d')", 'NULL');
							$vin_usu_alias 				= Utils::getValue($content[self::USER_ATTRIB],      'name',     "'#value'", 'NULL');
							$vin_usu_clave 				= Utils::getValue($content[self::USER_ATTRIB],      'password', "'#value'", 'NULL');
							$vin_roles					= Utils::getValue($content[self::USER_ATTRIB],      'role',     "'#value'", 'NULL');
							$vin_usuario_creador		= $result['usuario'];
							//3. Se intenta crear el usuario con los datos suministrados
							$this->db->query("CALL smpos_prc_crear_empleado(".
									"".$vin_ent_identificacion.", ".$vin_per_nombres.",  ".$vin_per_apellidos.",".
									"".$vin_per_fecha_nacimiento.",".
									"".$vin_ent_direccion.",      ".$vin_ent_telefono.", ".$vin_ent_correo.",".
									"".$vin_emp_tipo_contrato.",  ".$vin_emp_numero_contrato.",".
									"".$vin_emp_fecha_inicio.",   ".$vin_emp_fecha_fin.",".
									"".$vin_usu_alias.",          ".$vin_usu_clave.",    ".$vin_roles.",".
									"".$vin_usuario_creador.",      @vou_entidad,        @vou_codigo,".
									"@vou_mensaje); ");
							$result = $this->db->query("SELECT @vou_entidad AS entidad, @vou_codigo AS codigo, @vou_mensaje AS mensaje;")->result_array();
							$output = $result[0];
						} catch (Exception $e) {
							throw new GeneralException(
								$e->getMessage(), REST_Controller::HTTP_INTERNAL_SERVER_ERROR);
						}
						//Validamos si la respuesta fue adecuada
						$codeStatus = self::checkResponse( $output );
					} else {
						throw new GeneralException(
							$result[self::MESSAGE_ATTRIB], 
							REST_Controller::HTTP_UNAUTHORIZED);
					}
					return $codeStatus == REST_Controller::HTTP_OK;
				};
				//Se realiza proceso de creacion del empleado
				//1. Se verifica que el usuario logueado puede realizar esta operacion
				$status = $this->checkProfile($token, 'EMPLEADO.CREAR', $this->db, $callback);
				//Verifica si efectivamente se creo el empleado
				if ($status) {
					$codeStatus = REST_Controller::HTTP_OK;
					$output     = "Se creo el empleado de manera exitosa";
				}
			} catch (Exception $e) {
	            $output = $e->getMessage();
	            $codeStatus = $e->getCode();
	        }
		} else {
			$output = PathRestController::MSGNOTTOKEN_DATA;
			$codeStatus = REST_Controller::HTTP_INTERNAL_SERVER_ERROR;
		}
		$this->set_response($output, $codeStatus);
	}
}