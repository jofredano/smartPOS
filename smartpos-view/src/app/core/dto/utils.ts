import { DTOCategory } from "./";
import { FormGroup } from '@angular/forms';

export class Utils {
    
    static filter(abbreviation: string, items: Array<DTOCategory>): Array<DTOCategory> {
        let results:Array<DTOCategory> = new Array();
        items.forEach(item => {
            if (item.abbreviation == abbreviation) {
                results.push( item );
            } else if (item.children.length > 0) {
                let children = Utils.filter(abbreviation, item.children);
                children.forEach( element => {
                    results.push( element );                    
                });
            }
        });
        return results;
    }
    
    static matchFields(controlName: string, matchingControlName: string) {
        return (formGroup: FormGroup) => {
            const control = formGroup.controls[controlName];
            const matchingControl = formGroup.controls[matchingControlName];

            if (matchingControl.errors && !matchingControl.errors.mustMatch) {
                return;
            }
            if (control.value !== matchingControl.value) {
                matchingControl.setErrors({ mustMatch: true });
            } else {
                matchingControl.setErrors(null);
            }
        }
    }
    
}