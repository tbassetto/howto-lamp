.. include:: substitutions.inc

Postfix, le serveur d'email
===========================

Postfix est le serveur SMTP de messagerie électronique libre le plus répandu. Il se charge de la livraison des e-mails et a été conçu de façon modulaire autour de différents programmes dévolus chacun à une tâche précise. 

Nous n'allons pas traiter ici de la configuration d'un vrai serveur email, par nom de domaine. Nous allons juste mettre en place le minimum pour pouvoir envoyer des emails via PHP et pour les alertes des logiciels de surveillance système, c'est tout.

Installation
************

L'installation est assez simple : :command:`apt-get install postfix mailx`.

Si l'installation ne vous propose pas directement de répondre aux questions de configuration des paquets, utilisez la commande : :command:`dpkg-reconfigure postfix`.

Voici les réponses-types à apporter dans la langue de Shakespeare. En ce qui concerne le nom du serveur, remplacez bien sûr *monserveur* par votre hostname (de préférence celui contenu dans le fichier :file:`/etc/hostname`) :

.. code-block:: text

	General type of configuration? <-- Internet Site
	Where should mail for root go <-- rien (laisser blanc)
	Mail name? <-- monserveur
	Other destinations to accept mail for? (blank for none) <-- monserveur, localhost
	Force synchronous updates on mail queue? <-- No
	Local networks? <-- 127.0.0.0/8
	Use procmail for local delivery? <-- Yes
	Mailbox size limit <-- 0
	Local address extension character? <-- +
	Internet protocols to use? <-- all
	
Configuration minimale
**********************

Le fichier de configuration principal de Postfix est :file:`/etc/postfix/main.cf`.

Description de certaines directives :

myhostname = monserveur
  Vérifiez que cette option contient bien le nom de domaine (FQDN) de votre serveur.

myorigin = /etc/mailname
  Cette option définit le nom utilisé par le serveur pour s'identifier. En précisant un nom de fichier (par défaut :file:`/etc/mailname`), le contenu de celui-ci sera lu et assigné à l'option. Dans notre cas, :file:`/etc/mailname` contient *monserveur*, n'hésitez pas à vérifier l'exactitude du contenu de ce fichier.

smtpd_banner = $myhostname ESMTP $mail_name (Debian/GNU)
  Bannière affichée lors de la connexion SMTP sur le port 25. Les variables commençant par $ seront remplacées par leurs valeurs définies précédemment. Soyez sobre.

mydestination = monserveur, localhost.localdomain, localhost
  Liste des domaines pour lesquels le serveur doit accepter le courrier.

relayhost =
  Pour effectuer les livraisons de courrier via un relais (ici vide).

mynetworks = 127.0.0.0/8
  Réseaux locaux autorisés.

mailbox_size_limit = 0
  Limite de taille pour les boîtes aux lettres, en octets (0 = illimité).

message_size_limit = 51200000
  Limite de la taille maximum d'un message, en octets (ici 50 Mo).

À ces directives je vous conseille d'ajouter les suivantes pour empêcher votre serveur de devenir un relais de SPAM :

.. code-block:: bash

	# Autorise les connexions depuis le réseau sûr seulement.
	smtpd_client_restrictions = permit_mynetworks, reject

	# Ne pas accepter de courrier des domaines qui n'existent pas.
	smtpd_sender_restrictions = reject_unknown_sender_domain

	# Liste blanche: les clients locaux peuvent indiquer n'importe quelle destination, pas les autres.
	smtpd_recipient_restrictions = permit_mynetworks, reject_unauth_destination

	# Bloquer les clients qui parlent trop tôt
	smtpd_data_restrictions = reject_unauth_pipelining
	
Après toute modification de ce fichier, redémarrez Postfix ou rechargez plus simplement la configuration grâce à :command:`postfix reload`, ou encore :command:`/etc/init.d/postfix reload`.
	
Pour tester l'envoi d'email vous pouvez utiliser le code suivant dans le terminal : :command:`echo "Salut, je suis un email." | mail -s "Hello world" john@gmail.com`.

Rediriger les emails envoyer à **root**
***************************************

Il est possible que certains logiciels envoie les emails au compte **root** de votre machine. Il seront stockés dans le fichier :file:`/var/mail/root` ce qui n'est pas très pratique pour les lire... Le mieux à faire est de rediriger les emails envoyés à **root** vers votre adresse email. Pour cela éditez le fichier :file:`/etc/aliases`: :command:`nano /etc/aliases` et modifiez la ligne commençant par *root:* pour y mettre votre adresse email. Exemple :

.. code-block:: bash

  root: john@gmail.com
  
.. warning:: Pour prendre en compte cette modification il vous faut ensuite utiliser la commande :command:`newaliases`. Dans la suite du tutoriel, on configurera les logiciels de monitoring pour qu'ils envoient leurs emails à *root@monserveur*.