---
_edit_last: "2"
_jetpack_related_posts_cache:
  8f6677c9d6b0f903e98ad32ec61f8deb:
    expires: 1771593714
    payload:
      - id: 101
      - id: 760
      - id: 750
_wpas_done_all: "1"
_wpcom_is_markdown: "1"
author: guisho Luis H. Fernandez
categories:
  - software-engineering
date: "2009-04-28T20:57:49+00:00"
guid: http://software.guisho.com/?p=55
parent_post_id: null
post_id: "752"
rank_math_internal_links_processed: "1"
rank_math_robots:
  - index
summary: |-
  Los patrones creacionales (creational patterns) son aquellos que tienen que ver con la creación (duh!) de objetos. La razón de ser de estos patrones es para facilitar, ordenar, o ayudar en la creación de objetos. Dependiendo del lenguage de programación que estemos utilizando, generalmente crearemos un objeto así: Objeto o = new Objeto(). Pues bueno, en los patrones creacionales las cosas cambian un poquito, y probablemente ahora crearemos un objeto así Objeto o = ObjectoFactory.getInstance("x");, o algo parecido.
  Hoy hablaremos del más famoso de los patrones de creación: en Factory Pattern (Patrón de fábrica). Utilizaremos los nombres ingleses porque creo que son más claros que las traducciones que se podrían hacer. Además, en software de todos lados, es más estandar utilizar el inglés en ciertas nomenclaturas para facilitar que otros lean nuestro código. Buhh, alguien alega por ahí, pero reconzcámoslo: programamos en inglés.
tags:
  - factory-pattern
  - patrones
  - patrones-creacionales
  - patrones-de-diseño
  - patrón-de-fábrica
  - software
title: Factory Pattern - Patrones
url: /patrones-de-diseno-factory-pattern/
views: "28007"

---
Los patrones creacionales (creational patterns) son aquellos que tienen que ver con la creación (duh!) de objetos. La razón de ser de estos patrones es para facilitar, ordenar, o ayudar en la creación de objetos. Dependiendo del lenguage de programación que estemos utilizando, generalmente crearemos un objeto así: Objeto o = new Objeto(). Pues bueno, en los patrones creacionales las cosas cambian un poquito, y probablemente ahora crearemos un objeto así Objeto o = ObjectoFactory.getInstance("x");, o algo parecido.

Hoy hablaremos del más famoso de los patrones de creación: en Factory Pattern (Patrón de fábrica). Utilizaremos los nombres ingleses porque creo que son más claros que las traducciones que se podrían hacer. Además, en software de todos lados, es más estandar utilizar el inglés en ciertas nomenclaturas para facilitar que otros lean nuestro código. Buhh, alguien alega por ahí, pero reconzcámoslo: programamos en inglés.

Como todo se entiende mejor con un ejemplo -al menos eso creo yo-, comenzaremos con uno. Supongamos se nos encarga crear un traductor que devuelva los números del cero al diez en tres idiomas: inglés, español, y alemán. Existen muchísimas maneras de hacer esto. Al final, se desea un método que reciba un entero entre 0 y 10 y que devuelva una cadena con el nombre de dicho número en el idioma que se esté trabajando.

Una manera de entrarle al problema podría ser algo así:

```
public class MainClient {
public MainClient(){
     }

	public traducirNumero(String idioma, int numero){
		if (idioma.equals("español")){
		  switch (numero){
		     case 0: return "uno";
		     case 1: return "dos";
		    ....
		   }
		}

		if (idioma.equals("english")){
		    switch (numero){
		     case 0: return "one";
		     case 1: return "two";
		    ....
		    }
		}

		if (idioma.equals("deutsch")){
		    switch (numero){
		     case 0: return "eins";
		     case 1: return "zwei";
		    ....
		    }
		}
	}//traducirNumero

public static void main(String args[]){
MainClient mc = new MainClient();
System.out.println(mc.traducirNumero("espanol",1));
}
}//de la clase
```

 El resultado del código anterior, como ya sabrán, es **uno.**

Esta solución parece funcionar, y de hecho lo hace. Pero imaginemos que ahora nos dicen que desean la traducción de todos los números? Sin duda el código comenzará a crecer. Y claro, ahora tendremos que agregar código de lógica para cada idioma para escribir números como 752, 1233, etc.

Como nos gusta hacer gala de nuestro enfoque a objetos, los primero que se nos ocurre es una herencia. Definiremos una clase abstracta Traductor, y para cada idioma haremos una subclase de Traductor.

```
public abstract class Traductor{

   public abstract String traducirNumero(int numero);

}
```

Y ahora comienza la magia a aparecer. Vamos a crear una clase especializada para diccionario, que se encargará de traducir los números. Tendremos una clase especializada para traducir los números al español, que iría algo así:

```
public class TraductorEspanol extends Traductor {

    public TraductorEspanol(){
       super();
       ...
    }

    public String traducirNumero(int numero){
       switch(numero){
       	   case 1: return "uno";
       	   case 2: return "dos";
       	   ...
       }
    }

}
```

La clase para el inglés iría

```
public class TraductorIngles extends Traductor {

    public TraductorIngles(){
       super();
       ...
    }

    public String traducirNumero(int numero){
       switch(numero){
       	   case 1: return "one";
       	   case 2: return "two";
       	   ...
       }
    }

}
```

Y la del alemán no la ponemos, porque ya captaron la idea. Ahora, en el momento de querer utilizar un diccionario, se llamaría algo así

```
Traductor t = new TraductorEspanol();
t.traducirNumero(1);
```

Entonces, la clase MainClient cambiaría un poco y quedaría así:

```
public class MainClient {

	public String  traducirNumero(int numero){
		Traductor traductor = null;
		if (idioma.equals("español")){
			traductor = new TraductorEspanol();
		}

		if (idioma.equals("ingles")){
			traductor = new TraductorIngles();
		}

		if (idioma.equals("aleman")){
			traductor = new TraductorAleman();
		}
		String toReturn traductor.traducirNumero(numero);
                return toReturn;
	}//traducirNumero
     public static void main(String args[]){
          MainClient mc = new MainClient();
          System.out.println(mc.traducirNumero("espanol",1));
     }
}//de la clase
```

Qué hemos ganado? Primero, nuestro código es mucho más legible. Segundo es bastante más escalable. Podemos agregar el traductor para el francés muy fácilmente. Tercero hemos escondido la manera en la que traducimos a Tradúceme. Por ejemplo, puede ser que las traducciones a chino las vayamos a traer a un web Service. En ese caso TraductorChino se encargaría de hacer todo el ajetreo de conectarse a internet y buscar el web services, pero los demás ni se enteran.

Pero el Factory Pattern no ha aperecido, Es tiempo de irlo a llamar. Bueno, Traduceme está haciendo algo que no le compete: está eligiendo la instancia de Traductor que quiere usar. Imaginen que se usa el traductor en 100 lugares, entonces en cien lugares se tiene que buscar qué clase de Traductor vamos a instanciar. El patrón de fábrica -factory pattern- nos esconde esa lógica. Vamos a agregar ahora nuestra fábrica de traductores.

```
public class TraductorFactory {
     public TraductorFactory(){

     }

	public static Traductor createTraductor(int numero){
		Traductor traductor = null;
		if (idioma=="español"){
			traductor = new TraductorEspanol();
		}

		if (idioma=="english"){
			traductor = new TraductorIngles();
		}

		if (idioma=="deutsch"){
			traductor = new TraductorAleman();
		}
		return traductor;
	}
}//de la clase
```

¿Qué hace TraductorFactory? Simplemente elige, en base a los argumentos dados - en este caso el idioma- qué clase de traductor se instanciará. Traduceme de nuevo cambia y quedaría así:

```
public class MainClient {
     String idioma;
     public static void main(Strin []args){
		Traductor traductor = TraductorFactory.createTraductor("espanol");
		System.out.println( traductor.traducirNumero(1) );
	}//main

}//de la clase
```

MainClient se ha visto dramáticamente reducido, y su código es muy fácil de leer. Quien quiera usar un traductor simplemente hará llamar a Traduceme. Traduceme sabe el idioma que eligieron, pero no sabe que subclase de Traductor instanciar, pero sabiendo el idioma TraductorFactory sabe exáctamente qué instancia de Traductor crear. Si la aplicación desea cambiar de idioma simplemente le envía otro parámetro a Traduceme y listo. También agregar idiomas es más manejable que antes.

El Factory Pattern esconde al usuario final dle código la desición de qué sublclase instanciar, y promueve el encapsulamiento de las partes más variables del sistema. En términos generales, una fábrica abstracta consiste de las siguientes partes:

- Un cliente, que es el que llama a la fábrica (en nuestro caso MainClient).
- Una fábrica, que decidé la clase a instanciar (TraductorFactory).
- Un prodicto, lo que la fábrica devuelve (para nosotros las instancias de Traductor).

Pueden bajar los fuentes de este [ejemplo aqui](https://guisho-media.s3.amazonaws.com/uploads/2009/04/factorypattern.zip).
