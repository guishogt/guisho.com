---
_jetpack_related_posts_cache:
  37550b67d263a3ce789993dc25046c5f:
    expires: 1771336252
    payload:
      - id: 752
      - id: 760
      - id: 101
      - id: 763
      - id: 768
      - id: 104
_wpas_done_all: "1"
author: guisho Luis H. Fernandez
categories:
  - software-engineering
date: "2009-05-06T03:53:26+00:00"
guid: http://software.guisho.com/?p=86
parent_post_id: null
post_id: "86"
rank_math_internal_links_processed: "1"
rank_math_og_content_image:
  check: 8b45d18d71995f230549b60a351d9a6a
  images:
    - 124
rank_math_robots:
  - index
summary: |-
  [ Hace una semana hablamos del Factory Pattern, que realmente se llama Factory Method Pattern, porque como vimos se trata de reducir la desición de la creación de una instancia a un método, pero que por gusto mío lo pusimos en una clase Factory con un método abstracto. Ahora vamos a hablar del Abstract Factory Pattern, que va un paso más alla: el Abstract Factory Method agrupa varios Factory Methods.
  Básicamente lo que hace el este patrón es unir varios Factory Methods, delegando la responsabilidad total sobre qué instancias crear a partir de datos comunes. La semana pasada hicimos un pequeño traductor, que al recibir un número desplegaba su valor en español, inglés o alemán. Para mostrar el concepto del Abstract Factory vamos a extender el ejemplo.
tags:
  - abstract-factory-pattern
  - buenas-prácticas---mejores-prácticas
  - patrones
  - patrones-de-diseño
  - pattern
  - software
title: Abstract Factory Pattern - Patrones
cover:
  image: https://guisho-media.s3.amazonaws.com/uploads/2009/05/factory.jpg
url: /abstract-factory-pattern-patrones/
views: "34289"
---
[](https://guisho-media.s3.amazonaws.com/uploads/2009/05/factory.jpg) Hace una semana hablamos del Factory Pattern, que realmente se llama Factory Method Pattern, porque como vimos se trata de reducir la desición de la creación de una instancia a un método, pero que por gusto mío lo pusimos en una clase Factory con un método abstracto. Ahora vamos a hablar del Abstract Factory Pattern, que va un paso más alla: el Abstract Factory Method agrupa varios Factory Methods.

Básicamente lo que hace el este patrón es unir varios Factory Methods, delegando la responsabilidad total sobre qué instancias crear a partir de datos comunes. La semana pasada hicimos un pequeño traductor, que al recibir un número desplegaba su valor en español, inglés o alemán. Para mostrar el concepto del Abstract Factory vamos a extender el ejemplo.

Primero vamos hacer un sencillo reloj que nos muestra la hora actual. Como sabemos, la hora puede ser desplegada en formato de 24Hrs o puede ser desplegada en formato AM/PM. Recordando que es a manera de ejemplo, vamos a utilizar la clase Date de una manera que no se debe, y probablemente el reloj lo haríamos de una manera más sencilla, pero para nuestro ejemplo queda perfecta su uso. Como en el caso del diccionario, haremos una clase abstracta de Reloj y dos implementaciones para cada una de los formatos, y una clase que contenga el método del Factory Method. La cosa quedaría algo así:

La clase Reloj:

```
public abstract class Reloj {

    abstract String dameLaHora();
}
```

La clase que se da la hora en formato AM/PM:

```
public class RelojAmPm extends Reloj{

    public RelojAmPm(){

    }

    public String dameLaHora() {
        Date d = new Date();
        int hora = d.getHours();
        int minutos = d.getMinutes();
        int segundos = d.getSeconds();
        String tr;
        if (hora<=12){
            tr="Son las "+hora+":"+minutos+":"+segundos+" AM";
        } else {
            tr="Son las "+(hora-12)+":"+minutos+":"+segundos+" PM";
        }

        return tr;
    }

}
```

La que nos da la hora en formato de 24 horas:

```
public class Reloj24Hrs extends Reloj {

    public String dameLaHora() {
        Date d = new Date();
        int hora = d.getHours();
        int minutos = d.getMinutes();
        int segundos = d.getSeconds();
        String tr;
        tr = "Son las " + hora + ":" + minutos + ":" + segundos + " ";

        return tr;
    }
}
```

Nuestra clase que contiene la el método que elije las instancias. A diferencia del post anterior, ahora el parámetro que recibe el método es un entero, que acepta los enteros especificados como constantes estáticas en la clase. Esto se usa mucho para no estar adivinando los paráemetros que acepta el método:

```
public class RelojFactory {
    public static final int RELOJ_AM_PM=0;
    public static final int RELOJ_24_HRS=1;

    public RelojFactory(){

    }

    public static Reloj createReloj(int tipoDeReloj){
        if (tipoDeReloj==RelojFactory.RELOJ_24_HRS){
            return new Reloj24Hrs();
        }
        if (tipoDeReloj==RelojFactory.RELOJ_AM_PM){
            return new RelojAmPm();
        }

        return null;
    }

}
```

Y finalmente la clase cliente, que será la usuario final:

```
public class MainClient {

    public static void main(String[] args) {
        Reloj r = RelojFactory.createReloj(RelojFactory.RELOJ_24_HRS);
        System.out.println(r.dameLaHora());
    }
}
```

Hasta aquí tenemos dos fábricas: una de palabras, y la que acabamos de hacer que nos da la hora. En un proyecto cualquiera se nos pide hacer un sistema que despliegue la hora y los números de la manera en la que se expresan en cada país (una implementación súper elemental de Locale de Java). Vamos con dos ejemplos prácticos. En Estados Unidos se despliegan los números en inglés, y la hora en formato AM/PM; mientras que en Guatemala se dicen los números en español y la hora en formato de 24 Horas.

Ahora vamos a crear una Abstract Factory, que le pondremos Locale.

```
public abstract class AbstractLocaleFactory {
    public static final String US="ESTADOS_UNIDOS";
    public static final String GT="GUATEMALA";

    String pais;

    public abstract Traductor createTraductor();
    public abstract Reloj createReloj();

    public String getPais(){
        return this.pais;
    }

    public void setPais(String pais){
        this.pais = pais;
    }

}
```

Como ven esta fabrica tiene un par de métodos que devuelven un Reloj y un Traductor. Noten que Reloj y Traductor son a su vez clases abstractas.

Ahora implementamos nuestra clase LocaleGuatemalaFactory, que va así:

```
public class LocaleGuatemalaFactory extends AbstractLocaleFactory{

    public LocaleGuatemalaFactory(){
        this.pais=this.GT;
    }
    public Traductor createTraductor() {
        return TraductorFactory.createTraductor("espanol");
    }

    public Reloj createReloj() {
        return RelojFactory.createReloj(RelojFactory.RELOJ_24_HRS);
    }

}
```

Y la respectiva para Estados Unidos:

```
public class LocaleEstadosUnidosFactory extends AbstractLocaleFactory{

    public LocaleEstadosUnidosFactory(){
        this.pais=AbstractLocaleFactory.US;
    }

    public Traductor createTraductor() {
        return TraductorFactory.createTraductor("ingles");
    }

    public Reloj createReloj() {
        return RelojFactory.createReloj(RelojFactory.RELOJ_AM_PM);
    }

}
```

Ahora en el cliente, si queremos las cosas como se verían en Guatemala, simplemente hacemos esto.

```
public class MainClient {

    public static void main(String[] args) {

        Reloj reloj = null;
        Traductor traductor = null;

        AbstractLocaleFactory localeFactory = new LocaleGuatemalaFactory();
        reloj = localeFactory.createReloj();
        traductor = localeFactory.createTraductor();

        System.out.println("--------");
        System.out.println("1="+traductor.traducirNumero(1));
        System.out.println(reloj.dameLaHora());

    }
}
```

El resultado de correr el codigo anterior es:
**1=uno**
**Son las 21:50:17**

Ahora si cambiamos la linea

```
        AbstractLocaleFactory localeFactory = new LocaleGuatemalaFactory();
```

Por esta

```
        AbstractLocaleFactory localeFactory = new LocaleEstadosUnidosFactory();
```

Tendremos como resultado:
**1=one**
**9:52:56 PM**

Aquí es un ejemplo sencillo. Pero imaginen quedemos hacer un Locale para cada país, y en el locale tener más cosas como: la nomenclatura de moneda, el sistema de numeración, el manejo de fechas, kilómetros o millas, etc. Con el Abstract Factory Pattern es muy sencillo agregar cada nuevo pais, o cada nueva característica del Locale. Pero sobre todo el código es MUY legible y FACILMENTE extensible. Alguien que nunca ha visto estas piezas de código puede entender como hacer un nuevo país.

Entonces, el Abstract Factory Pattern puede ayudarnos mucho en casos donde hemos de manejar familias de objetos. Al inicio no siempre es obvia su implementación, pero siempre está el recurso de del refactoring, en el cual salen nuevas maneras sencillas de hacer las cosas. Este, como muchos patrones, requieren escribir un poco más de código al principio, pero nos reducen el esfuerzo a largo plazo porque hay menos código repetido.

[Aquí el código](https://guisho-media.s3.amazonaws.com/uploads/2009/05/abstractfactory.zip) de este patrón.
