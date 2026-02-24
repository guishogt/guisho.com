---
_edit_last: "2"
_jetpack_related_posts_cache:
  8f6677c9d6b0f903e98ad32ec61f8deb:
    expires: 1771638365
    payload:
      - id: 3454
      - id: 10
      - id: 746
_wpas_done_all: "1"
_wpcom_is_markdown: "1"
author: guisho
categories:
  - software-engineering
  - tech
date: "2018-06-26T20:59:18+00:00"
guid: https://guisho.com/?p=3361
parent_post_id: null
post_id: "3361"
rank_math_internal_links_processed: "1"
rank_math_og_content_image:
  check: b5ee0c686f932ab5fd0ba54fddf84e5f
  images:
    - 3363
rank_math_robots:
  - index
tags:
  - en
  - open-source
  - software
title: Spanish Synonyms Finder for Alfred
type: image
cover:
  image: https://guisho-media.s3.amazonaws.com/uploads/2018/06/alfred.jpg
url: /spanish-synonyms-finder-for-alfred/
---
I installed Alfred yesterday and bought the power pack to be able to use the workflows feature. I started playing with it and found out a piece of functionality that I couldn't find: a Spanish Thesaurus. For English, I found one quickly. However, for Spanish, I was unable to find any, so I decided to build one myself.

My strategy to accomplish this:

- Find out how to use JS (and NodeJS) inside Alfred.
- Find a service that provides an API for Spanish (surprisingly there is none, or I couldn’t find one).
- As there was no API, I’d have to do some web scrapping. I found an excellent page to do so https://www.sinonimosonline.com/, and I hope I am not transgressing any law by doing so. If so, please let me know…

My pseudo code looks like this:

- Get the {query} to be searched for
- Request the URL with the {query}
- Parse the response
- Get the results in an array
- Send that to Alfred for display.

I found [alfy](https://goo.gl/kiLRQX) a nice library that facilitates the creation of Alfred workflows with JS. and based my efforts from there. The documentation is straightforward on how to use it. Before alfy I used axios to make the request but moved back to alfy to reduce dependency.

The final product looks like this:

![](https://guisho-media.s3.amazonaws.com/uploads/2018/06/Screen_Shot_2018-06-26_at_1_20_00_PM.png)

Is very simple to use. You call Alfred and then type sps (Spanish Synonym). Then you write the word you are looking for, and a series of synonyms appear. You can enter in any of them, and it will take you to the sinonimosenlinea.com page. You can type shift to see a previous as well.

The code is here: https://github.com/sindresorhus/alfy)
The packal site here: http://www.packal.org/workflow/spanish-synonyms

My first open source contribution for a while. Hope someone finds it useful.
