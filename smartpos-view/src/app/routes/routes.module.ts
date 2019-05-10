import { NgModule } from '@angular/core';
import { RouterModule } from '@angular/router';
import { Routes } from '@angular/router';
import { APP_ROUTES } from './routes';

import { SharedModule } from '../shared/shared.module';
import { WidgetsModule  } from '../widgets/widgets.module';

@NgModule({
  imports: [
    SharedModule,
    WidgetsModule,
    RouterModule.forRoot(APP_ROUTES)
  ]
})
export class RoutesModule { }
