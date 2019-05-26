<?php 
namespace domain\transfer\dto;
use JsonSerializable;

class DTOMenu implements JsonSerializable {

	private $code;

	private $name;

	private $tittle;

	private $abbreviation;

	private $description;

	private $route;

	private $order;

	private $active;

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

	public function getOrder() {
		return $this->order;
	}

	public function getActive() {
		return $this->active;
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

	public function setOrder( int $order) {
		$this->order = $order;
	}

	public function setActive( bool $active ) {
		$this->active = $active;
	}

	public function setChildren( array $children) {
		$this->children = $children;
	}
	
	
	public function jsonSerialize() {
	    $output = [
	        'code'         => $this->getCode(),
	        'tittle'       => $this->getTittle(),
	        'name'         => $this->getName(),
	        'abbreviation' => $this->getAbbreviation(),
	        'description'  => $this->getDescription(),
	        'active'       => $this->getActive(),
	        'route'        => $this->getRoute(),
	        'order'        => $this->getOrder(),
	        'children'     => array()
	    ];
	    foreach($this->children as $childrenNode) {
	        array_push($output['children'], $childrenNode->jsonSerialize());
	    }
	    return $output;
	}
}
?>