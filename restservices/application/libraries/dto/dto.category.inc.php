<?php 
namespace domain\transfer\dto;
use JsonSerializable;

class DTOCategory implements JsonSerializable {

	private $code;

	private $abbreviation;

	private $description;

	private $status;

	private $children;

	public function __construct() {
		$this->children = array();
	}

	public function getCode() {
		return $this->code;
	}

	public function getAbbreviation() {
		return $this->abbreviation;
	}

	public function getDescription() {
		return $this->description;
	}

	public function getStatus() {
		return $this->status;
	}

	public function &getChildren() {
		return $this->children;
	}


	public function setCode(string $code) {
		$this->code = $code;
	}

	public function setAbbreviation( string $abbreviation) {
		$this->abbreviation = $abbreviation;
	}

	public function setDescription( string $description ) {
		$this->description = $description;
	}

	public function setStatus( bool $status ) {
	    $this->status = $status;
	}

	public function setChildren( array $children) {
		$this->children = $children;
	}
    
    public function jsonSerialize() {
        $output = [
            'code'         => $this->getCode(),
            'abbreviation' => $this->getAbbreviation(),
            'description'  => $this->getDescription(),
            'status'       => $this->getStatus(),
            'children'     => array()
        ];
        foreach($this->children as $childrenNode) {
            array_push($output['children'], $childrenNode->jsonSerialize());
        }
        return $output;
    }

}
?>