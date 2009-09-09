.. include:: substitutions.inc

Monitoring
==========

Il est important de surveiller l'état de votre serveur et d'être prévenu si une anomalie survient, le plus souvent par e-mail.

Monit
*****

Monit est une application permettant de surveiller l'état des services (notamment web, ftp, mail, mysql, ssh) par une interface web, et de notifier l'administrateur si nécessaire (trop grande charge cpu, redémarrage, indisponibilité...).

L'installation de Monit se réalise en quelques secondes grâce au paquet éponyme : :command:`apt-get install monit`.

La configuration de Monit se fait en deux temps. Tout d'abord, autoriser le démarrage du service en éditant :file:`/etc/default/monit` : :command:`nano /etc/default/monit`.

Modifier l'option *startup* à *1*.

.. code-block:: bash

	startup=1

Ensuite, éditer le fichier de configuration :file:`/etc/monit/monitrc` contenant la description de tous les services à surveiller.

Voici un exemple complet. Celui-ci est relativement explicite et à adapter selon votre configuration.

set mailserver
  Indique le(s) serveur(s) de mail à utiliser pour l'envoi des notifications

set alert
  Indique les adresses destinataires

set httpd port
  Spécifie le port de connexion web. Vous pourrez ensuite vous connecter grâce à votre navigateur sur l'IP et le port correspondant (ex: http://monserveur:1337)

allow monlogin:monpassword
  Spécifie le couple login/password pour l'accès web (à renseigner)

check device
  Va permettre de surveiller l'espace disque restant : il faut ici indiquer le bon chemin vers /dev/XXX correspondant à la partition à monitorer (ex : /dev/sda, /dev/md1... selon votre configuration)

.. code-block:: bash

	# Config
	set daemon 120
	set logfile syslog facility log_daemon
	set mailserver localhost
	set mail-format {
	    from: monit@$HOST
	    subject: $HOST - Monit : $EVENT $SERVICE
	    }
	set alert root@monserveur
	set httpd port 1337 and
	   allow login:password

	# Apache 2
	check process httpd with pidfile /var/run/apache2.pid
	group apache
	start program = "/etc/init.d/apache2 start"
	stop program = "/etc/init.d/apache2 stop"
	if failed host 127.0.0.1 port 80
	protocol http then restart
	if 5 restarts within 5 cycles then timeout
	if cpu is greater than 85% for 2 cycles then alert
	if cpu > 90% for 5 cycles then restart
	if children > 250 then restart

	# MySQL
	check process mysqld with pidfile /var/run/mysqld/mysqld.pid
	group database
	start program = "/etc/init.d/mysql start"
	stop program = "/etc/init.d/mysql stop"
	if failed host 127.0.0.1 port 3306 then restart
	if 5 restarts within 5 cycles then timeout

	# SSH
	check process sshd with pidfile /var/run/sshd.pid
	group ssh
	start program "/etc/init.d/ssh start"
	stop program "/etc/init.d/ssh stop"
	if failed host 127.0.0.1 port 22 protocol ssh then restart
	if 5 restarts within 5 cycles then timeout

	# Postfix
	check process postfix with pidfile /var/spool/postfix/pid/master.pid
	group mail
	start program = "/etc/init.d/postfix start"
	stop  program = "/etc/init.d/postfix stop"
	if failed port 25 protocol smtp then restart
	if 5 restarts within 5 cycles then timeout

	# Disk
	check device sda1 with path /dev/sda1
	if space usage > 85% then alert
	group system

Vous êtes libre d'ajouter tous les services à monitorer sur votre machine (fail2ban...). La syntaxe est abordable et les exemples nombreux. Pour vérifier cette syntaxe, utilisez la commande : :command:`/etc/init.d/monit syntax`.

Si aucun message d'erreur n'est indiqué, vous pourrez ensuite démarrer monit : :command:`/etc/init.d/monit start`.

Vérifiez une nouvelle fois la bonne interprétation de la configuration grâce à :command:`monit -v`.

Logwatch
********

Logwatch est par un démon pouvant analyser et résumer les logs générés par les autres services durant la journée pour en détecter d'éventuelles anomalies ou en tirer des statistiques. Il permet d'envoyer un e-mail récapitulatif quotidien à l'administrateur. Son installation est elle aussi très simple grâce à APT et au paquet éponyme : :command:`apt-get install logwatch`.

La configuration par défaut suffit amplement, il suffit de modifier le destinataire dans le fichier :file:`/usr/share/logwatch/default.conf/logwatch.conf`.

Modifiez l'option *MailTo* :

.. code-block:: bash

	MailTo = root@monserveur

Rkhunter
********

:command:`rkhunter` est un programme Unix qui permet de détecter les rootkits, portes dérobées et exploits. Pour cela, il compare le hash MD5 des fichiers importants avec les hash connus, qui sont accessibles à partir d'une base de données en ligne. Ainsi, il peut détecter les répertoires généralement utilisés par les rootkit, les permissions anormales, les fichiers cachés, les chaînes suspectes dans le kernel et peut effectuer des tests spécifiques à Linux et FreeBSD.

Vous pouvez l'installer grâce à : :command:`apt-get install rkhunter`. Il a besoin de la commande :command:`strings` qui est disponible en installant :command:`binutils` : :command:`apt-get install binutils`.

Il procédera à des détections journalières anti-rootkits et enverra des notifications par e-mail si nécessaire. Il est conseillé de l'installer très tôt car il calcule l'empreinte MD5 des programmes installés afin de détecter d'éventuels changements. Editez :file:`/etc/default/rkhunter` pour indiquer l'adresse de notification et l'exécution journalière.

.. code-block:: bash

	REPORT_EMAIL="root@monserveur"
	CRON_DAILY_RUN="yes"

En cas de fausses détections positives sur des répertoires ou fichiers existants et sains, éditez :file:`/etc/rkhunter.conf` pour les ajouter à la liste des éléments autorisés.

Pour lancer un test à n'importe quel moment il suffit de taper :file:`rkhunter -c`.

.. todo:: Parler de l'email et update faits chaque semaine.

Décommentez aussi les liens suivante dans :file:`/etc/rkhunter.conf` :

.. code-block:: bash

	ALLOWHIDDENDIR=/dev/.udev
	ALLOWHIDDENDIR=/dev/.static

Il vous reste à mettre à jour le logiciel : :file:`rkhunter --update`.

Enfin, si vous faites des modifications (mises à jour ou installations) dans les dossiers contrôlés par :command:`rkhunter` il faut exécuter la commande suivante : :command:`rkhunter --propupd`. Elle permet de mettre à jour les tables de :command:`rkhunter` afin qu'il ne vous envoie pas de mail alors que vous avez fait consciemment des modifications.