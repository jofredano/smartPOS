export interface DTOCategory {
    code:string; 
    abbreviation:string;
    description:string;
    status:number;
    children:DTOCategory[];
}