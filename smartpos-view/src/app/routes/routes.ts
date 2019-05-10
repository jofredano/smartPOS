import { Routes } from '@angular/router';
import { FrameComponent } from '../layout/';
import { Error403Component } from '../shared/global-error-components';
import { Authorization } from '../core/security';

/**
 * @type{Array} objeto que almacena la ruta base sobre la cual se asigna el modulo manejador
 */
export const APP_ROUTES: Routes = [
    { path: '',
      component: FrameComponent,
      children: [
         { path: '', redirectTo: 'principal', pathMatch: 'full' },
      ]
    },
    // errors
    { path: 'access-denied', component: Error403Component},
    // Not found
    { path: '**', redirectTo: 'principal' }

];
