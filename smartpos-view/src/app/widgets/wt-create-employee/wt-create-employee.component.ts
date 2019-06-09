import { Component, Input, OnInit, OnDestroy } from '@angular/core';
import { FormBuilder, FormControl, FormGroup, Validators } from '@angular/forms';
import { filter } from 'rxjs/operators';
import { Subscription } from 'rxjs';
import { FirewallService, WidgetService, MessageService } from '../../core';
import { DTOEmployee, DTOCategory, Utils } from '../../core/dto';


/**
 * Componente para renderizar el encabezado de la aplicación
 */
@Component({
  selector: 'app-wt-create-employee',
  templateUrl: './wt-create-employee.component.html',
  styleUrls: []
})
export class WtCreateEmployeeComponent implements OnInit, OnDestroy {
    
    registerEmployee: FormGroup;

    private _lblTittleForm: string;
    private _lblInputTypePerson: string;
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

    private _errInputIdType: string;
    private _errInputIdNumber: string;
    private _errInputName: string;
    private _errInputLastname: string;
    private _errInputBirth: string;
    private _errInputBothCity: string;
    private _errInputAddress: string;
    private _errInputCity: string;
    private _errInputPhones: string;
    private _errInputMails: string;
    private _errInputContractType: string;
    private _errInputContractNumber: string;
    private _errInputContractBegin: string;
    private _errInputContractEnd: string;
    private _errInputUsername: string;
    private _errInputUserpasswd: string;
    private _errInputUserpasswdCon: string;

    private _lblButtonCreate: string;
    private _lblButtonClean: string;

    private _employee: DTOEmployee = {
        id: {
            type: '',
            number: ''
        },
        type: '',
        name: '',
        lastname: '',
        birth: null,
        bothcity: '',
        address: '',
        phones: '',
        mails: '',
        agreement: {
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

    private _submitted: boolean;


    constructor(
       private formBuilder: FormBuilder, 
       private firewallService: FirewallService, 
       private widgetService: WidgetService, 
       private messageService: MessageService) {
       this.initLabels();
       this.submitted = false;
    }
    
    ngOnInit(): void {
        this.registerEmployee = this.formBuilder.group({
            'employee.type':            ['PERSONA.TIPO.NATURAL', Validators.required],
            'employee.id.type':         ['', Validators.required],
            'employee.id.number':       ['', Validators.required],
            'employee.name':            ['', Validators.required],
            'employee.lastname':        ['', Validators.required],
            'employee.birth':           ['', Validators.required],
            'employee.bothcity':        ['', Validators.required],
            'employee.address':         ['', Validators.required],
            'employee.city':            ['', Validators.required],
            'employee.phones':          ['', Validators.required],
            'employee.mails':           ['', [Validators.required, Validators.email]],
            'employee.contract.type':   ['', Validators.required],
            'employee.contract.number': ['', Validators.required],
            'employee.contract.begin':  ['', Validators.required],
            'employee.contract.end':    [''],
            'employee.user.name':       ['', [Validators.required, Validators.minLength(8)]],
            'employee.user.password1':  ['', [Validators.required, Validators.minLength(6)]],
            'employee.user.password2':  ['', [Validators.required, Validators.minLength(6)]]
        }, {
            validator: Utils.matchFields('employee.user.password1', 'employee.user.password2')
        });
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
        
        this.errInputIdType             = 'Debe seleccionar un tipo de identificación válido';
        this.errInputIdNumber           = 'Número de identificación inválido';
        this.errInputName               = 'Nombre inválido';
        this.errInputLastname           = 'Apellido inválido';
        this.errInputBirth              = 'Fecha de nacimiento inválida';
        this.errInputBothCity           = 'Ciudad de nacimiento inválida';
        this.errInputAddress            = 'Dirección inválida';
        this.errInputCity               = 'Ciudad de residencia inválida';
        this.errInputPhones             = 'Teléfonos inválidos';
        this.errInputMails              = 'Correo inválido';
        this.errInputContractType       = 'Tipo de contrato inválido';
        this.errInputContractNumber     = 'Número de contrato inválido';
        this.errInputContractBegin      = 'Fecha seleccionada inválida';
        this.errInputContractEnd        = 'Fecha seleccionada inválida';
        this.errInputUsername           = 'Nombre de usuario inválido';
        this.errInputUserpasswd         = 'Contraseña inválida';
        this.errInputUserpasswdCon      = 'Contraseña inválida';
        
        this.lblButtonCreate            = 'Crear';
        this.lblButtonClean             = 'Limpiar';        
    }
    
    mustQuestionTypeUndefined(): boolean {
        return (this.registerEmployee.value['employee.contract.type'] == 'CONTRATO.TIPO.INDEFINIDO');
    }
    
    create(): void {
        this.submitted = true;
        if (this.registerEmployee.invalid) {
            this.messageService.sendMessage( { type: 'error', text: 'Debe diligenciar los datos del formulario de manera correcta' });
        } else {
           let employee: DTOEmployee = {
               id: {
                   type       : this.registerEmployee.value['employee.id.type'],
                   number     : this.registerEmployee.value['employee.id.number']
               },
               type           : this.registerEmployee.value['employee.type'],
               name           : this.registerEmployee.value['employee.name'],
               lastname       : this.registerEmployee.value['employee.lastname'],
               birth          : this.registerEmployee.value['employee.birth'],
               bothcity       : this.registerEmployee.value['employee.bothcity'],
               address        : this.registerEmployee.value['employee.address'],
               phones         : this.registerEmployee.value['employee.phones'],
               mails          : this.registerEmployee.value['employee.mails'],
               agreement      : {
                   type       : this.registerEmployee.value['employee.contract.type'],
                   number     : this.registerEmployee.value['employee.contract.number'],
                   begin      : this.registerEmployee.value['employee.contract.begin'],
                   end        : this.registerEmployee.value['employee.contract.end']
               },
               user           : {
                   name       : this.registerEmployee.value['employee.user.name'],
                   password   : this.registerEmployee.value['employee.user.password1'],
                   //Se tiene que realizar otro servicio para obtener los roles
                   //que puede crear este usuario
                   role       : 'ROL.ADMINISTRADOR'
               }
           };
           //Se transforma a objeto de empleado
           this.widgetService.createEmployee( employee ).subscribe(
               response => {
                   this.messageService.sendMessage( { type: 'success', text: response });
                   console.log(employee); 
                }, error   => {
                   this.messageService.sendMessage( { type: 'error', text: error.error }); 
                });
        }
    }
    
    get fields() { 
        return this.registerEmployee.controls; 
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

    get errInputIdType(): string {
        return this._errInputIdType;
    }
    get errInputIdNumber(): string {
        return this._errInputIdNumber;
    }
    get errInputName(): string {
        return this._errInputName;
    }
    get errInputLastname(): string {
        return this._errInputLastname;
    }
    get errInputBirth(): string {
        return this._errInputBirth;
    }
    get errInputBothCity(): string {
        return this._errInputBothCity;
    }
    get errInputAddress(): string {
        return this._errInputAddress;
    }
    get errInputCity(): string {
        return this._errInputCity;
    }
    get errInputPhones(): string {
        return this._errInputPhones;
    }
    get errInputMails(): string {
        return this._errInputMails;
    }
    get errInputContractType(): string {
        return this._errInputContractType;
    }
    get errInputContractNumber(): string {
        return this._errInputContractNumber;
    }
    get errInputContractBegin(): string {
        return this._errInputContractBegin;
    }
    get errInputContractEnd(): string {
        return this._errInputContractEnd;
    }
    get errInputUsername(): string {  
        return this._errInputUsername;
    }
    get errInputUserpasswd(): string  {
        return this._errInputUserpasswd;
    }
    get errInputUserpasswdCon(): string {
        return this._errInputUserpasswdCon;
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
    
    get submitted(): boolean {
        return this._submitted;
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

    set errInputIdType( _errInputIdType: string ) {
        this._errInputIdType = _errInputIdType;
    }
    set errInputIdNumber( _errInputIdNumber: string ) {
        this._errInputIdNumber = _errInputIdNumber;
    }
    set errInputName ( _errInputName: string) { 
        this._errInputName = _errInputName;
    }
    set errInputLastname ( _errInputLastname: string) { 
        this._errInputLastname = _errInputLastname;
    }
    set errInputBirth ( _errInputBirth: string) { 
        this._errInputBirth = _errInputBirth;
    }
    set errInputBothCity ( _errInputBothCity: string) { 
        this._errInputBothCity = _errInputBothCity;
    }
    set errInputAddress ( _errInputAddress: string) { 
        this._errInputAddress = _errInputAddress;
    }
    set errInputCity ( _errInputCity:string ) {
        this._errInputCity = _errInputCity;
    }
    set errInputPhones ( _errInputPhones: string) { 
        this._errInputPhones = _errInputPhones;
    }
    set errInputMails( _errInputMails: string) { 
        this._errInputMails = _errInputMails;
    }
    set errInputContractType ( _errInputContractType: string) { 
        this._errInputContractType = _errInputContractType;
    }
    set errInputContractNumber ( _errInputContractNumber: string) { 
        this._errInputContractNumber = _errInputContractNumber;
    }
    set errInputContractBegin ( _errInputContractBegin: string) {
        this._errInputContractBegin = _errInputContractBegin;
    }
    set errInputContractEnd ( _errInputContractEnd: string) { 
        this._errInputContractEnd = _errInputContractEnd;
    }
    set errInputUsername ( _errInputUsername: string) { 
        this._errInputUsername = _errInputUsername;
    }
    set errInputUserpasswd ( _errInputUserpasswd: string) { 
        this._errInputUserpasswd = _errInputUserpasswd;
    }
    set errInputUserpasswdCon ( _errInputUserpasswdCon: string) { 
        this._errInputUserpasswdCon = _errInputUserpasswdCon;
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
    
    set submitted( _submited: boolean) {
        this._submitted = _submited;
    }
}