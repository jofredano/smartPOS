
Pasos para crear un nuevo proyecto angular.

1.	Instalar angular cli 
	npm install -g @angular/cli
2.	Crear el nuevo proyecto 
	ng new smartpos-view --style=scss
3.	Instalar foundation en tu equipo
	npm install ngx-foundation foundation-sites --save
4.	Incluir foundation en tu proyecto 
	a.	Ubicar la ruta src/styles.scss en tu proyecto.
	b.	Incluir las siguientes lineas en el archivo mencionado.
		// Import Foundation for Sites
		// See https://foundation.zurb.com/sites/docs/sass.html for detailed info.
		@import '~foundation-sites/scss/foundation';
		  @include foundation-everything;

		// Import Angular ngx-foundation Framework Added Styles
		@import "~ngx-foundation/assets/scss/main";
		
Cualquier otra informacion adicional que se requiera buscar en la siguiente pagina: 

	https://ngxfoundation.com/getting-started
	
	
Instalar componentes para la vista

	a.	recomendable aplicar npm update
	b.	npm install angular-web-storage --save
	c. 	npm install --save rxjs-compat
	d.	npm install --save-dev @types/core-js
	e.	npm install primeng --save
	f.	npm install @angular/cdk --save
	g.	npm install -g npm
	
	en el archivo package.json 
		en el atributo "start" colocar ng serve --host local.suranet.com --open --proxy-config proxy.conf.json
		
		
		
		
import { Routes } from '@angular/router';
import { LayoutComponent } from '../layout/layout.component';
import { Error403Component } from '../shared/global-error-components';
import { AuthorizationGuard } from '../core/security';
import { 
    AcuerdosModificacionComponent, 
    AcuerdosCreacionComponent,
    PartidaCreacionComponent,
    LiquidacionCreacionComponent,
    ReestructuracionCreacionComponent,
    AprobacionesCreacionComponent, 
    ConsultaEstadosComponent,
    AsignacionesDivisionComponent,
    AcuerdoConfiguracionComponent,
    AprobacionConfiguracionComponent,
    PrincipalComponent, 
    MatrizActividadesComponent } from "./vistas";

/**
 * @type{Array} objeto que almacena la ruta base sobre la cual se asigna el modulo manejador
 */
export const APP_ROUTES: Routes = [
    { path: '',
      component: LayoutComponent,
      children: [
         { path: '', redirectTo: 'principal', pathMatch: 'full' },
         { path: 'principal' , component: PrincipalComponent, canActivateChild: [AuthorizationGuard] },
         { path: 'consulta-estados' , component: ConsultaEstadosComponent, canActivateChild: [AuthorizationGuard] },
         { path: 'creacion' , 
           children: [
              { path: 'crear-acuerdos' , component: AcuerdosCreacionComponent },
              { path: 'crear-partidas' , component: PartidaCreacionComponent },
              { path: 'crear-liquidacion' , component: LiquidacionCreacionComponent },
              { path: 'crear-reestructuracion' , component: ReestructuracionCreacionComponent },
              { path: 'crear-aprobaciones' , component: AprobacionesCreacionComponent },
           ], 
           canActivateChild: [AuthorizationGuard] },
         { path: 'modificacion' , 
           children: [
              { path: 'modificar-acuerdos' , component: AcuerdosModificacionComponent },
           ], 
           canActivateChild: [AuthorizationGuard] },
         { path: 'administracion', 
           children: [
              { path: 'divisiones-asignacion'  , component: AsignacionesDivisionComponent },
              { path: 'matriz-actividades'  , component: MatrizActividadesComponent },
              { path: 'configuracion-acuerdo', component: AcuerdoConfiguracionComponent },
              { path: 'configuracion-aprobacion', component: AprobacionConfiguracionComponent }
           ], 
           canActivateChild: [AuthorizationGuard] }
      ]
    },
    // errors
    { path: 'access-denied', component: Error403Component},
    // Not found
    { path: '**', redirectTo: 'principal' }

];

		
Enlaces de interes:
	a.	http://www.igdonline.com/blog/rapido-y-completo-expresiones-regulares-en-php/
		Narra sobre expresiones regulares
	b.	Conversion de fechas y calcular diferencias
		https://programacion.net/articulo/calcular_la_diferencia_entre_dos_fechas_con_php_1566