import { NgModule, ModuleWithProviders } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';
import { FormsModule } from '@angular/forms';

import { Error403Component } from './global-error-components';

import { InputTextModule } from 'primeng/primeng';
import { ButtonModule } from 'primeng/primeng';
import { CheckboxModule } from 'primeng/primeng';
import { ScrollPanelModule } from 'primeng/primeng';

/**
 *  Modulo donde se puede realizar instanciacion modular de clases
 */
@NgModule({
  imports: [
    CommonModule,
    RouterModule
  ],
  declarations: [
    Error403Component
  ],
  exports: [
    CommonModule,
    RouterModule,
    FormsModule,
    InputTextModule,
    ButtonModule,
    CheckboxModule,
    ScrollPanelModule,
    Error403Component
  ]
})
export class SharedModule {
  static forRoot(): ModuleWithProviders {
    return {
        ngModule: SharedModule
    };
  }
}
