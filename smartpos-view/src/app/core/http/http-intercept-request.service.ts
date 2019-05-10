import { Injectable } from '@angular/core';
import { Router } from '@angular/router';
import { HttpInterceptor, HttpRequest, HttpHandler, HttpEvent, HttpErrorResponse, HttpEventType } from '@angular/common/http';
import { Observable } from 'rxjs/Observable';
import { Subject } from 'rxjs/Subject';
import { throwError } from 'rxjs';
import 'rxjs/add/operator/do';

/**
 * Permite usar instrucciones jquery
 */
declare var $: any;

/**
 * Interceptor HTTP cuya responsabilidad es controlar la autorizacion y autenticacion global de peticiones hacia el backend
 */
@Injectable()
export class HttpInterceptRequestService implements HttpInterceptor {

    /**
     * Constructor de la clase
     * @param {Router} router objeto para controlar el enrutamiento de la aplicacion
     */
    constructor(private router: Router) {
    }

    showMessageInterceptor(event: HttpEvent<any>, message: string): void {
        console.log(message);
        if ($('body .loading-progress').length <= 0 && event.type !== HttpEventType.Response) {
            $('body').append(
               '<div class="loading-progress">' +
               '  <div class="loading">' +
               '  <i class="fa fa-circle-o-notch fa-spin" style="font-size:24px"></i>' +
               '  <span>Cargando</span>' +
               '</div>' +
               '</div>');
        }
    }

    hideMessageInterceptor(): void {
        if ($('body .loading-progress').length) {
            $('body .loading-progress').remove();
        }
    }

    intercept(req: HttpRequest<any>, next: HttpHandler): Observable<HttpEvent<any>> {
        req.headers.append('X-APP-RELAYSTATE', this.router.url);
        return next.handle(req).do((event: HttpEvent<any>) => {
            this.hideMessageInterceptor();
            switch (event.type) {
              case HttpEventType.Sent:
                 this.showMessageInterceptor(event, 'Peticion enviada!');
                 break;
              case HttpEventType.ResponseHeader:
                 this.showMessageInterceptor(event, 'Respuesta de encabezado recibida!');
                 break;
              case HttpEventType.Response:
                 this.showMessageInterceptor(event, 'Realizado!');
                 break;
              default:
                 break;
            }
        }, (err: any) => {
            this.hideMessageInterceptor();
            if (err instanceof HttpErrorResponse) {
                switch (err.status) {
                    case 401:
                        // Presenta la pagina de login desde seus
                        document.write(err.error);
                        return throwError(err);
                    case 403:
                        this.router.navigate(['/access-denied']);
                        return throwError(err);
                    default:
                        return throwError(err);
                }
            }
        });
    }
}
