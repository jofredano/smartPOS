import { Routes } from '@angular/router';
import { FrameComponent } from '../layout/';
import { Error403Component } from '../shared/global-error-components';
import { Authorization } from '../core/security';

import { LoginComponent, MainComponent, WtCreateEmployeeComponent } from "../widgets";

/**
 * @type{Array} objeto que almacena la ruta base sobre la cual se asigna el modulo manejador
 */
export const APP_ROUTES: Routes = [
    { path: '',
      component: FrameComponent,
      children: [
         { path: ''     , redirectTo: 'main/home' , pathMatch: 'full' },
         { path: 'main' , 
             children: [
                { path: 'home'  , component: MainComponent  },
                { path: 'login' , component: LoginComponent },
             ], 
             canActivateChild: [Authorization] },
         { path: 'administracion' , 
             children: [
                { path: 'empleado-crear' , component: WtCreateEmployeeComponent }
             ], 
             canActivateChild: [Authorization] },
      ]
    },
    // errors
    { path: 'access-denied', component: Error403Component},
    // Not found
    { path: '**', redirectTo: 'main/login' }

];
