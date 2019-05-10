import { NgModule } from '@angular/core';
import { RouterModule } from '@angular/router';
import { Routes } from '@angular/router';
import { SharedModule } from '../shared/shared.module';
import { APP_ROUTES } from './routes';

@NgModule({
  imports: [
    SharedModule,
    RouterModule.forRoot(APP_ROUTES)
  ]
})
export class RoutesModule { }
