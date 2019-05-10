import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { AngularWebStorageModule } from 'angular-web-storage';
import { Observable, Subject } from 'rxjs';
import { share } from 'rxjs/operators';

/**
 *  Servicio usado para seguridad de la aplicacion
 */
@Injectable()
export class FirewallService {

    /**
     * Contexto de la aplicacion
     * */
    static readonly CONTEXT = '/smart-pos/';

    /** recurso que obtiene la informacion del acceso */
    static readonly SECURITY_ACCES_INFO = 'restservices/srv/users/check';
    
    /** recurso que realiza el inicio de sesion en el sistema */
    static readonly SECURITY_LOGIN_ACCE = 'restservices/srv/users/login';
    
    /** recurso que realiza el cierre de sesion en el sistema */
    static readonly SECURITY_CLOSE_ACCE = 'restservices/srv/users/logout';
    
    /** recurso que verifica si un recurso puede accederlo el usuario */
    static readonly SECURITY_RESOU_ACCE = 'restservices/srv/users/resource';
    
    /** recurso que obtiene el menu asociado a este usuario */
    static readonly SECURITY_MENUS_ACCE = 'restservices/srv/menus/list';
    
    /** codigo de acceso entregado en el logueo */
    private _token: string;
    
    /** informacion del usuario (alias, clave) */
    private _userInfo: any;
    
    /** representa el codigo unico de acceso */
    private access: any;

    /** Subject para notificar la informacion del usuario  */
    private authState = new Subject<any>();

    /** 
     * Con esto se busca tener una unica instancia y realizar tantas peticiones
     * */
    private observerAccess: Observable<any>;

    /**
     * Constructor de la clase
     * @param HttpClient servicio para hacer peticiones http
     */
    constructor(private http: HttpClient) {
    }

    /**
     * Prepara el encabezado con el token
     * @param token
     */
    static getHeaderToken(token: string):any {
        var headers_object = new HttpHeaders();
            headers_object.append('Content-Type', 'application/json');
        if (token != null) {
            headers_object.append("Authorization", "Bearer " + token);
        }
        const httpOptions = {
            headers: headers_object
        };
        return httpOptions;
    }
    
    /**
     * Esta función se encarga de verificar el acceso del usuario
     * a traves del codigo de acceso asignado
     */
    refreshAccessInfo() {
        if (this.observerAccess == null) {
            this.observerAccess = this.http.get(
               FirewallService.CONTEXT + FirewallService.SECURITY_ACCES_INFO, 
               FirewallService.getHeaderToken(this._token));
        }
        this.observerAccess.subscribe(access => {
           this.authState.next(access);
           this.access = access;
        });
    }

    /**
     * Con esta funcion se puede comprobar si el usuario en la sesion tiene permiso hacia un recurso especifico
     * @param resource url del recurso
     * @returns indica si un usuario tiene acceso a un recurso especifico
     */
    isAuthorized(resource: string): Observable<boolean> {
        //Averiguar como se puede manejar envios POST con header
        return this.http.post<boolean>(
               FirewallService.CONTEXT + FirewallService.SECURITY_RESOU_ACCE, { 
                   resource: resource });
    }

    /**
     * Devuelve el menu asociado a el usuario
     * @returns devuelve el menu del usuario
     */
    getUserMenu(): Observable<any> {
        return this.http.get(
                FirewallService.CONTEXT + FirewallService.SECURITY_MENUS_ACCE, 
                FirewallService.getHeaderToken(this._token));
    }
    
    /**
     * Esta funcion invoca el logout completo del sistema, aqui si se cierra la sesion y el usuario debería ingresar sus
     * credenciales si desea volver a ingresar.
     */
    fullLogout() {
        //Debe invocar el recurso para cerrar sesion
        this.http.get(
            FirewallService.CONTEXT + FirewallService.SECURITY_CLOSE_ACCE, 
            FirewallService.getHeaderToken(this._token));
        // es necesario limpiar el sessionStorage
        this.clearObserverForLogin();
    }
    
    /**
     * Con esta funcion se puede definir si el usuario se logro loguear o no
     * @returns devuelve el objeto de respuesta de logueo
     */
    getLoginAccess(): Observable<any> {
        const userInfoData = this._userInfo;
        return this.http.post<any>(FirewallService.CONTEXT + FirewallService.SECURITY_LOGIN_ACCE, {
            username: userInfoData.username,
            password: userInfoData.password
        });
    }
    
    /**
     * Metodo que realiza logueo en el sistema
     * @param info
     */
    accessUser(info:any): Observable<any> {
        return this.http.post<any>(FirewallService.CONTEXT + FirewallService.SECURITY_LOGIN_ACCE, {
            username: info.username,
            password: info.password
        });
    }

    /**
     * Devuelve un Observable en el cual se notificará el usuario en la sesión.
     * @returns devuelve un stream donde se puede obtener la información del usuario logueado
     */
    getAccessInfo(): Observable<any> {
        const self = this;
        setTimeout(function() {
            //Agregar logica para no realizar tantas veces 
            //La pregunta del acceso
            self.refreshAccessInfo();
        }, 500);
        return this.authState.asObservable();
    }

    /**
     * Esta funcion comprueba si un usuario esta logueado en el sistema
     * @returns indica si el usuario esta logueado en el sistema o no
     */
    haveAccess(): boolean {
        const today:Date = new Date();
        return this.access != null && today <= new Date(this.access.fecfin_acceso.split(' ').join('T'));
    }

    /**
     * Esta funcion se encarga de eliminar la referencia del Observable que devuelve la información del usuario logueado
     * de esta forma se puede hacer refresh de dicha información solicitandola al backend
     */
    clearObserverForLogin() {
        this.observerAccess = null;
        this.access = null;
        this._userInfo = null;
    }
    
    get userInfo(): any {
        return this._userInfo;
    }
    
    set userInfo(_userInfo: any) {
        this._userInfo = _userInfo;
    }
    
    get token(): string {
        return this._token;
    }
    
    set token(_token: string) {
        this._token = _token;
    }
}
