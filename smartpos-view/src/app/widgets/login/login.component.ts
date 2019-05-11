import { Component, Input, OnInit, OnDestroy } from '@angular/core';
import { Subscription } from 'rxjs';
import { FirewallService } from '../../core/security';
import { FormControl, FormGroup } from '@angular/forms';
import { Router } from "@angular/router";

/**
 * Componente para renderizar el encabezado de la aplicación
 */
@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: []
})
export class LoginComponent implements OnInit, OnDestroy {

  /** Se crearan campos para control de los mensajes en el componente */
  private _lblTittleForm: string;

  private _lblQuestionUsernameForm: string;

  private _lblQuestionPasswdForm: string;

  private _lblButtonAccessForm: string;

  private _lblButtonRegisterForm: string;
    
  private _showMessage: boolean = false;

  private _textMessage: string;


  private info:any = {
      username: '',
      password: ''
  };

  constructor(private router: Router, private firewallService: FirewallService) {}

  ngOnInit(): void {
      //this.identityService.getUserInfo().subscribe(userInfo => this.user = userInfo);
      this.lblTittleForm              = 'Debe diligenciar su acceso';
      this.lblQuestionUsernameForm    = 'Nombre de usuario';
      this.lblQuestionPasswdForm      = 'Clave';
      this.lblButtonAccessForm        = 'Ingresar';
      this.lblButtonRegisterForm      = 'Registrar';
      this.showMessage                = false;
  }

  ngOnDestroy(): void {
      //Implementacion cuando se intente destruir el componente
  }

  get lblTittleForm(): string {
      return this._lblTittleForm;
  }
  
  get lblQuestionUsernameForm(): string {
      return this._lblQuestionUsernameForm;
  }

  get lblQuestionPasswdForm(): string {
      return this._lblQuestionPasswdForm;
  }
  
  get lblButtonAccessForm(): string {
      return this._lblButtonAccessForm;
  }
  
  get lblButtonRegisterForm(): string {
      return this._lblButtonRegisterForm;
  }
  
  get showMessage(): boolean {
      return this._showMessage;
  }

  get username(): string {
      return this.info.username;
  }
  
  get password(): string {
      return this.info.password;
  }

  get textMessage(): string {
      return this._textMessage;
  }
  
 
  set lblTittleForm(_lblTittleForm: string) {
      this._lblTittleForm = _lblTittleForm;
  }
  
  set lblQuestionUsernameForm(_lblQuestionUsernameForm: string) {
      this._lblQuestionUsernameForm = _lblQuestionUsernameForm;
  }

  set lblQuestionPasswdForm(_lblQuestionPasswdForm: string) {
      this._lblQuestionPasswdForm = _lblQuestionPasswdForm;
  }
  
  set lblButtonAccessForm(_lblButtonAccessForm: string) {
      this._lblButtonAccessForm = _lblButtonAccessForm;
  }
  
  set lblButtonRegisterForm(_lblButtonRegisterForm: string) {
      this._lblButtonRegisterForm = _lblButtonRegisterForm;
  }
  
  set showMessage(_showMessage: boolean) {
      this._showMessage = _showMessage;
  }

  @Input()
  set username(_username: string) {
      this.info.username = _username;
  }
  
  @Input()
  set password(_password:string ) {
      this.info.password = _password;
  }
  
  set textMessage(_textMessage: string) {
      this._textMessage = _textMessage;
  }
  
  accessUser() {
      const self = this.firewallService;
      this.firewallService.accessUser(this.info).subscribe(
       res => {
          this.showMessage = false;
          self.token = res.token;
          this.router.navigate(['main']);
       }, error => {
          this.showMessage = true;
          this.textMessage = error.error.mensaje;
          console.error(error);
       });
  }

}


