MySQL
=====

Installation
************

Pour installer MySQL la commande est : :command:`apt-get install mysql-server mysql-client`.

Configuration & sécurité
************************

Le fichier de configuration est :file:`/etc/mysql/my.cnf`.

Les lignes à modifier à l'intérieur sont :

.. code-block:: bash

  language = /usr/share/mysql/french # Choisir la langue par defaut pour les messages du serveur
  #log_bin = /var/log/mysql/mysql-bin.log # Desactiver le log binaire
  #expire_logs_days = 10 # Idem
  #max_binlog_size = 100M # Idem
  log_slow_queries = /var/log/mysql/mysql-slow.log # Mettre en log les requetes lentes
  long_query_time = 2 # Duree (en secondes) a partir de laquelle une requete est consideree comme lente

  [client]
  default-character-set = utf8 # Jeu de caracteres par defaut pour le client, si vous voulez de l'UTF-8

  [mysqld]

  default-character-set = utf8 # Jeu de caracteres par defaut pour le serveur, si vous voulez de l'UTF-8
  default-collation = utf8_general_ci # Collation du jeu de caracteres, si vous voulez de l'UTF-8

Et enfin, redémarrer le serveur MySQL : :command:`/etc/init.d/mysql reload`.

Il est facile de mettre en place quelques règles simples pour sécuriser le serveur, grâce au script :command:`mysql_secure_installation`. Et en répondant à quelques questions (le script demande le mot de passe root, il est vide la première fois, appuyez juste sur kbd:`Entrée`) :

Set root password ? Y
  Permet de modifier le mot de passe root (de mysql)

Remove anonymous users ? Y
  Retire les accès anonymes

Disallow root login remotely ? Y
  Retire l'accès root distant (recommandé)

Remove test database and access to it ? Y
  Retire la base test et ses accès

Reload privilege tables now ? Y
  Recharge les privilèges suite aux modifications 

Utilisation
***********

Vous pourrez vous connecter en ligne de commande grâce au client : :command:`mysql -ulogin -p`. Pour les réfractaires, on verra plus tard comment utiliser un client graphique comme phpMyAdmin.

Commandes **shell** utiles :

:command:`mysqldump -ulogin -pmotdepasse nom_base --opt > fichier.sql`
  Exporte la base nom_base vers fichier.sql

:command:`mysqldump -ulogin -pmotdepasse --all-databases --opt > fichier.sql`
  Exporte toutes les bases vers fichier.sql

:command:`mysql -ulogin -pmotdepasse < fichier.sql`
  Importe les instructions du fichier SQL

:command:`mysqladmin`
  Toute une collection d'outils pour administrer le serveur
	
Commandes **MySQL** pour créer un utilisateur :

:command:`create database monsiteweb-fr;`
	Dans un premier temps il faut créer la base de données, nous choisissons le même nom que l'utilisateur

:command:`grant all privileges on monsiteweb-fr.* to 'monsiteweb-fr'@'localhost' identified by "motdepasse";`
	Ensuite nous donnons les droits à l'utilisateur monsiteweb-fr sur la base monsiteweb-fr qui pour se connecter grâce à son motdepasse

:command:`flush privileges;`
	Enfin il faut recharger les droits de mysql
	
Référez-vous à la documentation (:command:`man mysqldump`) pour plus de renseignements.

.. seealso::

  Ajouter un utilisateur : http://dev.mysql.com/doc/refman/5.0/fr/adding-users.html