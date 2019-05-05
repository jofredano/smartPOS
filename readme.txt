
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