<?php
defined('BASEPATH') || exit('No direct script access allowed');
require APPPATH . 'libraries/base/rest-controller.inc.php';

use Restserver\Libraries\REST_Controller;
use domain\transfer\dto\DTOCategory;
use domain\exception\GeneralException;
use domain\transfer\dto\DTOResponse;

/**
 * Implementacion de recursos a empleados
 *
 * @author jofre
 *
 */
class categories extends PathRestController {

	const AGGREMENT_ATTRIB = 'agreement';
	
	const MESSAGE_ATTRIB = 'mensaje';
	

	function __construct() {
		parent::__construct();
		$this->load->database();
	}
	
	/**
	 * Recurso que crea un nuevo empleado en el sistema
	 */
	public function list_post() {
	    $content    = $this->post();
	    $output     = NULL;
	    $data       = NULL;
	    $status     = 0;
	    $token      = $this->getHeader(PathRestController::ATTRIB_AUTHORIZATION);
	    if (!empty($token)) {
	        try {
	            $callback   = function($result) use ($content) {
	                //Variable de resultado
	                $data   = NULL;
	                //Verifica si el codigo de usuario es mayor que cero (si obtuvo resultado)
	                if ($result['codigo'] == '200') {
	                    try {
	                        //3. Se intenta crear el usuario con los datos suministrados
	                        //Procedemos a realizar llamado a base de datos
	                        $categoryCode   = empty($content["category"]["code"])?"NULL":$content["category"]["code"];
	                        $categoryAbbrev = empty($content["category"]["abbrev"])?"NULL":"'".$content["category"]["abbrev"]."'";
	                        $this->db->query("CALL smpos_prc_obtener_categorias(".$categoryCode.",".$categoryAbbrev.", @vou_result, @vou_codigo, @vou_mensaje); ");
	                        $result = $this->db->query("SELECT @vou_result AS resultSet, @vou_codigo AS codigo, @vou_mensaje AS mensaje;")->result_array();
	                        //Validamos si la respuesta fue adecuada
	                        $data = self::checkResponse( $result[0] );
	                    } catch (Exception $e) {
	                        throw new GeneralException(
	                            $e->getMessage(), REST_Controller::HTTP_INTERNAL_SERVER_ERROR);
	                    }
	                } else {
	                    throw new GeneralException(
	                        $result[self::MESSAGE_ATTRIB],
	                        REST_Controller::HTTP_UNAUTHORIZED);
	                }
	                return $data;
	            };
	            //Se realiza proceso de creacion del empleado
	            //1. Se verifica que el usuario logueado puede realizar esta operacion
	            $data        = $this->checkProfile($token, 'EMPLEADO.CREAR', $this->db, $callback);
	            //Se procede a transformar resultado 
	            $items       = $this->prepareResultSetText( $data );
	            //Verifica si efectivamente se creo el empleado
	            if (count($items) > 0) {
	                $status   = REST_Controller::HTTP_OK;
	                $response = new DTOResponse();
	                $response->setCode( "200" );
	                $response->setMessage( "Categorias cargadas" );
	                $response->setItems( $this->prepareCategories( $items ) );
	                $output   = $response;
	            }
	        } catch (Exception $e) {
	            $output   = $e->getMessage();
	            $status   = $e->getCode();
	        }
	    } else {
	        $output  = PathRestController::MSGNOTTOKEN_DATA;
	        $status  = REST_Controller::HTTP_INTERNAL_SERVER_ERROR;
	    }
	    $this->set_response($output, $status);
	}
	
	/**
	 * Metodo que valida la respuesta
	 * @param  object $response
	 * @return boolean
	 */
	public static function checkResponse( $response ) {
	    $data = NULL;
	    if ($response[PathRestController::ATTRIB_CODE] == '200') {
	        $data = $response['resultSet'];
	    } else if ($response[PathRestController::ATTRIB_CODE] == '401') {
	        throw new GeneralException(
	            $response[self::MESSAGE_ATTRIB], REST_Controller::HTTP_UNAUTHORIZED);
	    } else {
	        throw new GeneralException(
	            $response[self::MESSAGE_ATTRIB], REST_Controller::HTTP_INTERNAL_SERVER_ERROR);
	    }
	    return $data;
	}
	
	/**
	 * Obtiene la opcion de categoria de una lista de opciones de categoria
	 * @param string $code
	 * @param array $childrenItems
	 * @return NULL
	 */
	protected function &getOptionCategory(string $code, array $childrenItems) {
	    $result = null;
	    //Verifica que la cantidad de opciones de la lista sea 0
	    if (count($childrenItems) == 0) {
	        //Indica que no hay que buscar mas, no se encontro la opcion buscada
	        return $result;
	    } else {
	        //Se recorre la lista de opciones
	        foreach($childrenItems as $item) {
	            //Si encuentro la opcion que busco
	            if ($item->getCode() == $code) {
	                //Entrego esa como resultado y termina la busqueda
	                $result = $item;
	                break;
	            }
	        }
	        //Si el resultado es nulo, significa que no ha encontrado la opcion
	        if (is_null($result)) {
	            //Buscamos por cada hijo de cada nodo la opcion a encontrar
	            $children = $childrenItems;
	            //Mientras no encuentre la opcion
	            while(is_null($result) && count($children) > 0) {
	                //Busca la opcion en las opciones hijo del primer elemento
	                $result = $this->getOptionCategory($code, $children[0]->getChildren());
	                //Y elimina la opcion donde se realizo la busqueda
	                unset($children[0]);
	            }
	        }
	    }
	    return $result;
	}
	
	/**
	 * Obtiene un resultado a traves del codigo
	 * @param string $code
	 * @param array $items
	 * @return NULL
	 */
	protected function getResult(string $code, array $items) {
	    $result = NULL;
	    foreach($items as $item) {
	        if ($item->cat_codigo == $code) {
	            $result = $item;
	            break;
	        }
	    }
	    return $result;
	}
	
	/**
	 * Metodo que obtiene una lista de items de menu
	 * @param array $items
	 */
	protected function prepareCategories($items) {
	    $result 	        = array();
	    foreach($items as $item) {
	        $category 	    = new DTOCategory();
	        $category->setCode( $item->cat_codigo );
	        $category->setAbbreviation( $item->cat_abbreviatura );
	        $category->setDescription( $item->cat_descripcion );
	        $category->setStatus( $item->cat_estado );
	        
	        //Valida si no posee opc_principal (indica que es una opcion que no es hija de nadie)
	        if (empty($item->cat_principal)) {
	            array_push($result, $category);
	        } else {
	            //Indica que si es hija de una opcion padre
	            //Por ende se obtiene dicha opcion
	            $element = $this->getOptionCategory($item->cat_principal, $result);
	            //Validaamos si dicha opcion existe
	            if (is_null($element)) {
	                //No existe, debe crearse la opcion y adicionarse al menu.
	                $parent  = $this->getResult($item->cat_principal, $items);
	                $element = new DTOCategory();
	                $element->setCode( $parent->cat_codigo );
	                $element->setAbbreviation( $parent->cat_abreviatura );
	                $element->setDescription( $parent->cat_descripcion );
	                $element->setStatus( $parent->cat_estado );
	                array_push($element->getChildren(), $category);
	                array_push($result, $element);
	            } else {
	                //Si existe y debe adicionarse como hijo a la opcion padre.
	                array_push($element->getChildren(), $category);
	            }
	        }
	    }
	    return $result;
	}
}