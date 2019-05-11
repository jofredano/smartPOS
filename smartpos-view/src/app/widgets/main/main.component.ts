import { Component, Input, OnInit, OnDestroy } from '@angular/core';
import { Subscription } from 'rxjs';
import { FirewallService } from '../../core/security';
import { FormControl, FormGroup } from '@angular/forms';
import { Router } from "@angular/router";

/**
 * Componente para renderizar el encabezado de la aplicación
 */
@Component({
  selector: 'app-main',
  templateUrl: './main.component.html',
  styleUrls: []
})
export class MainComponent implements OnInit, OnDestroy {
    
    constructor(private router: Router, private firewallService: FirewallService) {}
    
    ngOnInit(): void {
      //Implementacion cuando se intente destruir el componente
    }

    ngOnDestroy(): void {
        //Implementacion cuando se intente destruir el componente
    }
}