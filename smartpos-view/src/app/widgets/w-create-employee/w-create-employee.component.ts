import { Component, Input, OnInit, OnDestroy } from '@angular/core';
import { Subscription } from 'rxjs';
import { FirewallService } from '../../core/security';
import { FormControl, FormGroup } from '@angular/forms';
import { Router } from "@angular/router";

/**
 * Componente para renderizar el encabezado de la aplicación
 */
@Component({
  selector: 'app-w-create-employee',
  templateUrl: './w-create-employee.component.html',
  styleUrls: []
})
export class WCreateEmployeeComponent implements OnInit, OnDestroy {
    
    employeecreate:FormGroup;
    
    constructor(private router: Router, private firewallService: FirewallService) {}
    
    ngOnInit(): void {
      //Implementacion cuando se intente destruir el componente
        this.employeecreate = new FormGroup({
            name: new FormControl()
            //incluir los demas campos....
        });
    }

    ngOnDestroy(): void {
        //Implementacion cuando se intente destruir el componente
    }
    
    create(): void {
        
    }
}