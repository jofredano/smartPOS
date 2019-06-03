import { Component, OnInit, OnDestroy } from '@angular/core';
import { Subscription } from 'rxjs';

@Component({
    selector: 'wc-alert',
    templateUrl: 'wc-alert.component.html'
})

export class WcAlertComponent implements OnInit, OnDestroy {
    
    private _message: any;

    constructor() { }

    ngOnInit() {
    }

    ngOnDestroy() {
    }
    
    get message(): any {
        return this._message;
    }
    
    set message( _message: any ) {
        this._message = _message;
    }
}