import { DTOCategory } from "./";

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
    
}