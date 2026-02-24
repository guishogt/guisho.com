---
_edit_last: "2"
_jetpack_related_posts_cache:
  8f6677c9d6b0f903e98ad32ec61f8deb:
    expires: 1771577978
    payload:
      - id: 771
      - id: 773
      - id: 153
_wpas_done_all: "1"
_wpcom_is_markdown: "1"
author: guisho Luis H. Fernandez
categories:
  - software-engineering
date: "2008-11-21T16:42:42+00:00"
guid: http://software.guisho.com/?p=12
parent_post_id: null
post_id: "744"
rank_math_internal_links_processed: "1"
rank_math_robots:
  - index
summary: 'Un día de trabajo pesado, muchos problemas resueltos y una de las partes más difíciles del proyecto superada. Pluck, por alguna razón el editor se cierra. Un gran puñetazo en el escritorio: perdimos los cambios. O tal vez fue un gran cambio que comenzamos a hacer y no funcionó. Todos hemos pasado uno que otro mal momento por no saber organizar nuestro trabajo.'
tags:
  - buenas-prácticas---mejores-prácticas
  - cvs
  - manejo-de-versiones
  - software
  - svn
title: 'Buenas prácticas: Manejo de versiones.'
url: /buenas-practicas-manejo-de-versiones/
views: "18897"

---
Un día de trabajo pesado, muchos problemas resueltos y una de las partes más difíciles del proyecto superada. Pluck, por alguna razón el editor se cierra. Un gran puñetazo en el escritorio: perdimos los cambios. O tal vez fue un gran cambio que comenzamos a hacer y no funcionó. Todos hemos pasado uno que otro mal momento por no saber organizar nuestro trabajo.

De las buenas prácticas de desarrollo de software que quiero sacar a discusión, comenzaré con el manejo de fuentes. Sorprendentemente el manejo de fuentes y de versiones no se toma tan en serio como debería. Muchas veces he estado en proyectos, o los he visto, en los que muchos, muchísimos problemas surgen debido a espaguetis de código mal unidos, versiones que se creían diferentes, trabajo que se pierde.

Sobre la teoría del manejo de versiones se ha hablado mucho ya. No es algo sencillo en lo más mínimo, a mí me sigue asombrando lo eficientes que SVN o CVS son a pesar de lo complejo de su funcionamiento. Muchos buenos manuales existen para aprender a usar SVN o CVS. Yo en general me iría con alguno de ellos dos, aunque a la gente del entorno MS le podría servir más aprender sourcesafe.

Independientemente, mi punto es el siguiente: SIEMPRE hay que usar algún manejador de versiones. Es la primera cosa que un proyecto serio requiere. Es algo que ni siquiera debe ser apuntado, sino que siempre entendido que habrá un manejo de versiones.

¿Por qué? En lo personal las siguientes razones son los motivos por los qué uso un manejador de veriones.
+Backup. Son una manera muy sencilla para hacer copias de respaldo. Aunque sea una diaria.
+Cambios. Cuando quiero hacer un cambio peligroso, me quita el miedo de pasarme llevando algo por delante. Si eso pasara, simplemente vuelvo a una versión anterior.
+Manejo de versiones en sí. Un cliente quiere unas cosas, el otro otras, pero la base es la misma. Puedo mantener las fuentes exactas de cada instalación, añadir nuevas cosas y luego unirlas. Es una maravilla.
+Trabajo en equipo. El manejo de una manejador de versiones facilita enormemente el trabajo en equipo. Al final del día siempre hay una versión, igual para todos, y los cambios de cada uno los ve el otro. OJO un error común es es tratar al manejador como el que solucionará todos los problemas y no es cierto. La comunicación entre el equipo es siempre vital.
+Es sencillo. Cualquier IDE te permite importar tus fuentes a un repositorio y trabajar a partir de él sin mucho trabajo, incluso si estás comenzando a usar una manejador.

En resumen, en cualquier proyecto lo primero que deben hacer SIEMPRE es utilizar una manejador de versiones. Mis consejos son utlizar SVN o CVS, son sencillos, son libres, la mayoría de IDEs tiene extensiones para ellos y sobre todo les van a hacer la vida más sencilla.

Luis H. Fernández
luishernan@gmail.com

[Paperush](http://paperush.com/)
