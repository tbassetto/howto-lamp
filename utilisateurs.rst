Gestion des utilisateurs
========================

La gestion des utilisateurs occupe un chapitre à elle toute seule car il y a beaucoup de connaissances théoriques à intégrer avant d'aller plus loin.

.. todo:: Parler de http://pwet.fr/man/linux/administration_systeme/useradd, umask, /etc/skel/, groupes, pam_umask, etc.

Comme nous l'avons déjà évoqué, vous avez pour l'instant deux utilisateurs pouvant se connecter à votre système : **root** et **john**.

Fichiers et répertoires à connaître
************************************

:file:`/etc/passwd`
  Ce fichier contient la liste des utilisateurs avec leurs caractéristiques, leur mot de passe chiffré et leur shell de connexion.

:file:`/etc/group`
  Ce fichier contient la liste des groupes disponibles sur le serveur.

:file:`/etc/shells`
  Ce fichier contient la liste des shells  de connexion autorisés pour les utilisateurs.

:file:`/etc/skel/`
  Contient la liste des fichiers qui seront placés dans le répertoire personnel d'un utilisateur lors de sa création.
  
:file:`/home/`
  Contient les dossiers personnels des utilisateurs, comme :file:`/home/john/` par exemple.

Création d'un groupe et d'un utilisateur
****************************************

Nous avons fait le choix de créer un utilisateur Linux par site Web hébergé sur le serveur. Une autre solution aurait été de créer un répertoire :file:`/var/www/nom_site/` pour chaque site Web. Chaque méthode à ses avantages et ses inconvénients. En faisant comme nous, vous aurez moins de soucis pour gérer les droits des fichiers et vous pourrez facilement abandonner le protocole FTP pour passer à une méthode plus sûre de transfert de fichier nommé SFTP (FTP over SSH).

Même si on reviendra plus tard sur SSH, il faut s'assurer que vous savez vous connecter à votre serveur. Normalement votre prestataire devrait vous l'avoir dit. Dans une console, tapez la commande :command:`ssh john@ip_serveur`. Et voilà !

Pour créer (respectivement supprimer) un utilisateur sous Debian il existe la commande :command:`adduser` (respectivement :command:`deluser`). Ces commandes sont spécifiques à Debian et ses dérivés, les commandes classiques sont :command:`useradd` et :command:`userdel` mais elles proposent moins d'options.

La commande pour définir ou changer le mot de passe d'un utilisateur est :command:`passwd john` et celle pour créer un groupe d'utilisateur est :command:`addgroup`.

On va donc commencer par ajouter un groupe **sitesweb**, dans lequel seront tous nos utilisateurs/sites Web :

.. code-block:: bash

  # addgroup sitesweb
  Adding group `sitesweb' (GID 1000) ...
  Done.

Le problème du shell
********************

À moins de vouloir faire un serveur FTP pour distribuer des fichiers (comme *ftp.debian.org* par exemple), vous n'aurez pas besoin d'un logiciel dédié à ce service. Nous allons donc éviter les solutions telles que :program:`proftpd` ou :program:`vsftpd` pour passer par |ssh|, qui est déjà installé sur la machine. Cette solution nous permettra en plus d'utiliser le protocole SFTP au lieu de FTP, qui est plus sûr (les transferts sont chiffrés).

Chaque utilisateur que l'on va créer pour les sites Web aura un accès SSH et donc l'accès SFTP. Mais l'accès SSH veut donc dire qu'il a accès à la console et à toutes les commandes disponibles sur le serveur. C'est le cas de notre utilisateur *john* par exemple. Cependant ce n'est pas forcément ce qu'on désire pour nos autres utilisateurs. Pour régler ces ennuis, nous allons installer un *shell* alternatif ne permettant d'utiliser que SFTP et nous allons aussi "chrooter" leur répertoire personnel pour qu'ils ne puissent pas se "balader" au delà.

SFTP et chroot
**************

Il existe deux principaux shells pour n'autoriser que SFTP : *rssh* et *scponly*. Nous allons utiliser ce dernier car le paquet fourni un script prêt à l'emploi qui nous facilite le travail.

Installons *scponly* : :command:`apt-get install scponly`. Lors de l'installation, la ligne :file:`/usr/sbin/scponlyc` est directement rajoutée à la fin du fichier :file:`/etc/shells` qui représente la liste des *shells* utilisables.

Ce paquet a rajouté à notre système un script tout fait pour rajouter des utilisateurs Linux ne pouvant utiliser que SFTP et disposant d'un environnement chrooté. Pour l'obtenir aller dans le bon répertoire : :command:`cd /usr/share/doc/scponly/setup_chroot/` et décompresser le : :command:`gunzip setup_chroot.sh.gz`. Donnons les droits d'exécution au fichier : :command:`chmod +x setup_chroot.sh` et lançons le pour créer notre premier utilisateur : :command:`./setup_chroot.sh`.

.. code-block:: text

  ./setup_chroot.sh 

  Next we need to set the home directory for this scponly user.
  please note that the user's home directory MUST NOT be writeable
  by the scponly user. this is important so that the scponly user
  cannot subvert the .ssh configuration parameters.

  for this reason, a writeable subdirectory will be created that
  the scponly user can write into.

  Username to install [scponly]monsiteweb-fr
	
Dans un premier temps le script vous demande le nom de l'utilisateur a créer (*monsiteweb-fr* dans notre cas)

.. code-block:: text

  home directory you wish to set for this user [/home/monsiteweb-fr]

Ici on vous demande le chemin du répertoire personnel de l'utilisateur, il est conseillé de laisser la valeur par défaut.

.. code-block:: text
	
  name of the writeable subdirectory [incoming]www

A cette étape il faut entrer le nom d'un répertoire qui sera créé dans le répertoire personnel de l'utilisateur et pour lequel celui-ci aura les droits en écritures (*www* dans notre cas). Il n'a pas accès en écriture à la racine de son répertoire personnel sinon il pourrait modifier les fichier du répertoire *.ssh/* et s'accorder plus de droits que nous le lui avons donné !

.. code-block:: text

  creating  /home/monsiteweb-fr/www directory for uploading files

  Your platform (Linux) does not have a platform specific setup script.
  This install script will attempt a best guess.
  If you perform customizations, please consider sending me your changes.
  Look to the templates in build_extras/arch.
   - joe at sublimation dot org

Pour finir on vous demande d'entrer un mot de passe pour le nouvel utilisateur. 

.. code-block:: text

  please set the password for monsiteweb-fr:
  Enter new UNIX password: 
  Retype new UNIX password: 
  passwd: password updated successfully
  if you experience a warning with winscp regarding groups, please install
  the provided hacked out fake groups program into your chroot, like so:
  cp groups /home/exemple-com/bin/groups

Il faut maintenant activer le bit SUID sur :file:`/usr/sbin/scponlyc` : :command:`chmod +s /usr/sbin/scponlyc`. Cette commande n'est à faire que lors de la création du premier utilisateur ! Pour les autres, il ne sera plus utile de la faire.

Sous |debian4| et |debian5| (aucune idée pour les autres distributions), il y a un bug à corriger : il faut créer un fichier :file:`/dev/null` dans le répertoire personnel :

.. code-block:: bash

  # cd ~monsiteweb-fr
  # mkdir dev
  # mknod -m 666 dev/null c 1 3

.. warning:: Pour finir, il faut rajouter notre nouvel utilisateur au groupe *sitesweb* : :command:`usermod -aG sitesweb monsiteweb-fr`. Ça y est vous pouvez vous connecter en SFTP avec l'utilisateur *monsiteweb-fr*.