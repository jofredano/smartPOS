import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { AngularWebStorageModule, SessionStorage, LocalStorage } from 'angular-web-storage';
import { Observable, Subject } from 'rxjs';
import { share } from 'rxjs/operators';
import { Constants } from '../http';
import { Router } from '@angular/router';
import { OnDestroy } from "@angular/core";

/**
 *  Servicio usado para seguridad de la aplicacion
 */
@Injectable({
  providedIn: 'root'
})
export class FirewallService {
    
    /** codigo de acceso entregado en el logueo */
    @SessionStorage() private _token: string;
    
    /** representa el codigo unico de acceso */
    @LocalStorage() private _access: any;
    
    /** informacion del usuario (alias, clave) */
    private _userInfo: any;
    
    /** Subject para notificar la informacion del usuario  */
    private authState = new Subject<any>();

    /**
     * Constructor de la clase
     * @param HttpClient servicio para hacer peticiones http
     */
    constructor(private http: HttpClient, private router: Router) {
    }
    
    /**
     * Prepara el encabezado con el token
     * @param token
     */
    prepareHeaderRequest(token: string):any {
        let httpOptions = {
            headers: new HttpHeaders({
                'Content-Type' : 'application/json',
                'Authorization': 'Bearer ' + token
            })
        };
        return httpOptions;
    }
    
    /**
     * Prepara el encabezado con el token
     */
    prepareHeaderRequestWithToken(): any {
        return this.prepareHeaderRequest( this._token );
    }
    
    /**
     * Metodo que verifica si el token es valido
     * @param token     Codigo del token a validar
     * @param callback  Funcion callback si se requiere
     */
    applyAccessToken(token: string, callback : Function) {
        this.http.get(Constants.CONTEXT + Constants.SECURITY_ACCES_INFO, 
             this.prepareHeaderRequest(token))
             .subscribe(access => {
                 this.authState.next(access);
                 this._access = access;
                 callback( access );
             }, error => {
                 callback( null );
                 console.log(error);
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
             Constants.CONTEXT + Constants.SECURITY_RESOU_ACCE, { resource: resource });
    }

    /**
     * Devuelve el menu asociado a el usuario
     * @returns devuelve el menu del usuario
     */
    getUserMenu(): Observable<any> {
        return this.http.get(
             Constants.CONTEXT + Constants.SECURITY_MENUS_ACCE, 
             this.prepareHeaderRequest(this._token));
    }
    
    /**
     * Esta funcion invoca el logout completo del sistema, aqui si se cierra la sesion y el usuario debería ingresar sus
     * credenciales si desea volver a ingresar.
     */
    fullLogout(): void {
        //Debe invocar el recurso para cerrar sesion
        const self = this;
        this.http.get(
            Constants.CONTEXT + Constants.SECURITY_CLOSE_ACCE, 
            this.prepareHeaderRequest(this._token))
            .subscribe(access => {
                self.clearObserverForLogin();
            }, error => {
                self.clearObserverForLogin();
                console.log(error);
            });
    }
    
    /**
     * Metodo que realiza logueo en el sistema
     * @param info
     */
    accessUser(info:any): Observable<any> {
        const userinfo = {
            username: info.username,
            password: info.password
        };
        return this.http.post<any>(Constants.CONTEXT + Constants.SECURITY_LOGIN_ACCE, userinfo);
    }

    /**
     * Devuelve un Observable en el cual se notificará el usuario en la sesión.
     * @returns devuelve un stream donde se puede obtener la información del usuario logueado
     */
    getAccessInfo(): Observable<any> {
        const self = this;
        setTimeout(function() {
            //Agregar logica para no realizar tantas veces La pregunta del acceso
            self.applyAccessToken( this._token, function(access) {
                console.log( access );
            });
        }, 500);
        return this.authState.asObservable();
    }

    /**
     * Esta funcion comprueba si un usuario esta logueado en el sistema
     * @returns indica si el usuario esta logueado en el sistema o no
     */
    haveAccess(): boolean {
        //Ajustar metodo para que valide realmente cuando la sesion finaliza
        const today:Date     = new Date();
        const result:boolean = this._access != null && today <= new Date(this._access.fecfin_acceso.split(' ').join('T'));
        return result;
    }

    /**
     * Esta funcion se encarga de eliminar la referencia del Observable que devuelve la información del usuario logueado
     * de esta forma se puede hacer refresh de dicha información solicitandola al backend
     */
    clearObserverForLogin() {
        //Buscar como destruir la informacion almacenada en @LocalStorage
        this._access    = null;
        this._userInfo  = null;
        this._token     = null;
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
