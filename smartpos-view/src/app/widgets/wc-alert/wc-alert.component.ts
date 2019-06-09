import { Component, OnInit, OnDestroy } from '@angular/core';
import { Subscription } from 'rxjs';
import { MessageService } from '../../core';

@Component({
    selector: 'wc-alert',
    templateUrl: 'wc-alert.component.html'
})
export class WcAlertComponent implements OnDestroy {
    
    private _message: any;

    private _subscription: Subscription;

    constructor( private messageService: MessageService ) {
        this.subscription = this.messageService.getMessage().subscribe(
            message => { 
                this.message = message; 
            });
    }
    
    ngOnDestroy() {
        this.subscription.unsubscribe();
    }
    
    get message(): any {
        return this._message;
    }
    
    set message( _message: any ) {
        this._message = _message;
    }
    
    get subscription(): Subscription {
        return this._subscription;
    }
    
    set subscription( _subscription: Subscription ) {
        this._subscription = _subscription;
    }
}