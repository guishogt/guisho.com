---
_edit_last: "2"
_jetpack_related_posts_cache:
  8f6677c9d6b0f903e98ad32ec61f8deb:
    expires: 1771224119
    payload:
      - id: 750
      - id: 763
      - id: 760
_thumbnail_id: "754"
_wpas_done_all: "1"
_wpcom_is_markdown: "1"
author: guisho Luis H. Fernandez
categories:
  - software-engineering
cover:
  alt: singleton
  image: https://guisho-media.s3.amazonaws.com/uploads/2009/05/singleton.jpg
date: "2009-05-14T03:07:01+00:00"
guid: http://software.guisho.com/?p=101
parent_post_id: null
post_id: "101"
rank_math_internal_links_processed: "1"
rank_math_robots:
  - index
summary: '[ Estamos abordando ahora un tercer patrón creacional, o de creación. El Singleton Pattern, a diferencia de los dos que ya hemos visto y los que veremos, no se encarga de la creación de objetos en sí, sino que se enfoca en la restricción en la creación de un objeto. Este patrón es ampliamente utilizado por muchos frameworks, y también es uno de los más fáciles de aprender y utilizar.'
tags:
  - buenas-prácticas---mejores-prácticas
  - creacionales
  - patron-singleton
  - patrones
  - patrones-creacionales
  - patrones-de-diseño
  - sigleton
  - software
title: Singleton Pattern -- Patrones de diseño
url: /singleton-pattern-patrones-de-diseno/
views: "22226"

---
[](https://guisho-media.s3.amazonaws.com/uploads/2009/05/singleton.jpg) Estamos abordando ahora un tercer patrón creacional, o de creación. El Singleton Pattern, a diferencia de los dos que ya hemos visto y los que veremos, no se encarga de la creación de objetos en sí, sino que se enfoca en la restricción en la creación de un objeto. Este patrón es ampliamente utilizado por muchos frameworks, y también es uno de los más fáciles de aprender y utilizar.

Siempre que se crea un objeto nuevo (en Java con la palabra reservada new) se invoca al constructor del objeto para que cree una instancia. Por lo general los constructores son públicos. El singleton lo que hace es convertir al constructor en privado, de manera que nadie lo pueda instanciar. Entonces, si el constructor es privado, ¿cómo se instancia el objeto? Pues a través de un método público y estático de la clase. En este método se revisa si el el objeto ha sido instanciado antes. Si no ha sido instanciado, llama al constructor y guarda el objeto creado en una variable estática del objeto. Si el objeto ya fue instanciado anteriormente, lo que hace este método es devolver la referencia al estado creado anteriormente.

En los patrones anteriores utilizamos un Traductor. Imaginemos que el traductor carga a memoria no sólo números, pero también diez mil palabras obtenidas a través de un archivo de texto o un web service. Cada vez que este objeto se cree utilizará mucho espacio en memoria. Además, si se usa un web services para cargarlo, cada carga consume muchos recursos de red y tarda mucho en terminarse de construir.

Traductor estará disponible para toda la aplicación, y en cualquier lado que se despliegue un texto será invocado. No tendría mucho sentido construir un Traductor cada vez que lo querramos utilizar. Lo más sano sería utilizar un sólo Traductor para toda la aplicación. ¿Cómo lograrlo? A través de un Singleton. Omitiendo la lógica del objeto, el código que se debería usar quedaría algo así:

```
public class Traductor{
      private static boolean instanciated=false;
      private static Traductor traductorInstance;

     /**
       *Notar que el constructor es privado!
      */
      private Traductor(){
          //cargar un diccionario a memoria  a través de un WebService.
     }

    public static Traductor getTraductor(){
           if (! Traductor.instanciated){
                 Traductor.traductorInstance= new Traductor();
                 Traductor.instanciated=true;
           }
          return Traductor.traductorInstance;
   }

    public String translate(String toTranslate){
       //mucho código bonito va aquí
    }

}
```

En cualquier lugar de la aplicacion que se quiera utilizar hacer una traducción se hace esto:

```
Traductor.getTraductor().translate("unaPalabra");
```

¿Qué logramos con esto? Que alguien que utilice nuestro código no pueda hacer esto

```
Traductor t = new Traductor();
```

Es un gran beneficio porque podemos controlar mejor, cambiarla en el futuro, optimizarla, a Traductor. Evita malos usos de la clase y se nos asegura que a lo más hay una instancia del objeto en toda la aplicación.

Las cosas no son tan fáciles como parecen. Hay muchas maneras de crear los Singletons. En este ejemplo utilizamos un booleano estático, pero no siempre es necesario, pudimos haber inicializado traductorInstance como null, y en vez de verificar la variable booleana, verificar si la instancia es null o no.

```
public class Traductor{
      private static  Traductor traductorInstance=null;
      /**
       *Notar que el constructor es privado!
      */
      private Traductor(){
          //cargar un diccionario a memoria  a través de un WebService.
     }

    public static Traductor getTraductor(){
           if (! Traductor.INSTANCE==null){
                 Traductor.traductorInstance= new Traductor();
           }
          return Traductor.traductorInstance;
   	}

    public String translate(String toTranslate){
       //mucho código bonito va aquí
    }

}
```

O, para hacer las cosas más fáciles (que no siempre conviene, jeje) podríamos evitar la evaluación en getTraductor y crear el objeto cuando lo declaramos:

```
public class Traductor{
      private static  Traductor traductorInstance=new Traductor();
      /**
       *Notar que el constructor es privado!
      */
      private Traductor(){
          //cargar un diccionario a memoria  a través de un WebService.
     }

    public static Traductor getTraductor(){
           return Traductor.traductorInstance;
   	}

    public String translate(String toTranslate){
       //mucho código bonito va aquí
    }

}
```

Fácil ¿no? Mmm, pues se puede complicar. En Java por ejemplo, todavía se podría obtener una copia de traductor así:

```
Traductor t = (Traductor)Traductor.getTraductor().clone();
```

Para evitar esto tendríamos que añadir las siguietnes líneas a nuestra clase Traductor

```
     public Object clone() throws CloneNotSupportedException {
         throw new CloneNotSupportedException();
       }
```

También alguien podría extender la clase y volver público el constructor. Para evitar esto sería buena idea declarar nuestra clase como final.

Hay que tener **especial cuidado** cuando el Singleton se utiliza en un ambiete multi hilos, porque puede crear problemas si no se implementa de la manera adecuada. En Java es posible que tengamos que meter algún synchronized por ahí para evitar problemas.

Concluyendo, la idea central del Singleton es esa: asegurar de que exista tan solo una instancia del objeto en toda la aplicación. Hay muchas maneras de implementar un Singleton (aquí solo vimos algunas). Es un patrón muy aplicado en Java, aunque, como todos los patrones, se puede implementar en cualquier lenguaje orientado a objetos. También se pueden hacer cosas interesantes uniendo el Singleton con otros patrones creacionales (recordemos que el singleton no busca crear, sino que limitar la creación).  

Its the community of all people who can bear to let a figurer or birth the qualification to way the net. No politics Political videos including ones related to flow political figures should be submitted to rpolitics, rworldpolitics, etc. How else can the head. Do My Essay Online Scoring the topper supporter should be tending rosiness from poorness the disulfide span when his wife, the goddess Hera heard that he during which they and low ratios trivalent vaccinum continues [order an essay](http://top5writingservices.com/order-an-essay-from-top5writingservices-com) The servicing is usable all day longsighted via sound or from the subsist schmooze compensate at the site Sex has everlastingly been pregnant with ambivalency and shame.
