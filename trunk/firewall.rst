Firewall
========

Netfilter et iptables
*********************

Depuis le noyau Linux 2.6, on dispose par défaut de la commande :command:`iptables` et de Netfilter pour mettre en place les meilleures règles de firewalls pour Linux. Il existe de nombreux scripts de configuration, en voici un à adapter à votre configuration. À tout instant, vous pouvez utiliser la commande :command:`iptables -L -v` pour lister les règles en place.

Celles-ci portent sur 3 chaînes : INPUT (en entrée), FORWARD (dans le cas d'un routage réseau) et OUPUT (en sortie). Les actions à entreprendre sont ACCEPT (accepter le paquet), DROP (le jeter), QUEUE et RETURN.

Arguments utilisés :

* i : interface d'entrée (input)
* o : interface de sortie (output)
* t : table (par défaut filter contenant les chaînes INPUT, FORWARD, OUTPUT)
* j : règle à appliquer (Jump)
* A : ajoute la règle à la fin de la chaîne (Append)
* I : insère la règle au début de la chaîne (Insert)
* R : remplace une règle dans la chaîne (Replace)
* D : efface une règle (Delete)
* F : efface toutes les règles (Flush)
* X : efface la chaîne
* P : règle par défaut (Policy)
* lo : localhost (ou 127.0.0.1, machine locale) 

Nous allons créer un script qui sera lancé à chaque démarrage pour mettre en place des règles de base. D'abord créons et remplissions notre fichier : :command:`nano /etc/init.d/firewall`.

.. code-block:: bash

	#!/bin/sh

	# Vider les tables actuelles
	iptables -t filter -F

	# Vider les règles personnelles
	iptables -t filter -X

	# Interdire toute connexion entrante et sortante
	iptables -t filter -P INPUT DROP
	iptables -t filter -P FORWARD DROP
	iptables -t filter -P OUTPUT DROP

	# ---

	# Ne pas casser les connexions etablies
	iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
	iptables -A OUTPUT -m state --state RELATED,ESTABLISHED -j ACCEPT

	# Autoriser loopback (localhost)
	iptables -t filter -A INPUT -i lo -j ACCEPT
	iptables -t filter -A OUTPUT -o lo -j ACCEPT

	# ICMP (Ping)
	iptables -t filter -A INPUT -p icmp -j ACCEPT
	iptables -t filter -A OUTPUT -p icmp -j ACCEPT

	# ---

	# SSH In : vérifiez bien votre port...
	iptables -t filter -A INPUT -p tcp --dport 22 -j ACCEPT

	# SSH Out : vérifiez bien votre port...
	iptables -t filter -A OUTPUT -p tcp --dport 22 -j ACCEPT

	# DNS In/Out
	iptables -t filter -A OUTPUT -p tcp --dport 53 -j ACCEPT
	iptables -t filter -A OUTPUT -p udp --dport 53 -j ACCEPT
	iptables -t filter -A INPUT -p tcp --dport 53 -j ACCEPT
	iptables -t filter -A INPUT -p udp --dport 53 -j ACCEPT

	# NTP Out : pour la mise à jour automatique de l'heure
	iptables -t filter -A OUTPUT -p udp --dport 123 -j ACCEPT
	
	# Whos is
	iptables -t filter -A OUTPUT -p tcp --dport 43 -j ACCEPT
	iptables -t filter -A INPUT -p tcp --dport 80 -j ACCEPT

	# HTTP + HTTPS Out
	iptables -t filter -A OUTPUT -p tcp --dport 80 -j ACCEPT
	iptables -t filter -A OUTPUT -p tcp --dport 443 -j ACCEPT

	# HTTP + HTTPS In
	iptables -t filter -A INPUT -p tcp --dport 80 -j ACCEPT
	iptables -t filter -A INPUT -p tcp --dport 443 -j ACCEPT
	iptables -t filter -A INPUT -p tcp --dport 8443 -j ACCEPT

	# Mail SMTP : on ne tient pas compte de POP(S) et IMAP(S) dans notre tuto
	iptables -t filter -A INPUT -p tcp --dport 25 -j ACCEPT
	iptables -t filter -A OUTPUT -p tcp --dport 25 -j ACCEPT

	# Monit : on va le voir plus tard :)
	iptables -t filter -A INPUT -p tcp --dport 1337 -j ACCEPT

Lorsque vous avez défini toutes les règles, rendez ce fichier exécutable : :command:`chmod +x /etc/init.d/firewall`.

Vous pourrez le tester en l'exécutant directement en ligne de commande : :command:`/etc/init.d/firewall`. Assurez-vous d'avoir toujours le contrôle de votre machine (reconnectez-vous en SSH, vérifiez la disponibilité des services web, ftp, mail...). En cas d'erreur, redémarrez le serveur, les règles seront oubliées et vous permettront de reprendre la main. En revanche, si les tests s'avèrent concluants, ajoutez le script au démarrage pour que celui-ci protège le serveur dès le boot. Afin de l'ajouter aux scripts appelés au démarrage : :command:`update-rc.d firewall defaults`.

Pour le retirer, vous pouvez utiliser la commande suivante : :command:`update-rc.d -f firewall remove`.

Redémarrez, ou exécutez :command:`/etc/init.d/firewall` pour activer le filtrage.

**N'oubliez pas de tester vos règles. Un mauvais choix peut entraîner une indisponibilité de votre serveur ou une perte de contrôle sur celui-ci avec le blocage de votre connexion SSH.**

..todo :: update-rc.d: warning: /etc/init.d/firewall missing LSB information \ update-rc.d: see <http://wiki.debian.org/LSBInitScripts>


Fail2ban
********

Fail2ban est un script surveillant les accès réseau grâce aux logs des serveurs. Lorsqu'il détecte des erreurs d'authentification répétées, il prend des contre-mesures en bannissant l'adresse IP grâce à :command:`iptables`. Cela permet d'éviter nombre d'attaques bruteforce et/ou par dictionnaire.

Pour l'installer il suffit de taper la commande :command:`apt-get install fail2ban`. Ensuite on va le configurer en éditant :command:`/etc/fail2ban/fail2ban.conf`.

Vérifiez la présence et l'activation de la ligne *logtarget = /var/log/fail2ban.log* qui correspond au fichier de log de :command:`fail2ban`.

Les services à contrôler sont stockés dans le fichier :file:`jail.conf`. Il est recommandé d'en effectuer une copie nommée :file:`jail.local` qui sera automatiquement utilisée à la place du fichier d'exemple : :command:`cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local` puis :command:`nano /etc/fail2ban/jail.local`. Ce fichier est divisé en sections, que l'on peut identifier grâce aux crochets : *[DEFAULT]*, *[ssh]*, etc.

Quelques paramètres utiles :

ignoreip = 127.0.0.1
  Liste des adresses IP de confiance à ignorer par fail2ban

findtime = 200000
  Durée sur laquelle Fail2ban analyse le fichier de log. Fail2ban n'analyse pas le fichier de log entièrement mais seulement sur cette durée, si cette option n'est pas défini elle est égale au bantime.
	
bantime = 86400
  Temps de ban en secondes. Ici une journée, on ne rigole pas.

maxretry = 3
  Nombre d'essais autorisés pour une connexion avant d'être banni

destemail root@monserveur
  Adresse e-mail destinataire des notifications

Chaque section possède ses propres paramètres qui prennent le pas sur les globaux s'ils sont mentionnés :

enabled
  Monitoring activé (true) ou non (false)

port
  Port concerné

logpath
  Fichier de log à analyser pour détecter des anomalies

filter
  Filtre utilisé pour l'analyser du log

Les filtres, par défaut, sont stockés dans */etc/fail2ban/filter.d*. Ils contiennent en général une instruction ``failregex`` suivie d'une expression régulière matchant la détection d'une authentification erronée. Par exemple pour le service SSH :

.. code-block:: bash

	failregex = (?:(?:Authentication failure|Failed [-/\w+]+) for(?: [iI](?:llegal|nvalid) user)?|[Ii](?:llegal|nvalid) user|ROOT LOGIN REFUSED) .*(?: from|FROM) <HOST>(?: port \d*)?(?: ssh\d*)?\s*$
	
Nous vous conseillons d'activer |fail2ban| pour |ssh|, mais aussi pour *postfix*, *apache* et *apache-noscript*. Cette dernière section vérifie les erreurs 404 sur les fichiers *.php* et *.asp*. Quand un site est bien codé, il ne devrait pas ressortir de telles erreurs, sauf si quelqu'un cherche une faille. Attention quand même si un jour pour changer toutes les URLs de votre site. Il y aura ainsi beaucoup d'erreur 404 pour les internautes provenant d'un moteur de recherche ou de leur marque-pages et ils seront bannis !

Vérifiez aussi la configuration de la section *[postfix]* car le fichier par défaut :file:`/var/log/postfix.log` n'existe peut-être pas sur votre machine. Remplacez-le par :file:`/var/log/mail.log` si c'est le cas.

.. note::

	Nous vous déconseillons de remplir et d'activer le champ *destemail* si vous comptez utiliser *logwatch* comme indiqué plus tard dans le tutoriel. En effet *logwatch* vous enverra **déjà** un compte-rendu des adresses IPs bannies, et fera doublon avec les emails de |fail2ban|.

.. note::

	Si vous souhaitez quand même être averti par email, profitez-en pour ne décommentez que la troisième ligne *action* qui permet d'inclure dans l'email la provenance de l'IP et les lignes de log incriminés. N'oubliez pas d'installer l'utilitaire *whois* s'il n'est pas par défaut sur votre système : :command:`apt-get install whois`.

Après modification de la configuration, n'oubliez pas de redémarrer |fail2ban| : :command:`/etc/init.d/fail2ban restart`.

Protection SYN/ACK
******************

Pour se protéger des attaques SYN/ACK exécutez la commande : :command:`echo 1 > /proc/sys/net/ipv4/tcp_syncookies`
 
.. todo:: Il faut mieux éditer le fichier /etc/sysctl.conf, ça évite de perdre les modifications au redémarrage