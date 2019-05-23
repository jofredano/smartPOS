import { Component, Input, OnInit, OnDestroy } from '@angular/core';
import { Subscription } from 'rxjs';
import { FirewallService } from '../../core/security';
import { DTOEmployee } from '../../core/dto';
import { FormControl, FormGroup } from '@angular/forms';
import { Router } from "@angular/router";

/**
 * Componente para renderizar el encabezado de la aplicación
 */
@Component({
  selector: 'app-w-create-employee',
  templateUrl: './w-create-employee.component.html',
  styleUrls: []
})
export class WCreateEmployeeComponent implements OnInit, OnDestroy {
    
    private _lblTittleForm: string;

    private _lblInputName: string;

    private _lblInputLastname: string;
    
    private _lblInputBirth: string;
    
    private _lblInputBothCity: string;
    
    private _lblInputAddress: string;
    
    private _lblInputPhones: string;
    
    private _lblInputMails: string;
    
    private _lblInputContractType: string;
    
    private _lblInputContractNumber: string;
    
    private _lblInputContractBegin: string;
    
    private _lblInputContractEnd: string;
    
    private _lblInputUsername: string;
    
    private _lblInputUserpasswd: string;
    
    private _lblInputUserpasswdConfirm: string;
    
    private _lblButtonCreate: string;
    
    private _lblButtonClean: string;

    private _employee: DTOEmployee = {
        name: '',
        lastname: '',
        birth: null,
        bothcity: '',
        address: '',
        phones: '',
        mails: '',
        contract: {
        },
        user: {
            name: '',
            password1: '',
            password2: ''
        }
    };

    constructor(private router: Router, private firewallService: FirewallService) {}
    
    ngOnInit(): void {
        //Implementacion cuando se intente destruir el componente
        this.lblTittleForm              = 'Contratando un nuevo empleado';
        this.lblInputName               = 'Nombres del empleado';
        this.lblInputLastname           = 'Apellidos del empleado';
        this.lblInputBirth              = 'Fecha de nacimiento';
        this.lblInputBothCity           = 'Ciudad de nacimiento';
        this.lblInputAddress            = 'Direcciones';
        this.lblInputPhones             = 'Teléfonos de contacto';
        this.lblInputMails              = 'Correos electrónicos';
        this.lblInputContractType       = 'Tipo de contrato';
        this.lblInputContractNumber     = 'Número de contrato';
        this.lblInputContractBegin      = 'Fecha de inicio (contrato)';
        this.lblInputContractEnd        = 'Fecha final (contrato)';
        this.lblInputUsername           = 'Nombre de usuario';
        this.lblInputUserpasswd         = 'Contraseña';
        this.lblInputUserpasswdConfirm  = 'Contraseña (confirmar)';
        this.lblButtonCreate            = 'Crear';
        this.lblButtonClean             = 'Limpiar';
    }

    ngOnDestroy(): void {
        //Implementacion cuando se intente destruir el componente
    }
    
    create(): void {
        console.log(this._employee);
    }
    
    get lblTittleForm(): string {
        return this._lblTittleForm;
    }
    get lblInputName(): string {
        return this._lblInputName;
    }
    get lblInputLastname(): string {
        return this._lblInputLastname;
    }
    get lblInputBirth(): string {
        return this._lblInputBirth;
    }
    get lblInputBothCity(): string {
        return this._lblInputBothCity;
    }
    get lblInputAddress(): string {
        return this._lblInputAddress;
    }
    get lblInputPhones(): string {
        return this._lblInputPhones;
    }
    get lblInputMails(): string {
        return this._lblInputMails;
    }
    get lblInputContractType(): string {
        return this._lblInputContractType;
    }
    get lblInputContractNumber(): string {
        return this._lblInputContractNumber;
    }
    get lblInputContractBegin(): string {
        return this._lblInputContractBegin;
    }
    get lblInputContractEnd(): string {
        return this._lblInputContractEnd;
    }
    get lblInputUsername(): string {  
        return this._lblInputUsername;
    }
    get lblInputUserpasswd(): string  {
        return this._lblInputUserpasswd;
    }
    get lblInputUserpasswdConfirm(): string {
        return this._lblInputUserpasswdConfirm;
    }
    get lblButtonCreate(): string {
        return this._lblButtonCreate;
    }
    get lblButtonClean(): string {
        return this._lblButtonClean;
    }
    get employee(): DTOEmployee {
        return this._employee;
    }

    set lblTittleForm ( _lblTittleForm: string) { 
        this._lblTittleForm = _lblTittleForm;
    }
    set lblInputName ( _lblInputName: string) { 
        this._lblInputName = _lblInputName;
    }
    set lblInputLastname ( _lblInputLastname: string) { 
        this._lblInputLastname = _lblInputLastname;
    }
    set lblInputBirth ( _lblInputBirth: string) { 
        this._lblInputBirth = _lblInputBirth;
    }
    set lblInputBothCity ( _lblInputBothCity: string) { 
        this._lblInputBothCity = _lblInputBothCity;
    }
    set lblInputAddress ( _lblInputAddress: string) { 
        this._lblInputAddress = _lblInputAddress;
    }
    set lblInputPhones ( _lblInputPhones: string) { 
        this._lblInputPhones = _lblInputPhones;
    }
    set lblInputMails( _lblInputMails: string) { 
        this._lblInputMails = _lblInputMails;
    }
    set lblInputContractType ( _lblInputContractType: string) { 
        this._lblInputContractType = _lblInputContractType;
    }
    set lblInputContractNumber ( _lblInputContractNumber: string) { 
        this._lblInputContractNumber = _lblInputContractNumber;
    }
    set lblInputContractBegin ( _lblInputContractBegin: string) {
        this._lblInputContractBegin = _lblInputContractBegin;
    }
    set lblInputContractEnd ( _lblInputContractEnd: string) { 
        this._lblInputContractEnd = _lblInputContractEnd;
    }
    set lblInputUsername ( _lblInputUsername: string) { 
        this._lblInputUsername = _lblInputUsername;
    }
    set lblInputUserpasswd ( _lblInputUserpasswd: string) { 
        this._lblInputUserpasswd = _lblInputUserpasswd;
    }
    set lblInputUserpasswdConfirm ( _lblInputUserpasswdConfirm: string) { 
        this.lblInputUserpasswdConfirm = _lblInputUserpasswdConfirm;
    }
    set lblButtonCreate ( _lblButtonCreate: string) {
        this._lblButtonCreate = _lblButtonCreate;
    }
    set lblButtonClean ( _lblButtonClean: string) { 
        this._lblButtonClean = _lblButtonClean;
    }
    @Input()
    set employee( _employee: DTOEmployee) {
        this._employee = _employee;
    }
}