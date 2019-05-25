<?php
namespace domain\transfer\dto;
use JsonSerializable;

class DTOResponse implements JsonSerializable {

	private $code;

	private $token;

	private $message;
	
	private $items;

	public function getCode() {
		return $this->code;
	}

	public function getToken() {
		return $this->token;
	}

	public function getMessage() {
		return $this->message;
	}
	
	public function getItems() {
	    return $this->items;
	}

	public function setCode(string $code) {
		$this->code = $code;
	}

	public function setToken(string $token) {
		$this->token = $token;
	}

	public function setMessage(string $message) {
		$this->message = $message;
	}
	
	public function setItems(array $items) {
	    $this->items = $items;
	}
	
	public function jsonSerialize() {
	    $output = [
	        'code'    => $this->getCode(),
	        'message' => $this->getMessage(),
	        'items'   => array()
	    ];
	    if (!empty($this->getToken())) {
	        $output['token'] = $this->getToken();
	    }
	    foreach($this->items as $item) {
	        array_push($output['items'], $item->jsonSerialize());
	    }
	    return $output;
	}
}
?>