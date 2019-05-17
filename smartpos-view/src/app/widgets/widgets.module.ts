import { HttpInterceptRequestService } from '../core/http';

import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { HttpClientModule, HTTP_INTERCEPTORS } from '@angular/common/http';

import { LoginComponent, MainComponent, WCreateEmployeeComponent } from './';

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
       WCreateEmployeeComponent
    ],
    declarations: [
       LoginComponent, 
       MainComponent, 
       WCreateEmployeeComponent
    ],
    bootstrap: [
       LoginComponent, 
       MainComponent, 
       WCreateEmployeeComponent
    ]
})
export class WidgetsModule { }