import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { SessionStorageService } from 'ng2-webstorage';
import { Observable } from 'rxjs/Observable';
import { Subject } from 'rxjs/Subject';
import { share } from 'rxjs/operators/share';

/**
 *  Servicio usado para gestionar la seguridad del usuario
 */
@Injectable()
export class IdentityService {

    /**
     * Contexto de la aplicacion
     * */
    private CONTEXT:string = '';
    
    /** representa el codigo unico de acceso */
    private access: any;

    /** Subject para notificar la informacion del usuario  */
    private authState = new Subject<any>();

    /**
     *  Almacena una referencia hacia el observable que obtiene la información del usuario y lo marca de tipo share para que
     *  no se haga una misma peticion multiples veces
     */
    private observerAccess: Observable<any>;

    /**
     * Constructor de la clase
     * @param HttpClient servicio para hacer peticiones http
     */
    constructor(private http: HttpClient) {
    }

    /**
     * Esta función se encarga de verificar el acceso del usuario
     * a traves del codigo de acceso asignado
     */
    refreshAccessInfo() {
        if (this.observerAccess == null) {
            this.observerAccess = this.http.get(this.CONTEXT + Constants.SECURITY_USER_INFO);
        }
        this.observerAccess.subscribe(access => {
           this.authState.next(access);
           this.access = access;
        });
    }

    /**
     * Devuelve un Observable en el cual se notificará el usuario en la sesión.
     * @returns devuelve un stream donde se puede obtener la información del usuario logueado
     */
    getUserInfo(): Observable<any> {
        const self = this;
        setTimeout(function() {
            self.refreshAccessInfo();
        }, 500);
        return this.authState.asObservable();
    }

    /**
     * Devuelve el menu asociado a el usuario
     * @returns devuelve el menu del usuario
     */
    getUserMenu(): Observable<string> {
        //Aqui debe consumir el servicio de menu a traves del token
        return null;
    }

    /**
     * Con esta funcion se puede definir si el usuario se logro loguear o no
     * @returns devuelve el objeto de respuesta de logueo
     */
    getLoginForm(username: string, password: string): Observable<string> {
        return this.http.post<string>(this.CONTEXT + Constants.SECURITY_CHECK_STATUS, {
            username: username,
            password: password
        });
    }

    /**
     * Esta funcion comprueba si un usuario esta logueado en el sistema
     * @returns indica si el usuario esta logueado en el sistema o no
     */
    isLoggedIn(): boolean {
        return this.access != null;
    }

    /**
     * Con esta funcion se puede comprobar si el usuario en la sesion tiene permiso hacia un recurso especifico
     * @param resource url del recurso
     * @returns indica si un usuario tiene acceso a un recurso especifico
     */
    isAuthorized(resource: string): Observable<boolean> {
        return this.http.post<boolean>(this.CONTEXT + Constants.SECURITY_USER_ACCESS, resource);
    }

    /**
     * Esta funcion realiza el logout parcial del sistema, no cierra la sesion.
     */
    partialLogout() {
        window.location.href = '/logout';
    }

    /**
     * Esta funcion invoca el logout completo del sistema, aqui si se cierra la sesion y el usuario debería ingresar sus
     * credenciales si desea volver a ingresar.
     */
    fullLogout() {
        // es necesario limpiar el sessionStorage
        this.clearObserverForLogin();
    }

    /**
     * Esta funcion se encarga de eliminar la referencia del Observable que devuelve la información del usuario logueado
     * de esta forma se puede hacer refresh de dicha información solicitandola al backend
     */
    clearObserverForLogin() {
        this.observerAccess = null;
        this.access = null;
    }
}
