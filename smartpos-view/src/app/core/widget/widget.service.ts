import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable, Subject } from 'rxjs';
import { share } from 'rxjs/operators';
import { FirewallService } from '../security';
import { Constants } from '../http';

/**
 *  Servicio usado para seguridad de la aplicacion
 */
@Injectable({
  providedIn: 'root'
})
export class WidgetService {

    /**
     * Constructor de la clase
     * @param HttpClient servicio para hacer peticiones http
     */
    constructor(private http: HttpClient, private firewall : FirewallService) {
    }
    
    /**
     * Devuelve las categorias asociadas a la busqueda
     * @returns devuelve el menu del usuario
     */
    getCategories( abbreviature: string ): Observable<any> {
        return this.http.post(
            Constants.CONTEXT + Constants.RESOURCE_CATEGORIES_LIST, 
            { category: { abbrev : abbreviature } },
            this.firewall.prepareHeaderRequestWithToken() );
    }
    
}