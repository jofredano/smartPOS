import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { HTTP_INTERCEPTORS } from '@angular/common/http';
import { AngularWebStorageModule } from 'angular-web-storage';

import { Authorization, FirewallService } from './security';

import { HttpInterceptRequestService } from './http';

/**
 * Modulo donde se puede realizar instanciación global de clases
 */
@NgModule({
  imports: [
    CommonModule
  ],
  providers: [
    Authorization,
    FirewallService,
    AngularWebStorageModule,
    { provide: HTTP_INTERCEPTORS, 
      useClass: HttpInterceptRequestService, multi: true }
  ],
  declarations: []
})
export class CoreModule {
}
