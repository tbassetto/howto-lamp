.. include:: substitutions.inc

Debian, accès root et bases
===========================

Passer en mode super-administrateur (root)
******************************************

Comme vous devez déjà le savoir ce mode vous permet d'avoir tout les droits sur votre système. Contrairement à Ubuntu (pour ceux qui y sont habitués) où il suffit de rajouter :command:`sudo` devant la commande à exécuter, Debian requiert que l'on se connecte vraiment avec l'utilisateur *root*. Pour faire cela rien de plus simple : utiliser la commande :command:`su` puis rentrer le mot de passe *root* défini durant l'installation ou fourni par votre prestataire.

.. warning::

  Attention, ne restez connecté en *root* que le temps de faire vos modifications. Plus longtemps vous utilisez ce compte, plus vous avez de chance de faire une bêtise irréparable ! Pour se déconnecter il suffit de taper la commande :command:`exit`.

  Gardez à l'esprit que mis à part les utilisateurs systèmes (on ne se préoccupe pas d'eux, ils sont juste utile pour le fonctionnement de certains programmes), il n'existe pour l'instant que deux utilisateurs sur votre système : le super-administrateur *root* et votre utilisateur par défaut que l'on nommera *john* dans la suite de ce tutoriel.

.. todo:: Il faut expliquer ici ce que signigie les # et $ en début des lignes de commande.

Gestionnaire de paquet : :command:`apt-get`
*******************************************

Sous Debian, le principal logiciel pour gérer les (paquets) logiciels installés se nomme :command:`apt-get`. Il faut l'utiliser connecté en *root*.

Ci-dessous une liste des options les plus importantes :

:command:`apt-get update`
	Mise à jour de la liste des paquets avant l'installation d'un paquet ou d'une mise à jour du système. 

:command:`apt-get upgrade`
	Mise à jour tous les paquets du système en installant leurs dépendances.

:command:`apt-get install bar`
	Installe *bar* avec ses dépendances. 

:command:`apt-cache showpkg foo bar ...`
	Affiche l'information sur les paquets *foo* *bar* .... 

:command:`apt-get remove bar`
	Supprime le paquet *bar* mais garde ses fichiers de configuration. 

:command:`apt-get remove --purge bar`
	Supprime le paquet *bar* et tous ses fichiers de configuration. 

:command:`apt-cache search bar`
	Affiche les paquets dont le nom contient *bar*. 

L'option :command:`-s` couplée avec :command:`install` ou :command:`update` permet de simuler l'action (par exemple : :command:`apt-get install -s bar`). C'est par exemple utile pour vérifier les dépendances d'un paquet.

.. todo:: Parler de quand faire les mises à jour du système, comment se renseigner avant de le faire et comment réparer un système cassé.

Répertoires importants
**********************

Il peut être utile de savoir où sont stockés les fichiers importants :

:file:`/home/`
  Contient les répertoires personnels des utilisateurs.

:file:`/root/`
  Répertoire personnel du super-utilisateur *root*.

:file:`/etc/`
  Contient les fichiers de configurations des logiciels, répartis entre les sous-répertoires.
  
:file:`/var/log`
  Contient les fichiers de logs des logiciels, répartis entre les sous-répertoires.

.. todo:: Complèter la liste des répertoires importants.

Quelques commandes utiles
*************************

:command:`pwd`
  Cette commande permet de connaître le chemin complet du répertoire où l'on se trouve.
  
:command:`ls`
  Cette commande permet d'obtenir beaucoup d'informations sur les fichiers présents dans un répertoire. :command:`ls -al` permet d'afficher des informations les fichiers et répertoires cachés et les affiche en colonnes avec plus d'informations comme les droits, le propriétaire, etc.

:command:`mkdir`
  Cette commande permet de créer un répertoire, sa syntaxe est la suivante : :command:`mkdir [option] répertoire-à-créer`. L'option :command:`-p` permet de ne pas afficher d'erreur si le répertoire existe déjà.

:command:`touch`
  Cette commande permet de changer la date de modification d'un fichier, ou de le créer s'il n'existe pas. Sa syntaxe est la suivante : :command:`touch fichier-à-créer`.
	
:command:`cat` et :command:`less`
  La commande :command:`cat` permet de lire des fichiers. :command:`less` a l'avantage d'afficher le fichier page par page.
  
:command:`cp` et :command:`mv`
  La commande :command:`cp` permet de copier des fichiers, sa syntaxe est la suivante : :command:`cp [option] fichier-origine fichier-destination` ou :command:`cp [option] fichier répertoire`. :command:`mv` déplace les fichiers. On s'en sert aussi pour renommer les fichiers.
  
:command:`rm` et :command:`rmdir`
  La commande :command:`rm` permet de supprimer des fichiers. L'option :command:`-R` permet de le faire de façon récursive. :command:`rmdir` permet de supprimer des répertoires, si ils sont vides ! La commande :command:`rm -rf nom_du_repertoire/` permet de forcer la suppression du répertoire et de tout ce qu'il contient. Cette commande n'affiche aucun message même quand les fichiers sont inexistants, attention aux fausses manipulations avec cette commande, les résultats pourraient être catastrophiques.

:command:`find`
  La commande :command:`find` permet de retrouver des fichiers ou répertoires, sa syntaxe est la suivante : :command:`find [options]`. Les options les plus utiles sont :command:`-name nom-de-l-élément-à-trouver` et :command:`-type type-de-l-élément-à-trouver`.

:command:`chmod` et :command:`chown`
  La commande :command:`chmod` permet de modifier les droits du fichier ou répertoire. Les différents droits sont *r* pour *read* équivaut à 4 (le droit de lecture), *w* pour *write* équivaut à 2 (le droit d'écriture), *x* pour *execute* équivaut à 1 (le droit d'exécution). La commande peut s'utiliser de deux façons. La première :command:`chmod nnn élément-à-modifier` définit les droits pour chaque groupe, le premier *n* correspond à la somme des valeurs des droits pour l'utilisateur, le second *n* est pour le groupe et le troisième *n* est pour les autres. La seconde :command:`chmod groupe+droit élément-à-modifier` permet de modifier les droits pour un groupe (*u* pour *user*, *g* pour *group* et *o* pour *other*), on peut mettre autant de droits que l'on veut en ajoutant des :command:`+droit`, on peut les enlever en mettant des :command:`-droit`. Exemple :command:`chmod u+r-x fichier`.
  La commande :command:`chown` permet de changer le propriétaire et le groupe du fichier ou répertoire, sa syntaxe est :command:`chown propriétaire:groupe élément-à-modifier`.

:command:`df` et :command:`du`
  La commande :command:`df` permet de connaître la taux d'utilisation des disques durs, sa syntaxe est la suivante : :command:`du [option]`. L'option :command:`-h` permet de rendre le résultat facilement lisible.
  La commande :command:`du` permet de connaître l'espace pris sur le disque dur par le répertoire courant, sa syntaxe est la suivante : :command:`du [option]`. L'option :command:`-hs` permet de rendre le résultat plus lisible et de faire un résumé.
	
.. seealso::

   `Les commandes fondamentales de Linux <http://www.linux-france.org/article/debutant/debutant-linux.html>`_
      Présentation un peu plus avancée de commandes Linux utiles.
   
   `Aide-mémoire des commandes Linux <http://www.epons.org/commandes-base-linux.php>`_
      Aide-mémoire assez complet.

   `Les astuces les plus intéressantes  <http://www.commandlinefu.com/commands/browse/sort-by-votes>`_
      Le meilleur.
