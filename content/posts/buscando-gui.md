---
_edit_last: "2"
_jetpack_related_posts_cache:
  37550b67d263a3ce789993dc25046c5f:
    expires: 1771612210
    payload:
      - id: 198
      - id: 740
      - id: 23
      - id: 153
      - id: 747
      - id: 1159
_wpas_done_all: "1"
_wpcom_is_markdown: "1"
author: guisho Luis H. Fernandez
categories:
  - software-business
  - software-engineering
date: "2008-12-16T06:40:06+00:00"
guid: http://software.guisho.com/?p=26
parent_post_id: null
post_id: "748"
rank_math_internal_links_processed: "1"
rank_math_robots:
  - index
summary: 'Hace unas semanas comenté sobre las diferencias entre un ambiente de escritorio y un ambiente web. No me costó mucho comprender que debo comenzar con un ambiente web: lo conozco bien, tengo experiencia en él y manejo bien los conceptos y las tecnologías.'
tags:
  - gui
  - java
  - presentation-layer
  - software
  - zk
title: Buscando gui
url: /buscando-gui/
views: "3306"

---
Hace unas semanas comenté sobre las diferencias entre un ambiente de escritorio y un ambiente web. No me costó mucho comprender que debo comenzar con un ambiente web: lo conozco bien, tengo experiencia en él y manejo bien los conceptos y las tecnologías.

Por mucho tiempo mi plataforma de trabajo se basaba en hibernate, para la persistencia de datos, jsf para la presentación, más específicamente richfaces, junit para los tests. Simple pero funcional. En su momento tuve la disyuntiva richfaces-icefaces, pero decidí irme por richfaces porque me gustó más y por el hecho de que JBoss lo soportaba. Estaba comenzando con SEAM cuando tuve que hacer un deploy de un proyecto con richfaces en un weblogic 8 que costó muchísimo, lo que me hizo quererme hacer más independiente del servidor en el que instalo: que corra en tomcat.

Bueno, hoy me entero que jboss comenzó´a pasar su middleware a GWT. En pocas palabras me dijeron que abandonarán eventualmente el proyecto richfaces. Por ahora richfaces me funcionó bien, salvo algunos problemas de compatibilidad de exploradores. Pero adquirí mucho conocimiento al respecto y las cosas funcionaban como quería.

Ahora, lo más sabio es buscar y casarme con una nueva tecnología lo más pronto posible. Lo que me abruma es la cantidad de propuestas que existen. Los llamados RIAs ahora aparecen por todos lados. Cada framework con enfoques muy diferentes y propuestas más diferentes. Pero hay que elegir uno.

Hace unas semanas hice un poco de investigación. Al final creo que los competidores finales son:

- GWT.
- ZK.
- Echo
- OpenLaszlo.
- Flex.
- Appcelerator.
- AdobeAir
- JavaFx
- Wicket
- SmartClient
- SpringMVC
- OpenXava
- ItMill
- Rialto

Estas han sido mis opciones finales, sin embargo la oferta es considerablemente más amplia. Una búsqueda en google o en wikipedia les puede dar más luces. De todos estos frameworks algunos tienen un enfoque más geek, otro más "javero", otros mas xml, otros más swing, etc. Lo bueno es que hay mucho de donde elegir. Lo malo es, irónico, que hay mucho que elgir.
