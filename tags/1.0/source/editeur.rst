.. include:: substitutions.inc

nano, l'éditeur de texte
========================

Sous |linux| il existe de nombreux éditeurs de texte en ligne de commande. :program:`nano` est simple, installé par défaut mais beaucoup moins complet que des éditeurs comme :program:`emacs` ou :program:`vi`. Malgré tout il suffira pour faire les quelques modifications utiles dans ce tutoriel.

Pour éditer un fichier il suffit d'utiliser :command:`nano nom_du_fichier`. On rentre ensuite en mode édition du fichier. Les commandes sont affichées en bas de l'écran. Le caractère :kbd:`^` représente la touche :kbd:`Ctrl` du clavier.

Les raccourcis les plus importants sont :

:kbd:`Ctrl + G`
  Afficher l'aide.

:kbd:`Ctrl + K`
  Couper la ligne de texte (et la mettre dans le presse-papier).

:kbd:`Ctrl + U`
  Coller la ligne de texte que vous venez de couper.

:kbd:`Ctrl + C`
  Afficher à quel endroit du fichier votre curseur est positionné (numéro de ligne…).

:kbd:`Ctrl + W`
  Rechercher dans le fichier.

:kbd:`Ctrl + O`
  Enregistrer le fichier.

:kbd:`Ctrl + X`
  Quitter nano.

Un très bon tutoriel d'initiation à :program:`nano` est disponible sur le Site du zéro [#]_ 

.. note::
  
  :program:`nano` est configurable, il suffit de modifier le fichier :file:`.nanorc`. Pour cela connectez-vous en **root** puis copiez le fichier :file:`/etc/nanorc` dans votre répertoire home : :command:`cp /etc/nanorc /home/votre_pseudo/nanorc`. Puis changez le propriétaire : :command:`chown votre_pseudo /home/votre_pseudo/.nanorc`.

Les lignes que je préfère décommenter (et donc les options que j'active):

.. code-block:: bash

  set autoindent	# Autoindentation
  set backup	# Créé automatiquement une sauvegarde nom_fichier~
  set nonewlines	# Pas de nouvelles lignes à la fin du fichier
  set nowrap	# Ne coupe pas le texte (wrap)
  set rebinddelete # Utile quand on pilote le serveur via un Mac
  set smooth	# Defilement doux

Et surtout la coloration automatique :

.. code-block:: bash

  include "/usr/share/nano/nanorc.nanorc"	# Du fichier .nanorc
  include "/usr/share/nano/html.nanorc"		# Des fichiers HTML
  include "/usr/share/nano/sh.nanorc"		# Des fichiers bash

.. seealso::

   `Nano, l'éditeur de texte du débutant <http://www.siteduzero.com/tutoriel-3-12791-nano-l-editeur-de-texte-du-debutant.html>`_
      Documentation avec QCM par le Site du Zéro

   `Vim : l'éditeur de texte du programmeur <http://www.siteduzero.com/tutoriel-3-88344-vim-l-editeur-de-texte-du-programmeur.html>`_
      Documentation sur un autre éditeur de texte en ligne de commande plus puissant mais plus long à maîtriser

.. [#] http://www.siteduzero.com/tuto-3-24614-1-nano-l-editeur-de-texte-du-debutant.html