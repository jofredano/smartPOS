import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { HTTP_INTERCEPTORS } from '@angular/common/http';
import { SessionStorageService } from 'ng2-webstorage';

import { HttpInterceptRequestService } from './http';

/**
 * Modulo donde se puede realizar instanciación global de clases
 */
@NgModule({
  imports: [
    CommonModule
  ],
  providers: [
    SessionStorageService,
    { provide: HTTP_INTERCEPTORS, 
      useClass: HttpInterceptRequestService, multi: true }
  ],
  declarations: []
})
export class CoreModule {
}
