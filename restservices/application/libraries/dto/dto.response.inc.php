<?php
namespace domain\transfer\dto;

class DTOResponse {

	private $codigo;

	private $token;

	private $mensaje;

	public function getCodigo() {
		return $this->codigo;
	}

	public function getToken() {
		return $this->token;
	}

	public function getMensaje() {
		return $this->mensaje;
	}

	public function setCodigo(string $codigo) {
		$this->codigo = $codigo;
	}

	public function setToken(string $token) {
		$this->token = $token;
	}

	public function setMensaje(string $mensaje) {
		$this->mensaje = $mensaje;
	}
}
?>