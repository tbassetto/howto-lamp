PHP
===

Installation
------------

Pour installer PHP, la commande est : ``apt-get install libapache2-mod-php5 php5 php5-common php5-mysql``.

Vous remarquerez qu'on installe les modules PHP un par un (ici *php5-mysql* seulement). Pour installer l'extension GD (exemple) ``apt-get install php5-gd``.

Configuration & sécurité
------------------------

La configuration de PHP est stockée dans le fichier */etc/php5/apache2/php.ini*

Je vous encourage à modifier (ajouter le cas échéant) les lignes suivantes :

.. code-block:: bash

	allow_url_fopen = Off	# Rarement utile et source de problemes
	magic_quotes_gpc = Off	# Source de probleme (ajout de slashs aux variables GPC)
	memory_limit = 8M	# Si vous avez besoin de plus pour un site soit il est mal code soit ce sont des besoins specifiques qu'on reglera a part dans le VirtualHost apache. C'est la limite mémoire par script (donc par page Web...)
	post_max_size = 2M	# Avez-vous vraiment de si gros formulaire ? Si oui on reglera au cas par cas dans le VirtualHost
	short_open_tag=Off	# Pas de scripts qui commence par <? au lieu de <?php
	register_globals = Off	# Les variables EGPC ne seront pas globales par defaut et c'est tant mieux ! PHP6 supprimera cette option (le comportement sera a off)
	enable_dl = Off 	# Inutile sauf cas particulier et piratage...
	expose_php = Off	# Serveur moins bavard sur sa configuration
	display_errors = Off	# On n'affiche pas les erreurs sur un serveur en production
	log_errors = On		# Par contre il faut quand meme les enregistrer quelque part !
	error_log = /var/log/apache2/php.log # Fichier de log des erreurs

Et si vous souhaitez faire de l'UTF-8 (très conseillé) :

.. code-block:: bash

	mbstring.language=UTF-8
	mbstring.internal_encoding=UTF-8
	mbstring.http_input=UTF-8
	mbstring.http_output=UTF-8
	mbstring.detect_order=auto

Pour plus de sécurité, il est possible de désactiver des fonctions système. Ne le faites que si vous êtes sûr de leur non-emploi.

.. code-block:: bash

	disable_functions = symlink,shell_exec,exec,proc_close,proc_open,popen,system,dl,passthru,escapeshellarg,escapeshellcmd,openlog,apache_child_terminate,apache_get_modules,apache_get_version,apache_getenv,apache_note,apache_setenv,virtual

N'oubliez pas de redémarrer Apache !