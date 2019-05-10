import { Component, Input } from '@angular/core';
import { state, style, trigger, transition, animate } from '@angular/animations';
import { SidebarService } from '../../../core/sidebar';

/**
 * Componente de presentación encargado de rederizar submenus
 */
@Component({
  selector: 'app-submenu',
  templateUrl: './submenu.component.html',
  styleUrls: [],
  animations: [
    trigger('anim', [
      state('false', style({
        height: '0',
        padding: '0'
      })),
      state('true', style({
        height: '*'
      })),
      transition('false => true', animate('250ms ease-in')),
      transition('true => false', animate('250ms ease-out'))
    ])
  ]
})
export class SubmenuComponent {

  constructor(private sidebarService: SidebarService) {
  }

  @Input() itemsMenu: Array<any>;

  @Input() visible: boolean;

  @Input() basePath: string;

  @Input() paddingLeft: number;

  toggleSubmenu(menu: any) {
    const isActive = menu.active;
    this.sidebarService.inactivateAllItems(this.itemsMenu);
    menu.active = !isActive;
  }
}
