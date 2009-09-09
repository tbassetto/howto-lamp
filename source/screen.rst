.. include:: substitutions.inc

screen
======

Généralités
***********

Quand vous êtes connecté depuis votre ordinateur sur votre serveur vous n'avez en général qu'une seule fenêtre avec un seul prompt. Cette situation peut vite devenir gênante si vous êtes en train d'éditer un fichier et que vous redémarrez un service en même temps pour voir si vos modifications fonctionnent. Le cheminement dans ce cas là est le suivant :
* vous ouvrez le fichier à modifier dans un éditeur de texte,
* vous faites vos modifications,
* vous fermez l'éditeur,
* vous relancez le serveur,
* vous vous apercevez que ça n'a pas marché,
* vous ouvrez à nouveau le fichier pour refaire des modifications,
* etc.

:program:`screen` permet d'ouvrir des fenêtres parallèles au sein de votre terminal pour par exemple en avoir une ouverte sur le fichier à éditer et une autre pour redémarrer le programme. Vous pouvez également vous déconnecter de |ssh| mais laisser vos *screens* ouverts, ce qui vous permettra de vous y *rattacher* lors de votre prochaine connexion.

:command:`screen`
  Permet de créer un *screen* de type *bash*. Pour créer un screen d'un type différent il suffit de lancer :command:`screen commande`, ce qui créé un *screen* spécialement dédié à cette commande.

:command:`screen -t "nom"`
  Permet de créer un *screen* avec le titre "nom".
  
:command:`screen -S NOM_DE_SESSION`
  Permet de créer un *screen* avec un nom de session plus explicite permettant ainsi de le rattacher plus facilement.

:command:`screen -r PID ou NOM_DE_SESSION`
  Permet de se rattacher à un *screen* détaché au préalable grâce à son PID ou son NOM_DE_SESSION s'il s'agit d'un *screen* créé avec cette option.

:command:`screen -ls`
  Permet d'obtenir la liste des *screens* avec leurs PID.

Liste des commandes sous :program:`screen`
******************************************

L'ensemble des commandes sous screen commencent toujours par ``Ctrl+a``. Voici la liste des commandes les plus utiles dans les screens.

:kbd:`Ctrl+a c`
  Permet de créer un nouveau *screen*.

:kbd:`Ctrl+a A`
  Permet de modifier le titre d'un *screen*.

:kbd:`Ctrl+a k`
  Permet de détruire le *screen* courant (demande une confirmation).

:kbd:`Ctrl+a w`
  Permet d'obtenir une liste des *screens*.

:kbd:`Ctrl+a 0-9`
  Permet d'aller directement au *screen* numéro 0-9.

:kbd:`Ctrl+a n`
  Permet d'aller au *screen* suivant.

:kbd:`Ctrl+a p`
  Permet d'aller au *screen* précédent.

:kbd:`Ctrl+a Ctrl+a`
  Permet de jongler entre les deux derniers *screens* utilisés.

:kbd:`Ctrl+a ?`
  Permet d'afficher l'ensemble des commandes *screen*.

:kbd:`Ctrl+a d`
  Permet de se détacher du *screen* courant.

:kbd:`Ctrl+a Ctrl+\\`
  Permet de fermer *screen* (demande une confirmation).

:kbd:`Ctrl+a [`
  Permet de démarrer le mode copie.

:kbd:`Ctrl+a ]`
  Permet de coller ce qui a été précédemment copié.

Mode copie
**********

Une fois que vous avez démarré le mode copie grâce à la commande :kbd:`Ctrl+a [`, il faut définir des délimiteurs entre lesquels le contenu sera copié. Pour cela vous pouvez vous déplacer grâce aux touches :kbd:`h`, :kbd:`j`, :kbd:`k` et :kbd:`l` (représentant les touches directionnels) mais également grâce à :kbd:`0` ou :kbd:`^` pour aller en début de ligne ou :kbd:`$` pour aller en fin de ligne. Une fois que vous êtes au point de départ de la copie appuyer sur :kbd:`Entrer`, déplacez-vous jusqu'au point de fin de copie puis appuyer sur :kbd:`Entrer`. Un message signale que la copie a été enregistrée. Pour coller il faut utiliser la commande :kbd:`Ctrl+a ]`, elle peut être utilisée dans un autre *screen*.

Fichier de configuration :file:`.screenrc`
******************************************

Voici un exemple de fichier de configuration :file:`.screenrc` qui doit être placé dans le répertoire personnel de l'utilisateur courant. Ce fichier permet de configurer :program:`screen` mais également d'afficher deux lignes en bas du terminal sous :program:`screen`. La première permet de d'afficher les différents *screens* et affiche en rouge le *screen* courant, la deuxième affiche le date et la distribution.

.. code-block:: bash

	deflogin on
	vbell off
	defscrollback 1024
	startup_message off

	# pour l'affichage des differents onglets (avant derniere ligne)
	caption always "%{+u wk}%?%-w%?%{rk}\%n %t/%{wk}%?%+w%?"
	# la ligne tout en bas
	hardstatus alwayslastline "%{+b kg}%H%{ky} > le %d/%m/%Y %c %{kg}%=%42`"
