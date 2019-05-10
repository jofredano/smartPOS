import { NgModule } from '@angular/core';
import { SharedModule } from '../shared/shared.module';
import { SidebarService } from "../core/sidebar";

import { FooterComponent } from './footer/footer.component';
import { HeaderComponent } from './header/header.component';
import { SidebarComponent } from './sidebar/sidebar.component';
import { FrameComponent } from './frame/frame.component';
import { SubmenuComponent } from './sidebar/submenu/submenu.component';

/**
 * Modulo que incluye todos los componentes encargados de renderizar el 
 * layout en el arbol de la aplicación
 */
@NgModule({
  imports: [
    SharedModule
  ],
  declarations: [
    FooterComponent, 
    HeaderComponent, 
    SidebarComponent,
    SubmenuComponent,
    FrameComponent
  ],
  exports: [
    FooterComponent, 
    HeaderComponent, 
    SidebarComponent,
    SubmenuComponent,
    FrameComponent
  ],
  bootstrap: [
    FooterComponent, 
    HeaderComponent, 
    SidebarComponent,
    SubmenuComponent, 
    FrameComponent
  ]
})
export class LayoutModule { }
