---
_edit_last: "2"
_jetpack_related_posts_cache:
  37550b67d263a3ce789993dc25046c5f:
    expires: 1770824848
    payload:
      - id: 773
      - id: 742
      - id: 751
      - id: 101
      - id: 749
      - id: 760
author: guisho
categories:
  - tech
date: "2005-12-13T10:39:52+00:00"
guid: http://guisho.com/?p=14
parent_post_id: null
post_id: "14"
rank_math_internal_links_processed: "1"
rank_math_robots:
  - index
tags:
  - sofware
title: Reporting with Java
url: /reporting-with-java/
views: "1182"

---
It's so frustating when it comes to reporting and you are a Java programmer. I love Java, I love the whole comunity around it, I love the big bunch of frameworks that are around there, I love all the open and free stuff that you can use and cotribute to, but when it comes to reporting, buhhh, it makes me want to cry.  
 As a programmer I don't like much to design things, it is not my work and it is not what I studied for, but with a regularity that should not be that high, I have to dive in the waters of designing, specially reports. It is obvius that enterprise applications require reports, charts, graphics, it is one of the roles of the system and it is pretty exiting to imagine queries and relations to get reports going. But translating the columns that are in a simple format in your sql editor or your bean to a fancy html, xls, pdf or any other format is really a pain to me, and I thing to the vast majority of programmers, but it is certainly a task we must do. It would be so easier if we could have the right tool to do this. Is in this little things is where I really envy all the people that work with Delphi or M$ Access (somebody will be laughing when reading this). But it is true, since I have been developing systems in Java this has been one of the major things that anoyed me. There is simply no decent reporting engine for java.  
 Shure, a lot of people will reply about Jasperreports and iReport, and I know, they are very good and these two friends are the ones that I use and have saved my eyes a lot of times. But I really think they are not enough. First they are not really easy to work with, or at least I believe so. Second the framework has a problem with some html reports, so a lot of times I have had to convince clients that PDF is a better format for reports, which is not really a reason.  
 There are tons of non free reporting engines out there that could help, but I haven't tried many of them because of the stupid licence they have and above all the stupid high price. I won't pay $2000 for an application that as whole costs that. CrystalReports? The same answer. Ok, I'm not asking for something free, but at least something reasonible. A company with this in mind can create a good reporting engine and sell it for, I don't know $100. It has not to be an all featured thing, with the basic things easy to perform a lot of guys like me would be gladly to buy it, although I still have the hope for open source cominity to come up with something.  
 I don't know, I think that this should be an easy and automatic task. I know that there fancy things and details that should be always taken in account, but generally reports should be a simple things to do. I have used some frameworks like xxx and yyy that let you design everything in Excel and then just fill the needed fields.  
 I really have a lot of hope in the future developing of iReport and JasperReports, really. I believe that a great advance would be that iReport would open a page or something to post templates. The few templates that are right now available are nice, and help to save a lot of time.Also I think birt, the Eclipse based proposal will be pretty usable in a short term. But for now we are far away from designing report as easy as you can design them in Access.

Among all the things I do in my daily life at work the thing I hate the most is to build and design reports. As a programmer I am not good at design and I really don't like it. I have always believed, and books have taught me, that this should be a designers job. But life is not that easy and very often the task of building reports relies on us, the programmers. Reports are an integral part of any enterprise system, and there is always need for fancy and new reports.  
 Some coleagues doesn't have this rage against building report, but deinetly must do. And if you are a Java programmer the thing becomes worse: therw is simply no right tool to build reports in an easy and quick way. It is really frustrating. Java is much more than a programming language, and as a whole it has so many valuable things to offer: a great programming language, huge community, tons of frameworks, plenty of free and relieable libraries, stability, multiplatform just to mention a few. But when it comes to reporting it has a lot to learn from other platforms. Although someone will laugh when reading this, I really envy those people that work with M$ Access, .Net or Delphi, for them is to easy to build in a couple of minutes a good looking and simple report.  
 There are a few things that a reporting tool should have to be called good.

\*It has to be easy to use. Again, we programmers do not like this kind of tasks and we look for simple and working solutions. We preffer to invest our times preparing an elegant query for a difficult report, but we hate to translate the result we see in our sql editor to a good looking format like PDF, XLS, HTML...  
 \*It has to optimize the more often used case. Templates, templates, easy templates. Those tools for other platforms are so great because they have a lot of templates, simple ones that can be used in any cases. I think the kery relies in templates. With a lot of templates I would be happy with almost every tool.  
 \*It interfases have to be easy to implement. There should not be work wasted trying to fill any report. What we want from a reporting tool is not any logic, it is simply presentation. We want our brute data transformed into a fancy format, that's all. The calculations the joining of the data and everything that has to do with the data is our job and we love it. We just want to present our data in a nice, good looking way.  
 \*Smart drag and drop. We wouldn't complaint much about doing reports if it would be an easy task. But we get pretty annoyed when we try to put a field value and it's name in a simple row and we see that they are not aligned and we spend a lot of bits of time trying to align them. And one aligned, we will never move them!  
 \*Wizards. I know, some of us think that wizards are not for good programmers, but I'd like to create reports using a simple wizard filled with a lot of templates. Imagine, build a simple report in five minutes.  
 \*Many output formats. I want my reports ready to be converted into PDF or XLS files without much effort.  
 \*Good documentation. As we have learn good documentation is key for any good application. If the reporting solution has a lot feautres it has to show them to the programmer and show him/her how to use them.

This is the point where more than one will be thinking, "hey, have you tried JasperReports? and iReport?" and my answer is yes. I have used iReport and JaspertReport. As a matter of fact it is what I use when I need to design reports. And let me say that both are great products and is amazing what you can do with both, I really congratulate the teams behind both projects. What I'm saying is that their features and easy of use are not enough (yet?). Building reports with Java is still a tough task and should not be. I have done complex reports and I'm thankful that JasperReports and iReport exists, because without them I would have had a bad time finishing those reports, but for the majority of simple reports that I have to design, they annoye me. Another big problem is that it is hard to export reports to HTML. To me this is the biggest drawback of JasperReports. I have had to convince some clients to use PDF instead of HTML and sometimes it was hard to me to convince them that PDF was a better solution, when the reality was that I had my reports already designed and they where not ready to be exported to HMTL. Another \*\*\* is the documentation. I think that I has grown, but when I started using jasperReports documentation was really a pain because there were no real documentation. If you wanted to learn to use the tool you had to browse in a lot of forums and mailing list to solve each one of you troubles. In some cases you just wanted to know how to do a little thing that you know had to exist, but you really din't have idea how to code it. We need simple and clear documentation, it can be a plain txt.

I will not talk about any other reporting tools, because these two are the most widely used in the Java arena, and when we speak about open source, commonly the most used is the best. I have tried a little of Birt, the Eclipse based porposal and I think it has future. If you google a little about this topic you fill find a lot of Java based reporting solutions. I have tried some of them but the licence schema and pricing are really stupid. Usually the licence is based in the cpu's running the engine, and I don't want to pay $2000 just to show four or five reports. CrystalReports have the same problem: it is a really rich reporting solution but far too expensive for most applications. Ok, I'm not asking for something free, but at least something reasonible. A company with this in mind can create a good reporting engine and sell it for, I don't know $100. It has not to be an all featured thing, with the basic things easy to perform a lot of guys like me would be gladly to buy it, although I still have the hope for open source comunity to come up with something.  
 I really have a lot of hope in the future developing of iReport and JasperReports. I believe that a great advance would be that iReport to give out more templates. The few templates that are right now available are nice, and help to save a lot of time, but cretainly there is the need for more. All I want and is a simple tool to build simple reports in and easy way and in short time, just as Access does.
