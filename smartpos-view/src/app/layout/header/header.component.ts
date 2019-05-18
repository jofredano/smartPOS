import { Component, OnInit, OnDestroy } from '@angular/core';
import { Subscription } from 'rxjs';
import { SidebarService } from '../../core/sidebar';
import { FirewallService } from '../../core/security';

/**
 * Componente para renderizar el encabezado de la aplicación
 */
@Component({
  selector: 'app-header',
  templateUrl: './header.component.html',
  styleUrls: []
})
export class HeaderComponent implements OnInit, OnDestroy {

  menuActive = false;

  userMenuActive = false;

  private sidebarSuscription: Subscription;

  constructor(private sidebarService: SidebarService, private identityService: FirewallService) {}

  ngOnInit(): void {
    this.sidebarSuscription = this.sidebarService.onStatusChanged(status => this.menuActive = status);
    //this.identityService.getUserInfo().subscribe(userInfo => this.user = userInfo);
  }

  ngOnDestroy(): void {
    this.sidebarSuscription.unsubscribe();
  }

  changeSidebarStatus() {
    this.menuActive = !this.menuActive;
    this.sidebarService.setStatus(this.menuActive);
  }
  
  fullLogout() {
    this.identityService.fullLogout();
  }

  windowClose() {
    window.close();
  }
  
  haveAccess(): boolean {
      return this.identityService.haveAccess();
  }

}


