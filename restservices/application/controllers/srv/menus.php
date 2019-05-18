<?php
defined('BASEPATH') || exit('No direct script access allowed');
require APPPATH . 'libraries/base/rest-controller.inc.php';

use Restserver\Libraries\REST_Controller;
use domain\transfer\dto\DTOMenu;

/**
 * Implementacion de recursos a menus
 * 
 * @author jofre
 *
 */
class menus extends PathRestController {

    const MSGNOTTOKEN_DATA = 'Debe especificar el token para realizar procesos';
    
    function __construct() {
        parent::__construct();
        $this->load->helper('xml');
    }
    
    //POST  se usa (seguro) cuando cada peticion devuelve una respuesta diferente
    //      ejemplo: cuando necesita hacer una consulta con filtros. (idempotencia)
	public function test_get() {
	    $output    = "Hola mundo: ";
	    $token      = $this->getHeader(PathRestController::ATTRIB_AUTHORIZATION);
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
		//Obtenemos el codigo de acceso de este usuario
	    $token      = $this->getHeader(PathRestController::ATTRIB_AUTHORIZATION);
	    $output     = NULL;
	    $items		= NULL;
	    $codeStatus = REST_Controller::HTTP_OK;
	    //Debe estar definido el token para el menu
	    if (!empty($token)) {
	        try {
	            //Procedemos a realizar llamado a base de datos
	            $this->db->query("CALL smpos_prc_obtener_menu('".$token."', @vou_result, @vou_codigo, @vou_mensaje); ");
	            $result = $this->db->query("SELECT @vou_result AS resultSet, @vou_codigo AS codigo, @vou_mensaje AS mensaje;")->result_array();
	            $output = $result[0];
	            //Validamos si la respuesta fue exitosa
	            if ($output[PathRestController::ATTRIB_CODE] == '200') {
	                //Tratamiento del cursor como xml texto
	                $items      = $this->prepareResultSetText($output['resultSet']);
	            	//Se recorre el resultado para transformarlo a menu de la aplicacion
	            	$output 	= $this->prepareMenu($items);
	            	//Estado de la respuesta
	                $codeStatus = REST_Controller::HTTP_OK;
	            } else if ($output[PathRestController::ATTRIB_CODE] == '401') {
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
	
	/**
	 * Obtiene la opcion de menu de una lista de opciones de menu
	 * @param string $code
	 * @param array $childrenItems
	 * @return NULL
	 */
	protected function &getOptionMenu(string $code, array $childrenItems) {
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
					$result = $this->getOptionMenu($code, $children[0]->getChildren());
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
			if ($item->opc_codigo == $code) {
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
	protected function prepareMenu($items) {
		$result 	= array();
		foreach($items as $item) {
			$menu 	= new DTOMenu();
			$menu->setCode( $item->opc_codigo );
			$menu->setName( $item->opc_nombre );
			$menu->setTittle( $item->opc_titulo );
			$menu->setAbbreviation( $item->opc_abreviatura );
			$menu->setDescription( $item->opc_descripcion );
			$menu->setRoute( $item->opc_ruta );
			
			//Valida si no posee opc_principal (indica que es una opcion que no es hija de nadie)
			if (empty($item->opc_principal)) {
			    array_push($result, $menu);
			} else {
				//Indica que si es hija de una opcion padre
				//Por ende se obtiene dicha opcion
				$element = $this->getOptionMenu($item->opc_principal, $result);
				//Validaamos si dicha opcion existe
				if (is_null($element)) {
					//No existe, debe crearse la opcion y adicionarse al menu.
					$parent = $this->getResult($item->opc_principal, $items);
					$element = new DTOMenu();
					$element->setCode( $parent->opc_codigo );
					$element->setName( $parent->opc_nombre );
					$element->setTittle( $parent->opc_titulo );
					$element->setAbbreviation( $parent->opc_abreviatura );
					$element->setDescription( $parent->opc_descripcion );
					$element->setRoute( $parent->opc_ruta );
					array_push($element->getChildren(), $menu);
					array_push($result, $element);
				} else {
					//Si existe y debe adicionarse como hijo a la opcion padre.
					array_push($element->getChildren(), $menu);
				}
			}
		}
		return $result;
	}
}
