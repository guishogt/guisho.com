---
_edit_last: "2"
_jetpack_related_posts_cache:
  37550b67d263a3ce789993dc25046c5f:
    expires: 1771443735
    payload:
      - id: 773
      - id: 29
      - id: 744
      - id: 31
      - id: 3267
      - id: 3377
_thumbnail_id: "764"
_wpas_done_all: "1"
_wpcom_is_markdown: "1"
author: guisho Luis H. Fernandez
categories:
  - software-engineering
cover:
  alt: funny_hatchet
  image: https://guisho-media.s3.amazonaws.com/uploads/2009/06/funny_hatchet.jpg
date: "2009-06-21T16:40:01+00:00"
guid: http://software.guisho.com/?p=169
parent_post_id: null
post_id: "765"
rank_math_internal_links_processed: "1"
rank_math_robots:
  - index
summary: |-
  [ Hace algunos años ya me topé con el libro ["Pragmatic Programmer"  de Andrew Hunt y David Thomas](http://www.amazon.com/Pragmatic-Programmer-Journeyman-Master/dp/020161622X). Aconsejo a todos los que tengan la oportunidad que adquieran el libro y le den una buena leída. Muestra de manera clara muchas verdades que conocemos, pero que realmente pocas veces aplicamos. Algún día escribiré un post del libro. Pero hoy quiero enfocarme en el DRY Principle. A este principio se le conoce también como "single point of thruth" o "punto único de verdad".
  El principio establece que, en un entorno informático, la información no debe repetirse. Es decir, el conocimiento almacenado en un programa informático debe mantenerse en un, y sólo en un, lugar. De primas a primeras, el principio parece evidente, pero cuando investigamos algunas piezas de código, incluso las nuestras, nos damos cuenta que constantemente violamos el principio.
tags:
  - buenas-prácticas---mejores-prácticas
  - dont-repeat-yourself
  - dry-principle
  - no-te-repitas
  - pragmatic-programmer
  - principio-dry
  - software
title: 'NTR: No Te Repitas (DRY: Don''t Repeat Yourself)'
url: /ntr-no-te-repitas-dry-dont-repeat-yourself/
views: "7170"

---
[](https://guisho-media.s3.amazonaws.com/uploads/2009/06/funny_hatchet.jpg) Hace algunos años ya me topé con el libro ["Pragmatic Programmer"  de Andrew Hunt y David Thomas](http://www.amazon.com/Pragmatic-Programmer-Journeyman-Master/dp/020161622X). Aconsejo a todos los que tengan la oportunidad que adquieran el libro y le den una buena leída. Muestra de manera clara muchas verdades que conocemos, pero que realmente pocas veces aplicamos. Algún día escribiré un post del libro. Pero hoy quiero enfocarme en el DRY Principle. A este principio se le conoce también como "single point of thruth" o "punto único de verdad".

El principio establece que, en un entorno informático, la información no debe repetirse. Es decir, el conocimiento almacenado en un programa informático debe mantenerse en un, y sólo en un, lugar. De primas a primeras, el principio parece evidente, pero cuando investigamos algunas piezas de código, incluso las nuestras, nos damos cuenta que constantemente violamos el principio.

Para aclarar el concepto vamos con un ejemplo, harto común, con el que nos topamos constantemente. Supongamos que estamos haciendo una parte de un sistema en el cual se almacenará un catálogo de productos, digamos de frutas. Normalmente lo que haríamos es primero crear la base de datos. En la base de datos se tendrían estos campos: id, código, nombre, precio. En la misma base de datos agregamos ciertas restricciones al producto: el código es único y es una cadena de 10 caracteres, el nombre no puede ir vacío, el precio no pueden ser cero (observemos que incluso los tipos de esos datos radican en la creación de la tabla en la base de datos).

Una vez creada la base de datos, nos dirigimos a nuestro IDE para crear el código que trabajará con esos datos. Los enfoques varían mucho, y las maneras de trabajar con esos datos también. Pero en este caso vamos a trabajar con una capa de persistencia basada en un ORM (Object-Ralational Mapping). En algún lado de la configuración del ORM estableceremos que la tabla fruta se mapeará al objeto Fruta. Que el objeto Fruta tendrá un id, un nombre, un código y un precio.

Con nuestro mapeo funcionando, nos dirigimos a crear nuestro objeto Fruta. Nuestro objeto tendrá un BigInt para el id, tendrá un String para el código, otro para el nombre y un BigDecimal para el precio. Ahora crearemos los métodos de accesos (accessor methods) con su set y su get. Si la capa de persistencia nos echa una mano no tendremos que verificar que el código sea único, pero si no, tendremos que codificarlo nosotros.

Ahora, si somos queremos que nuestro código sea escalable y pueda mantenerse a largo plazo, utilizaremos alguna implementación del patrón MVC (Model-View-Controller, o Modelo-Vista-Controlador). En cada uno pondremos los respectivos campos de la fruta: el id, el código, el nombre y el precio. Haremos un listado de las frutas que hay almacenadas, y una forma para agregar y/o editar entradas.  En la vista le diremos al controlador qué desplegar, y haremos una tabla en el View. El model ya lo implementamos, que es nuestro objeto Fruta. Para la forma haremos lo mismo, pondremos los campos de fruta y lo guardaremos. Para proteger nuestro modelo haremos algunas validaciones del lado del servidor, pero para darle una experiencia interactiva al usuario, también haremos validaciones en el lado del cliente. Usaremos, claro está, uno de esos bonitos frameworks que ahora nos hacen la vida más fácil con javascript. La validación del código único requerirá una llamada de Ajax, y las demás serán simples validaciones con Javascript.

Ahora estamos a punto con el manejo de frutas en el sistema. Tenemos un diseño robusto, altamente escalable, muy legible. Pasamos nuestro trabajo orgullosos a control de calidad. Control de calidad nos informa que el máximo de caracteres de código es 10 y en el javascript del cliente nosotros pusimos 10. Bueno, un teclazo de más a cualquiera le pasa, ¿no?. Pasado un tiempo nos dicen que en el mapeo del ORM no pusimos correctamente el precio, y permitimos que sea vacío. Cosas, la prisa hizo que se nos pasara por alto. Pero pasado todo eso, todo bien.
Pasados unos días, nos mandan un requerimiento del cliente que pide que el código en vez de ser de 10 caracteres va a ser de 15 (cambiaron un par de cosas del negocio), y que hará falta otro código: el código de bodega que será de 20 caracteres y también hará falta el peso unitario, que será un decimal opcional.
En nuestra mente comienza a correr el tedioso proceso que tenemos que realizar: hacer los cambios en la base de datos, hacer los cambios en el mapeo, hacer los cambios en el objeto fruta, hacer los cambios en el controller y en el view para la lista, hacer los cambios en el controller y en el view (que incluye dos validaciones de javascript). Que tedio no????? Además....qué fácil será confundirnos.

A todo esto la documentación estaba ya lista, y habrá que cambiarla, pero por falta de tiempo creemos que se quedará tal y como está.

He aquí lo que nos pasa cuando violamos el principio DRY. El principio DRY establece que la información, o el conocimiento debe estar almacenado en UN SOLO LUGAR, para evitar el tedio de cambiar las cosas en mil lados cuando hacen falta cambios, además de ahorrarnos la tendencia a cometer errores cuando hay que cambiar muchas cosas que significan lo mismo. Analicemos los cambios: agregar un campo y modificar otro. Este conocimiento, en gran parte está almacenado en la base de datos (aunque no todo, por ejemplo en la base de datos no podemos hacer ciertas validaciones para los códigos, o cosas parecidas).

Por eso ideas como las aplicadas por ruby (convención sobre configuración) han sido muy populares últimamente. Grails ofrece también un enfoque bonito. Por ejemplo, si cambio las restricciones en mi setter de fruta, ¿no sería menester que esas restriccinoes se extendieran a todos lados? Agrego un campo en mi clase, agrego pesoUnitario, ¿no se deberían propagar estos cambios a la base de datos, a los controllers, a los views, al javascript, a la documentación? Por ello también soy un fan de la generación de código: permite reducir la redundancia de la información.

Nadie negará la utilidad de patrones como el MVC, o de ideas como el ORM. Pero a veces esas soluciones crean una sobre ingeniería tan grande que no sé si compensan sus soluciones. En nuestros tiempos donde los IDEs son tan poderosos nos deberían ayudar un poco más en este tema. No hablo de herramientas CASE, hablo de un nuevo enfoque de programación. Esperemos en el futuro surjan ideas y solucinoes nuevas (en las que espero ustedes y yo aportemos nuestra parte) para este problema de la constante violación del DRY. Programar debe simplificarse mucho. Hemos desarrollado soluciones a soluciones y cada año hay nuevas propuestas, pero siento lo mismo que hablaba una vez con alguien: estamos haciendo el mango del hacha más bonito, más durable, más ergonómico, más resistente a golpes...cuando lo que deberíamos estar haciendo es diseñando una sierra eléctrica!  

Can Soul Do My Essay Questions Hsc i patois do my english essay topics Possibly the adolescents skulle konsekvenserna kunna the ideals of person is trying finish sundry with kanske inte av lika stor betydelse as such are men om frskringskassan trying to base from the parents [sunvalleycharter.org](http://sunvalleycharter.org) They mustiness be use the drugs Xiannian, to junction children who pauperization. Avowal services – including avowal essay, scholarship essay and personal statement;

\|
