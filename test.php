<?php
class DTOMenu {

	private $code;
	
	private $name;
	
	private $tittle;
	
	private $abbreviation;
	
	private $description;

	private $route;
	
	private $children;

	public function __construct() {
		$this->children = array();
	}
	
	public function getCode() {
		return $this->code;
	}
	
	public function getName() {
		return $this->name;
	}
	
	public function getTittle() {
		return $this->tittle;
	}
	
	public function getAbbreviation() {
		return $this->abbreviation;
	}
	
	public function getDescription() {
		return $this->description;
	}

	public function getRoute() {
		return $this->route;
	}
	
	public function &getChildren() {
		return $this->children;
	}

	
	public function setCode(string $code) {
		$this->code = $code;
	}
	
	public function setName(string $name) {
		$this->name = $name;
	}
	
	public function setTittle( string $tittle ) {
		$this->tittle = $tittle;
	}
	
	public function setAbbreviation( string $abbreviation) {
		$this->abbreviation = $abbreviation;
	}
	
	public function setDescription( string $description ) {
		$this->description = $description;
	}
	
	public function setRoute( string $route) {
		$this->route = $route;
	}
	
	public function setChildren( array $children) {
		$this->children = $children;
	}
}

	function prepareResultSetText(string $text) {
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

	function &getOptionMenu($code, $menuItems) {
		$result = null;
		if (count($menuItems) < 0) {
			return $result;
		} else {
			foreach($menuItems as $item) {
				if ($item->getCode() == $code) {
					$result = $item;
					break;
				}
			}
			//Por cada hijo que tenga debe buscar el codigo
			$children = $menuItems;
			while(is_null($result) && count($children) > 0) {
				$result = getOptionMenu($code, $children[0]->getChildren());
				unset($children[0]);
			}
		}
		return $result;
	}
	
	function getResult($code, $items) {
		$result = NULL;
		foreach($items as $item) {
			if ($item->opc_codigo == $code) {
				$result = $item;
				break;
			}
		}
		return $result;
	}
	
	function prepareMenu($items) {
		$result 	= array();
		foreach($items as $item) {
			$menu 	= new DTOMenu();
			$menu->setCode( $item->opc_codigo );
			$menu->setName( $item->opc_nombre );
			$menu->setTittle( $item->opc_titulo );
			$menu->setAbbreviation( $item->opc_abreviatura );
			$menu->setDescription( $item->opc_descripcion );
			$menu->setRoute( $item->opc_ruta );
			
			//opc_principal
			//Si opc_principal contiene datos, significa que esta opcion
			//Tiene como principal otra (es decir es su padre)
			//Se debe buscar al padre de esta opcion y debe ser incluida
			//en la lista de hijos
			if (empty($item->opc_principal)) {
			    array_push($result, $menu);
			} else {
				$element = getOptionMenu($item->opc_principal, $result);
				if (is_null($element)) {
					//No existe, debe crearse la opcion y adicionarse al menu.
					$parent = getResult($item->opc_principal, $items);
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
					//Existe y debe adicionarse como hijo.
					array_push($element->getChildren(), $menu);
				}
			}
		}
		return $result;
	}
	
$xml = '<rows>
			<row>
				<field name="opc_codigo">1</field>
				<field name="opc_nombre">admon</field>
				<field name="opc_titulo">Administracion</field>
				<field name="opc_abreviatura">adm</field>
				<field name="opc_descripcion">Funciones de administracion</field>
				<field name="opc_ruta">administracion</field>
				<field name="opc_principal"></field>
				<field name="opc_orden">1</field>
				<field name="opc_estado">2</field>
			</row>
			<row>
				<field name="opc_codigo">2</field>
				<field name="opc_nombre">sales</field>
				<field name="opc_titulo">Ventas</field>
				<field name="opc_abreviatura">sal</field>
				<field name="opc_descripcion">Opciones de venta</field>
				<field name="opc_ruta">venta</field>
				<field name="opc_principal"></field>
				<field name="opc_orden">2</field>
				<field name="opc_estado">2</field>
			</row>
			<row>
				<field name="opc_codigo">3</field>
				<field name="opc_nombre">admon-user</field>
				<field name="opc_titulo">Usuarios</field>
				<field name="opc_abreviatura">adm-user</field>
				<field name="opc_descripcion">Funciones orientadas a usuario</field>
				<field name="opc_ruta">administracion/usuario</field>
				<field name="opc_principal">1</field>
				<field name="opc_orden">3</field>
				<field name="opc_estado">2</field>
			</row>
			<row>
				<field name="opc_codigo">4</field>
				<field name="opc_nombre">admon-provider</field>
				<field name="opc_titulo">Proveedores</field>
				<field name="opc_abreviatura">adm-provider</field>
				<field name="opc_descripcion">Funciones orientadas a proveedores</field>
				<field name="opc_ruta">administracion/proveedor</field>
				<field name="opc_principal">1</field>
				<field name="opc_orden">4</field>
				<field name="opc_estado">2</field>
			</row>
			<row>
				<field name="opc_codigo">5</field>
				<field name="opc_nombre">admon-secuence</field>
				<field name="opc_titulo">Consecutivo</field>
				<field name="opc_abreviatura">adm-secuence</field>
				<field name="opc_descripcion">Funciones orientadas a consecutivos</field>
				<field name="opc_ruta">administracion/consecutivo</field>
				<field name="opc_principal">1</field>
				<field name="opc_orden">5</field>
				<field name="opc_estado">2</field>
			</row>
			<row>
				<field name="opc_codigo">6</field>
				<field name="opc_nombre">admon-user-add</field>
				<field name="opc_titulo">Agregar</field>
				<field name="opc_abreviatura">adm-user-add</field>
				<field name="opc_descripcion">Agregar un nuevo usuario</field>
				<field name="opc_ruta">administracion/usuario/agregar</field>
				<field name="opc_principal">3</field>
				<field name="opc_orden">6</field>
				<field name="opc_estado">2</field>
			</row>
			<row>
				<field name="opc_codigo">7</field>
				<field name="opc_nombre">admon-user-list</field>
				<field name="opc_titulo">Listar</field>
				<field name="opc_abreviatura">adm-user-list</field>
				<field name="opc_descripcion">Listar usuarios existentes</field>
				<field name="opc_ruta">administracion/usuario/listar</field>
				<field name="opc_principal">3</field>
				<field name="opc_orden">7</field>
				<field name="opc_estado">2</field>
			</row>
			<row>
				<field name="opc_codigo">8</field>
				<field name="opc_nombre">aadmon-provider-add</field>
				<field name="opc_titulo">Agregar</field>
				<field name="opc_abreviatura">adm-provider-add</field>
				<field name="opc_descripcion">Agregar un nuevo proveedor</field>
				<field name="opc_ruta">administracion/proveedor/agregar</field>
				<field name="opc_principal">4</field>
				<field name="opc_orden">8</field>
				<field name="opc_estado">2</field>
			</row>
			<row>
				<field name="opc_codigo">9</field>
				<field name="opc_nombre">admon-provider-list</field>
				<field name="opc_titulo">Listar</field>
				<field name="opc_abreviatura">adm-provider-list</field>
				<field name="opc_descripcion">Lista los proveedores</field>
				<field name="opc_ruta">administracion/proveedor/listar</field>
				<field name="opc_principal">4</field>
				<field name="opc_orden">9</field>
				<field name="opc_estado">2</field>
			</row>
		</rows>';

		print("<pre>");
		print_r( prepareMenu(prepareResultSetText($xml)) );
		print("</pre>");
		
?>