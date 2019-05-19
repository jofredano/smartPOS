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
            name            : new FormControl(),
            lastname        : new FormControl(),
            birth           : new FormControl(),
            bothcity        : new FormControl(),
            address         : new FormControl(),
            phones          : new FormControl(),
            mails           : new FormControl(),
            contractType    : new FormControl(),
            contractNumber  : new FormControl(),
            contractBegin   : new FormControl(),
            contractEnd     : new FormControl(),
            userName        : new FormControl(),
            password1       : new FormControl(),
            password2       : new FormControl()
        });
    }

    ngOnDestroy(): void {
        //Implementacion cuando se intente destruir el componente
    }
    
    create(): void {
        
    }
}