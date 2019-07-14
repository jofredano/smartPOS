import { Injectable } from '@angular/core';
import { Subject, Subscription, Observable } from 'rxjs';
import { FirewallService } from '../security';
import { MessageService } from '../widget';

/**
 * Servicio para gestionar el estado del menu
 */
@Injectable( {providedIn: 'root' } )
export class SidebarService {

  /**
   * Subject que emite el estado de menú (activo o inactivo)
   */
  private status: Subject<boolean>;

  /**
   * Subject que emite el menú cargado
   */
  private stream: Subject<any>;

  /**
   * Constructor
   * @param firewallService Servicio de identidad de usuario
   */
  constructor(private firewallService: FirewallService, private messageService: MessageService) {
    this.status     = new Subject<boolean>();
    this.stream     = new Subject<any>();
    const self      = this;
    setTimeout(() => {
        self.loadOptionsMenu();
    }, 300);
  }

  /**
   * Invocar para emitir un nuevo estado del menú
   * @param isActive true si esta activo, false en caso contrario
   */
  setStatus(isActive) {
     this.status.next(isActive);
  }

  /**
   * Invocar para emitir un nuevo menú
   * @param menu MenuHeader
   */
  setOptionMenu(menu: any) {
     this.stream.next(menu);
  }

  /**
   * Permite suscriberse al estado del menú
   * @param observer observador: callback
   */
  onStatusChanged(observer): Subscription {
    return this.status.subscribe(observer);
  }

  /**
   * Permite suscribrse a la carga del menú
   */
  onMenuLoaded(): Observable<any> {
    return this.stream.asObservable();
  }

  /**
   * Metodo que carga la informacion del menu para el usuario logueado
   */
  loadOptionsMenu() {
     this.firewallService.getUserMenu().subscribe(userMenu => {
        const menuUser = userMenu;
        this.inactivateAllItems(menuUser.menuItems);
        this.setOptionMenu(menuUser);
     }, error => { 
        this.messageService.sendMessage( { type: 'error', text: error.error.message });
     });
  }

  /**
   * Desactiva todos los items del menú de forma recursiva
   * @param items items del menú que se van a desactivar
   */
  inactivateAllItems(items: Array<any>): void {
    if(items != undefined) {
       items.forEach(value => {
          value.active = false;
          if (value.children && value.children.length > 0) {
              this.inactivateAllItems(value.children);
          }
       });        
    }
  }

  /**
   * Ordena los items del menú basandose en su atributo order (si el menú es enviado desde SEUS,
   * entonces no necesita ordenar pues ya viene ordenado)
   * @param items items del menú
   */
  order(items: Array<any>): void {
    items.sort((itemA, itemB) =>  {
        if (itemA.children && itemA.children.length > 0) {
            this.order(itemA.children);
        }
        return itemA.order - itemB.order;
    });
  }

}
