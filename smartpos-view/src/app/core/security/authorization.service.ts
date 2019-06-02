import { Injectable } from '@angular/core';
import { CanActivate, CanActivateChild, ActivatedRouteSnapshot, RouterStateSnapshot, Router} from '@angular/router';
import { Observable } from 'rxjs';
import { FirewallService } from './firewall.service';

/**
 * Servicio que controla la autorizacion de los componentes
 */
@Injectable({
  providedIn: 'root'
})
export class Authorization implements CanActivate, CanActivateChild {

    /**
     * Constructor de la clase
     * @param router objeto para controlar el enrutamiento de la aplicación
     * @param firewall servicio que se conectará con el backend para validar seguridad
     */
    constructor(private router: Router,
                private firewall: FirewallService) {}

    /**
     * funcion implementada por la interface @link{CanActivate}
     * @param route informacion de la ruta o componente
     * @param state estado de la ruta
     * @returns Promise Determina si debe acceder o no
     */
    canActivate(route: ActivatedRouteSnapshot, state: RouterStateSnapshot): Promise<boolean> {
        return this.doActivate(state);
    }

    /**
     * funcion implementada por la interface @link{canActivateChild}
     * @param childRoute    Informacion del componente ruta
     * @param state         Representa el estado de la ruta
     * @returns Promise booleano donde si es True se permite el acceso a la url.
     */
    canActivateChild(childRoute: ActivatedRouteSnapshot, state: RouterStateSnapshot): Promise<boolean> {
        return this.doActivate(state);
    }

    /**
     * realiza la comprobacion de autenticacion e invoca la autorizacion de ser necesario
     * @param   state representa el estado del router en un momento de tiempo
     * @returns Promise booleano donde si es True si esta autenticado o si se permite el acceso a la url.
     */
    doActivate(state: RouterStateSnapshot): Promise<boolean> {
        return new Promise(resolver => {
            //1. Si la ruta a la que se quiere acceder es de login y no tiene acceso (debe pasarla)
            //2. Si la ruta es diferente a login debe preguntar si esta autorizado   (preguntar si debe pasar)
            const mustRedirect = !this.firewall.haveAccess() && (state.url != '/main/login');
            //Verficia que sea /main/login para que se cambie por /main/home
            let urlPath        = (this.firewall.haveAccess() && (state.url == '/main/login'))?'/main/home':state.url.substring(1);
            //Debe verificar si se debe redireccionar
            if (mustRedirect) {
                //Aqui debe estar el problema
                this.router.navigate(['main/login']);
            } else {
                this.checkAuthorization(urlPath, resolver);
            }
        });
    }

    /**
     * Verifica si el usuario puede acceder a esta ruta
     * @param url es la ruta del componente
     * @param resolver permite que se pueda completar el promise.
     */
    checkAuthorization(url: string, resolver: Function) {
        if (url != '/main/login') {
            this.firewall.isAuthorized(url).subscribe(res => {
                if (!res) {
                   this.router.navigate(['access-denied']);
                } else {
                   resolver(res);
                }
            }, error => {
                this.router.navigate(['access-denied']);
                resolver(false);
            }); 
        }
    }

}
