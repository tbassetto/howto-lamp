Introduction
============

Contexte
********

De nos jours on peut trouver des serveurs dédiés à bas prix. C'est une bonne solution pour ceux qui veulent héberger leur site Web pour un prix abordable tout en conservant la possibilité de configurer entièrement le système d'exploitation. Dans ce tutoriel, nous allons nous placer dans l'optique où plusieurs étudiants paient ensemble un serveur dédié, qu'ils se partagent pour héberger plusieurs sites Web. Par conséquent plusieurs concessions ont été faites, il n'est pas facile de trouver le juste milieu entre performance, sécurité et facilité d'utilisation…

En suivant ce tutoriel, vous obtiendrez un serveur sécurisé et bien configuré pour héberger vos sites Web et éviter un minimum d'attaques malveillantes.

.. warning:: Gardez à l'esprit que devenir administrateur système est beaucoup plus long que la lecture de ce tutoriel. Si à la fin vous aurez acquis une abse solide, ça ne remplacera pas la pratique sur le long terme. N'oubliez pas qu'un serveur mal configuré ou non entretenu peu rapidement être détourné en relais à spam ou se faire tout simplement hacker.

Finalité
********

* Le système d'exploitation utilisé est une |debian5|.
* Nous allons tout installer avec les paquets fournis par |debian5| pour faciliter les mises à jour.
* Le shell par défaut, |bash|, sera conservé mais personnalisé.
* Nous allons apprendre à nous servir de |screen|.
* |apache| et |php| seront configurés pour être le moins "bavards" possible.
* |apache| et |php| seront par défaut peu permissifs. Les besoins particuliers des sites Web seront réglés au cas par cas dans le *VirtualHost*.
* Nous allons configurer |postfix| pour avoir une gestion minimale des emails (envoi par le système et |php|).
* Le :abbr:`SGBD (Système de Gestion de Base de Données)` installé sera MySQL.
* Nous allons créer **un compte système par site Web**, pour faciliter la gestion des droits.
* Aucun serveur FTP ne sera installé ! À la place nous allons utiliser **SFTP**, un protocole plus sûr même si moins répandu.
* Nous allons mettre en place un pare-feu, ainsi que les outils |fail2ban|, |rkhunter| et |monit|.
* Nous allons mettre en place un système de sauvegardes.