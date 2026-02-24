---
_jetpack_related_posts_cache:
  8f6677c9d6b0f903e98ad32ec61f8deb:
    expires: 1771452970
    payload:
      - id: 763
      - id: 750
      - id: 101
_thumbnail_id: "767"
_wpas_done_all: "1"
author: guisho Luis H. Fernandez
categories:
  - software-engineering
cover:
  alt: adaptador
  image: https://guisho-media.s3.amazonaws.com/uploads/2009/11/adaptador.jpg
date: "2009-11-19T21:41:37+00:00"
guid: http://software.guisho.com/?p=179
parent_post_id: null
post_id: "768"
rank_math_internal_links_processed: "1"
rank_math_robots:
  - index
summary: '[![adaptador El patrón estructural que ahora vamos a analizar es muy eficaz así como sencillo. Se puede utilizar en muchos contextos y es de especialidad utilidad cuando se utilizan códigos o librerías ajenos al que estamos utilizando y sobre el que no tenemos control. Este patrón se le conoce como adaptador o adapter en inglés, aunque algunos lo llaman también wrapper, que viene siendo como envoltorio. Ambos nombres tienen bastante sentido y explican el por qué de este patrón.'
tags:
  - adaptador
  - adapter-pattern
  - buenas-prácticas---mejores-prácticas
  - patron-adaptador
  - patron-adapter
  - patrones
  - patrones-de-diseño
  - software
  - wrapper
title: Patron Adaptador - Pattern Adapter - Patrones de diseño
url: /patron-adaptador-pattern-adapter-patrones-de-diseno/
views: "26065"

---
[](https://guisho-media.s3.amazonaws.com/uploads/2009/11/adaptador.jpg) El patrón estructural que ahora vamos a analizar es muy eficaz así como sencillo. Se puede utilizar en muchos contextos y es de especialidad utilidad cuando se utilizan códigos o librerías ajenos al que estamos utilizando y sobre el que no tenemos control. Este patrón se le conoce como adaptador o adapter en inglés, aunque algunos lo llaman también wrapper, que viene siendo como envoltorio. Ambos nombres tienen bastante sentido y explican el por qué de este patrón.

Antes de comenzar con código o parecido, pensemos en este problema. En muchos países se utilizan las espigas redondas en los tomacorrientes, y en otros las espigas planitas. En ocasiones tenemos un dispositivo que tiene 3 espigas y el tomacorrientes 2. Sin embargo sabemos que el aparato que deseamos conectar "entiende" la corriente eléctrica, "la acepta", aunque la interfaz para conectarse a ella sea una distinta a la que posee. ¿Qué hacemos en estos casos? Usamos un adaptador! O un convertidor, o un transformador, cómo le querramos llamar.  Pues lo mismo sucede con el software. Sucede a menudo que nos encontramos con librerías que pueden sernos de utilidad, pero que existe la necesidad de adaptarnos a ellas. En esos casos tenemos dos opciones: modificar todo nuestro código para que se adapte a la librería, o podemos crear un adaptadro que traduzca lo nuestro a lo de ellos y lo de ellos a lo nuestro. Un ejemplo sencillo en el mundo Java es el de los Enumeration y los Iterators. Ambos tienen un hasNext()  o  un hasMoreElements() que hacen lo mismo; al igual que un next() y un nextElement() que hacen lo mismo. Imaginemos todo lo queremos manejar con Iterators, podemos crear un adaptador que nos "convierta" entre Iterator y Enumeration.

Vamos con el usual ejemplo. Imaginemos tenemos un sistema que maneja coches, barcos, aviones y parecidos. Generalmente los motores que se usan son de gasolina, pero las nuevas tendencias han popularizado los motores eléctricos. Para simplificar mi caso y mostra bien el punto, tenemos que el proveedor de vehículos eléctricos nos provee sus librerías para el motor eléctrico que es prácticamente igual a nuestras implementaciones pero con otros nombres (prender en vez de encender, "mover más rápido" en vez de acelerar, etc.), y tiene una restricción extra: para poder acelerar o detener el motor, este tiene que estar conectado. Y surge el problema ¿cómo hacemos para nuestras librerías puedan hacer uso del motor eléctrico? Podríamos reescribirlas todas, pero el tiempo que eso nos tomaría sería mucho. Además sabemos que existirían problemas que nuestras librerías ya han solucionado.

Como nos gusta ser elegantes en nuestro uso de objetos, hace muchos años creamos una clase abstracta (pensamos también hacer una interfaz, pero la clase abstracta nos provee otros métodos útiles):

```
package com.guisho.software.patrones.adapter;
public abstract class Motor {
   abstract public void encender();
   abstract public void acelerar();
   abstract public void apagar();
   //...mas metodos que hacen muchas cosas
}
```

Y tenemos nuestras implementaciones de algunos motores, por ejemplo el motor económico:

```
package com.guisho.software.patrones.adapter;

public class MotorEconomico extends Motor {

    public MotorEconomico(){
        super();
        System.out.println("Craendo motor economico");
    }

    public void encender() {
        System.out.println("Encendiendo motor economico.");
    }

    public void acelerar() {
        System.out.println("Acelerando motor economico.");
    }

    public void apagar() {
        System.out.println("Apagando motor economico.");
    }

}
```

Y el motor gastón (que ya no se vende tanto!):

```
package com.guisho.software.patrones.adapter;
public class MotorGaston extends Motor {
    public MotorGaston(){
        super();
        System.out.println("Creando el motor gaston");
    }

    public void encender() {
        System.out.println("Bum, bum....encendiendo motor gaston");
    }

    public void acelerar() {
        System.out.println("Buuuuuuuuuuuum, acelerando y gastando muuuucha gas");
    }

    public void apagar() {
        System.out.println("Apagando motor gaston");
    }

}
```

Estas clases siempre nos han funcionado bien, y de hecho tienen muchas cosas como servicios, mantenimientos y otros, que usamos gracias a la interfaz motor. Por ejemplo es común que usemos cosas como estás:

```
        Motor motor = new MotorEconomico();
        motor.encender();
        motor.acelerar();
        motor.apagar();
       //hacer mas cosas....
        motor = new MotorGaston();
        motor.encender();
        motor.acelerar();
        motor.apagar();
```

Ahora la empresa que construye motores eléctricos nos manda su propia implementación que va así:

```
public class MotorElectrico {

    private boolean conectado = false;

    public MotorElectrico() {
        System.out.println("Creando motor electrico");
        this.conectado = false;
    }

    public void conectar() {
        System.out.println("Conectando motor eléctrico");
        this.conectado = true;
    }

    public void activar() {
        if (!this.conectado) {
            System.out.println("No se puede activar porque no esta conectado el motor electrico");
        } else {
            System.out.println("Esta conectado, activando motor electrico....");
        }
    }

    public void moverMasRapido() {
        if (!this.conectado) {
            System.out.println("No se puede mover rapido el motor electrico porque no esta conectado...");
        } else {
            System.out.println("Moviendo mas rapido...aumentando voltaje");
        }
    }

    public void detener() {
        if (!this.conectado) {
            System.out.println("No se puede detener motor electrico porque no esta conectado");
        } else {
            System.out.println("Deteniendo motor electrico");
        }
    }

    public void desconectar() {
        System.out.println("Desconectando motor electrico...");
        this.conectado = false;
    }
}
```

Como vemos, este motor hace lo mismo que el nuestro, pero de manera y con llamadas un poco diferentes. ¿Cómo hacemos para integrar este MotorEléctrico al resto de nuestro sistema? Así es, con un adaptador o adapter!
El adapter "envuelve" al objeto extraño (por eso le llaman wrapper también, ya que wrapper viene siendo envoltorio).

Nuestro adaptador se escribiría así:

```
package com.guisho.software.patrones.adapter;

public class MotorElectricoAdapter extends Motor{
    private MotorElectrico motorElectrico;

    public MotorElectricoAdapter(){
        super();
        this.motorElectrico = new MotorElectrico();
        System.out.println("Creando motor Electrico adapter");
    }

    public void encender() {
        System.out.println("Encendiendo motorElectricoAdapter");
        this.motorElectrico.conectar();
        this.motorElectrico.activar();
    }

    public void acelerar() {
        System.out.println("Acelerando motor electrico...");
        this.motorElectrico.moverMasRapido();
    }

    public void apagar() {
        System.out.println("Apagando motor electrico");
        this.motorElectrico.detener();
        this.motorElectrico.desconectar();

    }

}
```

Como ven el adapter se encarga no solo de corregir los nombres de los métodos, sino también cosas como conectar y desconectar el motor, cosas que a nuestra implementación no le importan. Pero lo más importante es que ahora podemos utilizar esta implemetnación de Motor en nuestro sistema utilizando la implementación de ellos. Por ejemplo podemos hacer cosas como esta:

```
        Motor motor = new MotorEconomico();
        motor.encender();
        motor.acelerar();
        motor.apagar();

        motor = new MotorGaston();
        motor.encender();
        motor.acelerar();
        motor.apagar();

        motor = new MotorElectricoAdapter() ;
        motor.encender();
        motor.acelerar();
        motor.apagar();
```

El patrón adapter aparece en todos lados, aunque muchas veces no se le llama adapter específicamente. Ahora que lo conocemos lo podemos usar en nuevos proyectos, o tal vez puede solucionarlos problemas que resolvimos a medias en algún software por ahí. Como siempre les [dejo el código fuente.](https://guisho-media.s3.amazonaws.com/uploads/2009/11/adapter.zip)  
casino magasin [http://www.jpfchat.com/revues-des-casinos/](http://www.jpfchat.com/revues-des-casinos/)
