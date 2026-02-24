---
_jetpack_related_posts_cache:
  8f6677c9d6b0f903e98ad32ec61f8deb:
    expires: 1771323056
    payload:
      - id: 750
      - id: 101
      - id: 763
_wpas_done_all: "1"
author: guisho Luis H. Fernandez
categories:
  - software-engineering
date: "2009-05-29T18:27:10+00:00"
guid: http://software.guisho.com/?p=104
parent_post_id: null
post_id: "104"
rank_math_internal_links_processed: "1"
rank_math_og_content_image:
  check: 507c8af3da34afb129df1bb27e5663f6
  images:
    - 117
rank_math_robots:
  - index
summary: |-
  ![lego
  El builder pattern, o patrón de construcción, es uno más de los patrones creacionales de diseño. En términos generales un builder esconde los detalles de la creación de un objeto final que se llama producto. Hay varios métodos para lograr esto, y por ello hay varias "implementaciones" de este patrón que en nada coinciden , salvo en el nombre. El clásico, usado en el GoF es un poco más complejo del que vamos a ver ahora, pero no se asusten, ya tendremos la oportunidad de aprenderlo. En esta ocasión nos vamos a enfocar en un builder que se llaman interfaces fluídas (fluid interfaces).
tags:
  - buenas-prácticas---mejores-prácticas
  - builder-pattern
  - constructor-encadenado
  - fluid-interface
  - interfaces-fluídas
  - patron-builder
  - patron-constructor
  - patrones
  - patrones-creacionales
  - patrones-de-diseño
  - software
title: Builder Pattern, Interfaces Fluidas-- Patrones de diseño
cover:
  image: https://guisho-media.s3.amazonaws.com/uploads/2009/05/lego.jpg
url: /builder-pattern-interfaces-fluidas-patrones-de-diseno/
views: "18361"
---
El builder pattern, o patrón de construcción, es uno más de los patrones creacionales de diseño. En términos generales un builder esconde los detalles de la creación de un objeto final que se llama producto. Hay varios métodos para lograr esto, y por ello hay varias "implementaciones" de este patrón que en nada coinciden , salvo en el nombre. El clásico, usado en el GoF es un poco más complejo del que vamos a ver ahora, pero no se asusten, ya tendremos la oportunidad de aprenderlo. En esta ocasión nos vamos a enfocar en un builder que se llaman interfaces fluídas (fluid interfaces).

Y seguimos con la política de que la mejor manera de entender, y de aprender, es con un ejemplo. Estuve dándole vueltas a un buen caso para ejemplificar y se me ocurrió este: supongamos que vamos a hacer un programa para una empresa que ofrece servicios de web hosting (alojamiento en web). Esta empresa tiene varios planes que ofrecer: tiene un plan personal, un plan bronce, uno plata, uno oro y finalmente el diamante. El personal ofrece un alojamiento de 10MB, una transferencia mensual de 100MB, una cuenta de correo electrónico y nada más. El bronce ofrece 100MB de alojamiento, 1000MB de transferencia mensual, 10 cuentas de correo electrónico. Así sucesivamente cada plan aumenta las cantidades de alojamiento, transferencia y cuentas de correo. A la cada plan agrega nuevas características. El plata ofrece acceso ssh, y una base de datos; el oro agrega estadísticas de sitio y panel de control. Así se van multiplicando las opciones, y para crear la aplicación definimos nuestro objeto que queda así:

```
package com.guisho.software.patrones.builder;

import java.math.BigDecimal;

/**
 *
 * @author guisho.com, luishernan@gmail.com
 */
public class PaqueteDeHosting {

    /*Los siguientes campos son obligatorios siempre*/
    private String nombre;
    private BigDecimal precioAnual;
    private int capacidadDeAlmacenamiento; //en MB
    private int transferenciaMensual; //en MB
    private int cantidadDireccionesCorreo;//

    /*Las siguientes son opcionales, hay planes que no los tienen*/
    private int cantidadSitiosPermitidos;
    private int cantidadBaseDeDatos;
    private String codigoOferta;
    private boolean accesoSsh;
    private boolean panelDeControl;
    private boolean estadisticasDeSitio;
    private boolean ipPublica;

    public PaqueteDeHosting(){

    }

    /* mas constructores */
    /* Setters, getters y demás código....*/
}
```

Bien, ahora cada plan tiene una configuración previamente establecida, que el vendedor no arma en el momento, y que preferiblemente no puede cambiar. ¿Cómo hacemos para crear cada objeto? La primera manera que se nos ocurrirá es crear un constructor pada cada caso, manteniendo siempre los valores obligatorios. Tendríamos una colección de constructores como la siguiente:

```
    public PaqueteDeHosting(String nombre, BigDecimal precioAnual, int almacenamiento, int transferencia, int cantidadCorreos) {
        this.nombre = nombre;
        this.precioAnual = precioAnual;
        this.capacidadDeAlmacenamiento = almacenamiento;
        this.transferenciaMensual = transferencia;
        this.cantidadDireccionesCorreo = cantidadCorreos;
    }

    public PaqueteDeHosting(String nombre, BigDecimal precioAnual, int almacenamiento, int transferencia, int cantidadCorreos, int basesDatos) {
        this.nombre = nombre;
        this.precioAnual = precioAnual;
        this.capacidadDeAlmacenamiento = almacenamiento;
        this.transferenciaMensual = transferencia;
        this.cantidadDireccionesCorreo = cantidadCorreos;
        this.cantidadBaseDeDatos = basesDatos;
    }

    public PaqueteDeHosting(String nombre, BigDecimal precioAnual, int almacenamiento, int transferencia, int cantidadCorreos, String ipPublica) {
        this.nombre = nombre;
        this.precioAnual = precioAnual;
        this.capacidadDeAlmacenamiento = almacenamiento;
        this.transferenciaMensual = transferencia;
        this.cantidadDireccionesCorreo = cantidadCorreos;
        this.ipPublica = ipPublica;
    }

    public PaqueteDeHosting(String nombre, BigDecimal precioAnual, int almacenamiento, int transferencia, int cantidadCorreos, String ipPublica,int basesDatos){
        this.nombre=nombre;
        this.precioAnual=precioAnual;
        this.capacidadDeAlmacenamiento=almacenamiento;
        this.transferenciaMensual=transferencia;
        this.cantidadDireccionesCorreo=cantidadCorreos;
        this.ipPublica=ipPublica;
        this.cantidadBaseDeDatos=basesDatos;
    }
....
```

Como vemos solo hicimos un par de combinaciones con la cantidad de bases de datos y la ip pública. Mientras la cantidad de campos opcionales crece, la cantidad de constructores aumenta desmedidamente creando el ambiente ideal para que aparezcan errores.

Otro camino que se puede tomar es el clásico bean: un constructor vacío y setters para cada parámetro que deseamos agregar. Este método tiene un pequeño inconveniente: podemos dejar al objeto en un estado incosistente: podemos ponerle cuántas cuentas de correo pero no ponerle nombre, ni ponerle precio. ¿Qué hacemos entonces? Hacemos un Builder!! El builder se explicará por el solo. Veamos:

En PaqueteDeHosting hacemos un constructor con los campos que siempre van para evitar estados inconsistentes:

```
    public PaqueteDeHosting(String nombre, BigDecimal precioAnual, int almacenamiento, int transferencia, int cantidadCorreos) {
        this.nombre = nombre;
        this.precioAnual = precioAnual;
        this.capacidadDeAlmacenamiento = almacenamiento;
        this.transferenciaMensual = transferencia;
        this.cantidadDireccionesCorreo = cantidadCorreos;
    }
```

Y creamos el builder

```
package com.guisho.software.patrones.builder;

import java.math.BigDecimal;

/**
 *
 * @author guisho.com, luishernan@gmail.com
 */
public class PaqueteDeHostingBuilder {
    private  PaqueteDeHosting paquete;

    public PaqueteDeHostingBuilder(String nombre, BigDecimal precio, int cantidadAlmacenamiento, int transferenciaMesual, int cantidadCorreo){
        this.paquete.setNombre(nombre);
        this.paquete.setPrecioAnual(precio);
        this.paquete.setCapacidadDeAlmacenamiento(cantidadAlmacenamiento);
        this.paquete.setTransferenciaMensual(transferenciaMesual);
        this.paquete.setCantidadDireccionesCorreo(cantidadCorreo);
    }

    public PaqueteDeHostingBuilder catidadSitiosPermitidos (int cantidad){
        this.paquete.setCantidadSitiosPermitidos(cantidad);
        return this;
    }

    public PaqueteDeHostingBuilder cantidadBaseDeDatos (int cantidad){
        this.paquete.setCantidadBaseDeDatos(cantidad);
        return this;
    }

    public PaqueteDeHostingBuilder accessoSsh(boolean acceso){
        this.paquete.setAccesoSsh(acceso);
        return this;
    }

    public PaqueteDeHostingBuilder panelControl (boolean panel){
        this.paquete.setPanelDeControl(panel);
        return this;
    }

    public PaqueteDeHostingBuilder codigoOferta(String codigo){
        this.paquete.setCodigoOferta(codigo);
        return this;
    }

    public PaqueteDeHostingBuilder ipPublica (String ip){
        this.paquete.setIpPublica(ip);
        return this;
    }

}
```

Si lo analizamos el builder simplemente envuelve al objeto que creará, con una especie de métodos de acceso (parecido a un JavaBean) pero con la peculiaridad que se devuelve a sí mismo siempre. ¿En qué nos ayuda esto? Miremos el cliente como crea un Paquete ahora:

```
    public static void main(String[] args) {

        PaqueteDeHosting personal = new PaqueteDeHostingBuilder("personal",new BigDecimal(100),10,100,1).build();
        PaqueteDeHosting bronce =
        new PaqueteDeHostingBuilder("bronce",new BigDecimal(200),100,1000,10).accessoSsh(true).build();
        PaqueteDeHosting plata =
        new PaqueteDeHostingBuilder("plata",new BigDecimal(300),100,1000,50).accessoSsh(true).catidadSitiosPermitidos(10).cantidadBaseDeDatos(1).build();
        PaqueteDeHosting oro =
        new PaqueteDeHostingBuilder("oro",new BigDecimal(500),100,4000,100).accessoSsh(true).catidadSitiosPermitidos(100).cantidadBaseDeDatos(5).ipPublica("10.10.10.10").build();

    }
```

Como vemos esto es mucho más sencillo de leer (aparte que la línea se alarga un poco, podríamos hacer varias líneas), y deja al objeto siempre en un estado consistente. Este método de construcción por medio de llamadas encadenadas se llama interfaces fluídas, y es el punto de inicio para muchos lenguajes como Groovy, que crean construcciones bastantes complejas a partir de Builders sencillos que permiten muchas configuraciones.

De nuevo, este no es el Builder de GoF, que veremos en otra ocasión, pero es otro concepto de Builder. Tiene la ventaja que es fácil de entender y de implementar. Imagino que ya se les ocurrió varias maneras de implementarlo en su código actual, así que manos a la obra y a dejar bonito el código! Finalmente les dejo el [código fuente de los ejemplos aquí.](https://guisho-media.s3.amazonaws.com/uploads/2009/05/builderpattern-fluidinterfaces.zip)  
[payday advance loans online](http://aupaydayloans.com/)
