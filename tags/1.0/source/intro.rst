.. include:: substitutions.inc

Introduction
============

Contexte
********

De nos jours on peut trouver des serveurs dédiés à bas prix. C'est une bonne solution pour ceux qui veulent héberger leur site Web pour un prix abordable tout en conservant la possibilité de configurer entièrement le système d'exploitation. Dans ce tutoriel, nous allons nous placer dans l'optique où plusieurs étudiants paient ensemble un serveur dédié, qu'ils se partagent pour héberger plusieurs sites Web. Par conséquent plusieurs concessions ont été faites, il n'est pas facile de trouver le juste milieu entre performance, sécurité et facilité d'utilisation…

En suivant ce tutoriel, vous obtiendrez *juste* un serveur suffisamment sécurisé et bien configuré pour héberger vos sites Web et éviter un minimum d'attaques malveillantes.

Finalité
********

* Le système d'exploitation utilisé est principalement une |debian| Etch 4.0.
* Nous allons tout installé avec les paquets |debian4| pour faciliter les mises à jour. Rien ne sera compilé.
* Le shell par défaut, |bash|, sera conservé mais personnalisé.
* Nous allons apprendre à nous servir de |screen|.
* |apache| et |php| seront configurés pour être le moins "bavard" possible.
* |apache| et |php| seront par défaut peu permissif. Les besoins particuliers des sites Web seront réglés au cas par cas dans le *VirtualHost*.
* Nous allons créer un compte système par site Web, pour faciliter la gestion des droits.
* Aucun serveur FTP ne sera installé ! À la place nous allons utilisé SFTP qui est quand même beaucoup plus sûr même si moins répandu.
* Nous allons bien sûr mettre en place un pare-feu, ainsi que |fail2ban|, |rkhunter| et |monit|.