import { Component, Input, OnInit, OnDestroy } from '@angular/core';
import { Subscription } from 'rxjs';
import { FirewallService, WidgetService } from '../../core';
import { DTOEmployee, DTOCategory, Utils } from '../../core/dto';
import { FormControl, FormGroup } from '@angular/forms';
import { filter } from 'rxjs/operators';

/**
 * Componente para renderizar el encabezado de la aplicación
 */
@Component({
  selector: 'app-w-create-employee',
  templateUrl: './w-create-employee.component.html',
  styleUrls: []
})
export class WCreateEmployeeComponent implements OnInit, OnDestroy {
    
    private _lblInputTypePerson: string;
    
    private _lblTittleForm: string;

    private _lblInputIdType: string;

    private _lblInputIdNumber: string;

    private _lblInputName: string;

    private _lblInputLastname: string;
    
    private _lblInputBirth: string;
    
    private _lblInputBothCity: string;
    
    private _lblInputAddress: string;

    private _lblInputCity: string;
    
    private _lblInputPhones: string;
    
    private _lblInputMails: string;
    
    private _lblInputContractType: string;
    
    private _lblInputContractNumber: string;
    
    private _lblInputContractBegin: string;
    
    private _lblInputContractEnd: string;
    
    private _lblInputUsername: string;
    
    private _lblInputUserpasswd: string;
    
    private _lblInputUserpasswdCon: string;
    
    private _lblButtonCreate: string;
    
    private _lblButtonClean: string;

    private _employee: DTOEmployee = {
        id: {
            type: '',
            number: ''
        },
        type: 'PERSONA.TIPO.NATURAL',
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

    private _categories: Array<any>;

    private _typesPerson: Array<any>;

    private _typesIdentification: Array<any>;

    private _typesContract: Array<any>;


    constructor(private firewallService: FirewallService, private widgetService: WidgetService) {
        this.initLabels();
    }
    
    ngOnInit(): void {
        //Implementacion cuando se intente destruir el componente
        this.loadCategories();
    }

    ngOnDestroy(): void {
        //Implementacion cuando se intente destruir el componente
    }
    
    loadCategories(): void {
        const self = this;
        //Implementacion para la catga de categorias
        this.widgetService.getCategories( 'PERSONA.TIPO,CONTRATO.TIPO' ).subscribe(
           categories => {
              self.categories = categories.items;
              self.loadTypePersonList( categories.items );
              self.loadContractTypeList( categories.items );
              self.loadTypeIdentification( 'PERSONA.TIPO.NATURAL' );
           }, error   => {
              console.log( error );
           });
    }
    
    loadTypePersonList(categories: Array<DTOCategory>) : void { 
        let personTypes      = Utils.filter('PERSONA.TIPO', categories);
        this.typesPerson     = personTypes[0].children;
    }
    
    loadContractTypeList(categories: Array<DTOCategory>) : void { 
        let personTypes      = Utils.filter('CONTRATO.TIPO', categories);
        this.typesContract   = personTypes[0].children;
    }
    
    loadTypeIdentification(abbreviation: string): void {
        let identificationTypes     = Utils.filter(abbreviation, this.categories);
        this.typesIdentification    = identificationTypes[0].children;
    }
    
    initLabels(): void {
        this.lblTittleForm              = 'Contratando un nuevo empleado';
        this.lblInputTypePerson         = 'Tipo de persona';
        this.lblInputIdType             = 'Tipo de identificación';
        this.lblInputIdNumber           = 'Número de identificación';
        this.lblInputName               = 'Nombres del empleado';
        this.lblInputLastname           = 'Apellidos del empleado';
        this.lblInputBirth              = 'Fecha de nacimiento';
        this.lblInputBothCity           = 'Ciudad de nacimiento';
        this.lblInputAddress            = 'Direcciones';
        this.lblInputCity               = 'Ciudad de residencia';
        this.lblInputPhones             = 'Teléfonos de contacto';
        this.lblInputMails              = 'Correos electrónicos';
        this.lblInputContractType       = 'Tipo de contrato';
        this.lblInputContractNumber     = 'Número de contrato';
        this.lblInputContractBegin      = 'Fecha de inicio (contrato)';
        this.lblInputContractEnd        = 'Fecha final (contrato)';
        this.lblInputUsername           = 'Nombre de usuario';
        this.lblInputUserpasswd         = 'Contraseña';
        this.lblInputUserpasswdCon      = 'Contraseña (confirmar)';
        this.lblButtonCreate            = 'Crear';
        this.lblButtonClean             = 'Limpiar';        
    }
    
    create(): void {
        console.log(this._employee);
    }
    
    get categories(): Array<any> {
        return this._categories;
    }
    get typesPerson(): Array<any> {
        return this._typesPerson;
    }
    get typesIdentification(): Array<any> {
        return this._typesIdentification;
    }
    get typesContract(): Array<any> {
        return this._typesContract;
    }

    get lblTittleForm(): string {
        return this._lblTittleForm;
    }
    get lblInputTypePerson(): string {
        return this._lblInputTypePerson;
    }
    get lblInputIdType(): string {
        return this._lblInputIdType;
    }
    get lblInputIdNumber(): string {
        return this._lblInputIdNumber;
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
    get lblInputCity(): string {
        return this._lblInputCity;
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
    get lblInputUserpasswdCon(): string {
        return this._lblInputUserpasswdCon;
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

    set categories( _categories: Array<any> ) {
        this._categories = _categories;
    }    
    set typesPerson( _typesPerson: Array<any> ) {
        this._typesPerson = _typesPerson;
    }
    set typesIdentification( _typesIdentification: Array<any> ) {
        this._typesIdentification = _typesIdentification;
    }
    set typesContract( _typesContract : Array<any> ) {
        this._typesContract = _typesContract;
    }
    
    set lblTittleForm ( _lblTittleForm: string) { 
        this._lblTittleForm = _lblTittleForm;
    }
    set lblInputTypePerson( _lblInputTypePerson: string ) {
        this._lblInputTypePerson = _lblInputTypePerson;
    }
    set lblInputIdType( _lblInputIdType: string ) {
        this._lblInputIdType = _lblInputIdType;
    }
    set lblInputIdNumber( _lblInputIdNumber: string ) {
        this._lblInputIdNumber = _lblInputIdNumber;
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
    set lblInputCity ( _lblInputCity:string ) {
        this._lblInputCity = _lblInputCity;
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
    set lblInputUserpasswdCon ( _lblInputUserpasswdCon: string) { 
        this._lblInputUserpasswdCon = _lblInputUserpasswdCon;
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