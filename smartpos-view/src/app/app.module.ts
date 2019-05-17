import { BrowserModule } from '@angular/platform-browser';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { NgModule } from '@angular/core';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { HttpClientModule } from '@angular/common/http';
import { APP_BASE_HREF, LocationStrategy, HashLocationStrategy } from '@angular/common';

import { CoreModule } from './core/core.module';
import { LayoutModule  } from './layout/layout.module';
import { SharedModule  } from './shared/shared.module';
import { RoutesModule  } from './routes/routes.module';
import { WidgetsModule  } from './widgets/widgets.module';

import { TooltipModule } from 'ngx-foundation';

import { AppComponent } from './app.component';

@NgModule({
  declarations: [
    AppComponent
  ],
  imports: [
    BrowserModule,
    BrowserAnimationsModule,
    FormsModule,
    ReactiveFormsModule,
    HttpClientModule,
    CoreModule,
    LayoutModule,
    RoutesModule,
    WidgetsModule,
    SharedModule.forRoot(),
    TooltipModule.forRoot()
  ],
  providers: [
    { provide: APP_BASE_HREF, useValue: '/' },
    { provide: LocationStrategy, useClass: HashLocationStrategy }
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
