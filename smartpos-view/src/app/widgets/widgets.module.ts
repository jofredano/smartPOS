import { HttpInterceptRequestService } from '../core/http';

import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { HttpClientModule, HTTP_INTERCEPTORS } from '@angular/common/http';

import { LoginComponent, MainComponent, WtCreateEmployeeComponent, WcAlertComponent } from './';

@NgModule({
    imports: [
      CommonModule,
      FormsModule,
      ReactiveFormsModule
    ],
    providers: [
      { provide: HTTP_INTERCEPTORS, useClass: HttpInterceptRequestService, multi: true }
    ],
    exports: [
       LoginComponent, 
       MainComponent,
       WtCreateEmployeeComponent,
       WcAlertComponent
    ],
    declarations: [
       LoginComponent, 
       MainComponent, 
       WtCreateEmployeeComponent,
       WcAlertComponent
    ],
    bootstrap: [
       LoginComponent, 
       MainComponent, 
       WtCreateEmployeeComponent,
       WcAlertComponent
    ]
})
export class WidgetsModule { }