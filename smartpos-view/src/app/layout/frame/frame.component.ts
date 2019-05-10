import { Component, OnInit, OnDestroy } from '@angular/core';
import { Subscription } from 'rxjs';
import { SidebarService } from '../../core/sidebar';

/**
 * Componente padre para la renderización del Layout de la aplicación
 */
@Component({
  selector: 'app-frame',
  templateUrl: './frame.component.html',
  styleUrls: []
})
export class FrameComponent implements OnInit, OnDestroy {
    
    private menuActiveValue = false;

    private sidebarSuscription: Subscription;

    constructor(private sidebarServiceValue: SidebarService) {}

    ngOnInit(): void {
        this.sidebarSuscription = this.sidebarServiceValue.
           onStatusChanged(status => this.menuActiveValue = status);
    }

    ngOnDestroy(): void {
        this.sidebarSuscription.unsubscribe();
    }
    
    get menuActive(): boolean {
        return this.menuActiveValue;
    }
    
    get sidebarService(): SidebarService {
        return this.sidebarServiceValue;
    }
}

