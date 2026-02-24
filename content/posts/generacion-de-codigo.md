---
_edit_last: "2"
_jetpack_related_posts_cache:
  8f6677c9d6b0f903e98ad32ec61f8deb:
    expires: 1771520748
    payload:
      - id: 40
      - id: 765
      - id: 746
author: guisho
categories:
  - tech
date: "2007-09-29T03:21:07+00:00"
guid: http://guisho.com/guisho_2007/09/28/generacion-de-codigo/
parent_post_id: null
post_id: "56"
rank_math_internal_links_processed: "1"
rank_math_robots:
  - index
tags:
  - automatización
  - generación-de-código
  - industralización-del-software
  - sofware
title: Generación de código
url: /generacion-de-codigo/
views: "2081"

---
Cuando se aprende a programar, se encuentra el arte que hay detrás de ello. Cada paradigma y cada estilo llevan su arte dentro. Cualquier persona que gusta de escribir programas, añora los retos que un proceso complicado conlleva. Ante un problema cuya solución es complicada, las horas pasan rápido y la cantidad de neuronas que se ponen a funcionar dan una sensación equivalente a la adrenalina.

Lastimosamente, en el mundo de la programación, también hay muchas tareas que son sencillas y amargamente tediosas. Existen procesos en los que es necesario hacer algo una y otra vez, y en las que los métodos convencionales de reutilización de código son poco eficaces con algunas tareas.

Muchos años atrás me topé con ese problema: las tareas repetitivas no son agradables de realizar, y representan un porcentaje sustancial de un sistema de cómputo. Odiaba estar frente a esos casos en lo que había que hacer muchos catálogos, que en escencia eran mapear la base de datos a una pantalla para presentarlos al usuario y este fuera capaz de modificarlos.

¿Qué hacer para quitarme de encima esas aburridas tareas? Fui buscando soluciones y probando varias técnicas, y poco a poco fui llegando a la conclusión de que hay una forma eficiente y divertida de solucionar esas tareas: generando código. Haciendo programas que hicieran programas. Un concepto sencillo que se aplica todos los días al momento de utilizar un compilador.

Una vez tomada la desición de que la generación de código hacía el trabajo más emocionante, comencé a darme cuenta de las muchas otras ventajas que este método tenía. El trabajo se podía estandarizar de una gran manera, los errores se reducían en un gran margen, al solucionar un error en un lado se solucionaba en todos lados, se podían implementar mejores prácticas de manera sencilla, y muchas otras que iré mencionando con el tiempo.

A la fecha me sorprende el poco uso que se hace de la generación de código. Fuera de los compiladores comunes, pocas tareas se autimatizan. Estamos todavía con el concepto de hacer software como artesanía. Cada programador tiene su estilo y sus preferencias, sus estándares, sus reglas, su método de documentación. Un sistema que involucra un equipo de cinco programadores tendrá cinco estilos de programación, cinco paradigmas a veces convergentes.

Pronto apareció el concepto de industralización del software. Creo que hemos llegado a un punto en el que no es factible seguir haciendo software a la antigua. Los recursos humanos son muy limitados, y hay que asignarlos a las tareas más difíciles. Por todos lados aparecen frameworks que hacen más sencilla, o más legible, o más inteligente la programación, pero hay un problema de fondo: estamos mejorando los mangos de las herramientas, su ángulo de filo, las estamos haciendo ergonómicas, pero la producción sigue siendo manual. Es momento de hacer máquinas que hagan esas tareas, máquinas que corten, máquinas que permitan la producción en masa de nuestro producto final: programas.

La idea de realizar un programa en assembler, salvo casos muy específicos, aparece en nuestros días como una estupidez. Todos se han habituado al uso de compiladores. Pero falta dar un paso más allá y darnos cuenta de que escribir el código como se hace hoy, es también una estupidez.

Es sorprendente que no existan más lenguajes de dominio específico (DSL por sus siglas en inglés). El uso de los DSL's debe ser una herramienta importante en una organización. Hay muchas tareas que se pueden automatizar y no se hacen. En muchos casos XML se utiliza como herramienta de parseo, para crear lenguajes específicos. Si bien esto es una mejora, tiene sus limitaciones.

Cada vez hace falta más software, y los encargados de dar el producto tenemos que hacernos más eficientes, tenemos que producir más en menos tiempo. La generación de código no es la herramienta única, ni la que solucionará todos los problemas, pero es de las que más me gusta. En diez años creo que será tan común encontrarla entre las herramientas de un equipo de desarrollo como un compilador, y ojalá muchos de los proyectos que aparezcan comiencen en este lado del mundo, porque tenemos la habilidad de hacerlo. Póngamonos pilas y comencemos a generar código.
