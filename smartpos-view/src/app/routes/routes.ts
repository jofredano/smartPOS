import { Routes } from '@angular/router';
import { FrameComponent } from '../layout/';
import { Error403Component } from '../shared/global-error-components';
import { Authorization } from '../core/security';

import { LoginComponent, MainComponent, WCreateEmployeeComponent } from "../widgets";

/**
 * @type{Array} objeto que almacena la ruta base sobre la cual se asigna el modulo manejador
 */
export const APP_ROUTES: Routes = [
    { path: '',
      component: FrameComponent,
      children: [
         { path: '', redirectTo: 'login', pathMatch: 'full' },
         { path: 'login' , component: LoginComponent, canActivateChild: [Authorization] },
         { path: 'main'  , component: MainComponent,  canActivateChild: [Authorization] },
         { path: 'admin' , 
             children: [
                { path: 'create-employee' , component: WCreateEmployeeComponent }
             ], 
             canActivateChild: [Authorization] },
      ]
    },
    // errors
    { path: 'access-denied', component: Error403Component},
    // Not found
    { path: '**', redirectTo: 'login' }

];
