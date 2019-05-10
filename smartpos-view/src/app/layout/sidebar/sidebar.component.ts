import { Component, OnInit } from '@angular/core';
import { SidebarService } from '../../core/sidebar';
import { Router } from '@angular/router';

/**
 * Componente para renderizar el panel lateral derecho de la aplicación
 */
@Component({
  selector: 'app-sidebar',
  templateUrl: './sidebar.component.html',
  styleUrls: []
})
export class SidebarComponent implements OnInit {
  
  /** menú del usuario */
  userMenu: any;

  /**
   * Constructor de la clase
   * @param securityService Servicio de seguridad
   */
  constructor(private sidebarService: SidebarService, private router: Router) {  }

  /**
   * Callback init del componente, aquí se carga el menú del usuario.
   */
  ngOnInit(): void {
    const self = this;
    this.sidebarService.onMenuLoaded().subscribe(menu => {
      self.userMenu = menu;
      self.setMenuAsActive(self.router.url);
    });
  }

  toggleSubmenu(menu: any): void {
    const isActive = menu.active;
    this.sidebarService.inactivateAllItems(this.userMenu.menuItems);
    menu.active = !isActive;
  }

  setMenuAsActive( url: string ): void {
    this.userMenu.menuItems.forEach(item => this.markIfIsActive(item, '/', url));
  }

  markIfIsActive(item: any, baseUrl: string, url: string): void {
    const shouldBeMarked = baseUrl === url || url.indexOf(baseUrl) === 0;
    if (item.children && item.children.length > 0) {
        const childBaseUrl = item.contextPath;
        item.children.forEach(childItem => this.markIfIsActive(childItem, childBaseUrl, url));
    }
    item.active = shouldBeMarked;
  }
}
