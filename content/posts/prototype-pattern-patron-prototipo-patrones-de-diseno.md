---
_edit_last: "2"
_jetpack_related_posts_cache:
  37550b67d263a3ce789993dc25046c5f:
    expires: 1771322892
    payload:
      - id: 101
      - id: 750
      - id: 763
      - id: 752
      - id: 104
      - id: 86
_thumbnail_id: "758"
_wpas_done_all: "1"
_wpcom_is_markdown: "1"
author: guisho Luis H. Fernandez
categories:
  - software-engineering
cover:
  alt: cloning
  image: https://guisho-media.s3.amazonaws.com/uploads/2009/06/cloning.jpg
date: "2009-06-02T18:40:00+00:00"
guid: http://software.guisho.com/?p=142
parent_post_id: null
post_id: "760"
rank_math_internal_links_processed: "1"
rank_math_robots:
  - index
summary: '[ Ya casi terminando con los patrones creacionales, vamos a hablar hoy sobre el prototype pattern, o patrón prototipo. Como los demás patrones creacionales, este patrón sustituirá para el cliente la palabra clave new por otra forma de crear objetos. En este caso específico la creación se hará sobre objetos que son complicados de crear, que para evitar usar new  serán clonados a partir de una instancia ya existente. Afortunadamente crear objetos no crea ningún tipo de reparo moral, porque este patrón de eso se trata: de clonar, de pasar el ADN de un objeto a otro.  Es decir cada instancia del objeto se obtendrá a partir de un prototipo (sí, de ahí el nombre del patrón!).'
tags:
  - buenas-prácticas---mejores-prácticas
  - patron-prototipo
  - patrones
  - patrones-de-diseño
  - patterns
  - prototipo
  - prototype
  - prototype-pattern
  - software
title: Prototype Pattern - Patron Prototipo -- Patrones de diseño
url: /prototype-pattern-patron-prototipo-patrones-de-diseno/
views: "17849"

---
[](https://guisho-media.s3.amazonaws.com/uploads/2009/06/cloning.jpg) Ya casi terminando con los patrones creacionales, vamos a hablar hoy sobre el prototype pattern, o patrón prototipo. Como los demás patrones creacionales, este patrón sustituirá para el cliente la palabra clave new por otra forma de crear objetos. En este caso específico la creación se hará sobre objetos que son complicados de crear, que para evitar usar new  serán clonados a partir de una instancia ya existente. Afortunadamente crear objetos no crea ningún tipo de reparo moral, porque este patrón de eso se trata: de clonar, de pasar el ADN de un objeto a otro.  Es decir cada instancia del objeto se obtendrá a partir de un prototipo (sí, de ahí el nombre del patrón!).

Este patrón es facilito, ya lo veremos. En el caso específico de Java ya se tiene mucho camino ganado, porque Java provee la interaz clonable con el propósito de crear clones en mente. Pero vamos a hacer también una implementación sin usar esta interfaz para comprender completamente la idea detrás del prototipo. La primera manera de implementar este patrón en Java es implementando la interfaz Cloneable. Mas abajo veremos otra forma de implementarlo, que es haciéndolo a mano, con una ventaja extra: en vez de crear referencias a los objetos contenidos, podemos crear objetos nuevos, que en muchos cosas nos puede ser de utilidad. Por ahora veamos un un ejemplo sencillo usando cloneable:

```
  public class Copiame implements Cloneable {
            Object clone = null;
            try {
                clone = super.clone();
            } catch (CloneNotSupportedException e) {
                e.printStackTrace();
            }
            return clone;
  }
```

Expliquemos un poco. Clonable es una interfaz vacía, pero para utilizar super.clone() tenemos que implementar cloneable si no quere mos una CloneNoSupportedException. La segunda cosa a considerar es que clone hace una copia de los valores de los campos de un objeto, no de los objetos a los que apunta. En otras palabras, el objeto clonado apuntará a los mismos objetos que el objeto antiguo apuntaba. Otra cosa a tomar en cuenta es que clone() devuelve siempre un Object. También notemos que clone es un método protected que puede ser llamado solo por la misma clase o el paquete que la contiene.

Entonces, ¿para qué nos sirve clonar objetos? Bueno, nos sirve para copiar objetos que tardan mucho en crear, o que son complejos de crear. Por ejemplo una lista grande que es costoso en tiempo obtener y que se desea ordenar de dos maneras distintas.

De nuevo nos adentraremos con un ejemplo, que sigo pensando es la mejor manera de aprender. Para nuestro ejemplo vamos a hacer una clase Persona y luego llenar la persona con los datos de dos hermanos: Juan y María que serán ingresados a un sistema x.

```
package com.guisho.software.patrones.prototype;

/**
 *
 * @author guisho.com, luishernan@gmail.com
 */
public class Persona implements Cloneable{

    public String nombres;
    public String appellidos;
    public String nombrePadre;
    public String nombreMadre;
    public String direccion;
    public String telCasa;
    public String nacionalidad;
    public String ciudadEnQueVive;
    public String nombreMascota;

    public Persona(){

    }

/*Setters y geters....*/

}
```

Y un cliente que crea la Persona:

```
    public static void main(String[] args) {
        Persona juan = new Persona();
        juan.setNombres("Juan José");
        juan.setAppellidos("Pérez Ramirez");
        juan.setNombrePadre("Juan Pérez Martinez");
        juan.setNombreMadre("María Ramirez");
        juan.setDireccion("9a. Ave. 43-12 Z.1");
        juan.setTelCasa("34567890");
        juan.setNacionalidad("Guatemalteca");
        juan.setCiudadEnQueVive("Guatemala");
        juan.setNombreMascota("Pepito");

        //Hacer algo con Juan, ingresarlo al sistema, etc...
        System.out.println("Ingresando al sistema :"+juan.toString());

        Persona maria = (Persona)juan.clone();

        maria.setNombres("María Inés");
        System.out.println("Ingresando al sistema :"+maria.toString());

        //ingresar a Maria al sistema....

    }
```

Como vemos, ahora no se tuvieron que ingresar todos los campos de María sino, solo aquellos que la diferenciaban de su hermano Juan. Hay que recordar que si hubiesen objetos en el ejemplo estos se clonan por referencia, es decir las referencias de ambos objetos son las mismas. Ahora vamos a vamos a implementar la clonación a mano. Le vamos a añadir a Persona este método:

```
    public Persona creaPrototipo(){
        Persona p = new Persona();
        p.setNombres(this.nombres);
        p.setAppellidos(this.appellidos);
        p.setNombrePadre(this.nombrePadre);
        p.setNombreMadre(this.nombreMadre);
        p.setDireccion(this.direccion);
        p.setTelCasa(this.telCasa);
        p.setNacionalidad(this.nacionalidad);
        p.setCiudadEnQueVive(this.ciudadEnQueVive);
        p.setNombreMascota(this.nombreMascota);
        System.out.println("Creado prototipo de Persona");
        return p;
    }
```

Entonces en el cliente podemos hacer esta llamada

```
        Persona maria = juan.creaPrototipo();
```

Como vemos, el patrón prototipo es sencillo: crear una copia de un objeto para ahorrarnos los pasos de su creación, o para optimizar accesos o procesos que ya se hicieron en un objeto similar y crear una copia del objeto ya con esos datos ingresados. Como siempre les dejo aquí el [código para que jueguen.](https://guisho-media.s3.amazonaws.com/uploads/2009/06/patronprototipo.zip).
