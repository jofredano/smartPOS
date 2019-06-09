
/**
 * Clase constante que maneja los parametros generales de la aplicacion angular
 */
export class Constants {
 
    /**
     * Contexto de la aplicacion
     * */
    static readonly CONTEXT = '/smart-pos/';

    /** recurso que obtiene la informacion del acceso */
    static readonly SECURITY_ACCES_INFO = 'restservices/srv/users/check';
    
    /** recurso que realiza el inicio de sesion en el sistema */
    static readonly SECURITY_LOGIN_ACCE = 'restservices/srv/users/login';
    
    /** recurso que realiza el cierre de sesion en el sistema */
    static readonly SECURITY_CLOSE_ACCE = 'restservices/srv/users/logout';
    
    /** recurso que verifica si un recurso puede accederlo el usuario */
    static readonly SECURITY_RESOU_ACCE = 'restservices/srv/users/resource';
    
    /** recurso que obtiene el menu asociado a este usuario */
    static readonly SECURITY_MENUS_ACCE = 'restservices/srv/menus/list';
    

    /** recurso que obtiene la informacion del acceso */
    static readonly RESOURCE_CATEGORIES_LIST = 'restservices/srv/categories/list';
    
    /** recurso que obtiene la informacion del acceso */
    static readonly RESOURCE_CREATE_EMPLOYEE = 'restservices/srv/employees/create';
    
}