|ssh|
=====

Attention, si vous avez sautez le chapitre sur les utilisateurs, vous n'avez sûrement pas créé l'utilisateur *monsiteweb-fr* comme demandé. C'est le moment de le faire.

Comme on l'a déjà vu, la commande pour se connecter à notre serveur, la commande à utiliser est : :command:`ssh john@adresse_ip_du_serveur`.

Afin de sécuriser un minimum l'accès SSH au serveur, éditons le fichier :file:`/etc/ssh/sshd_config` : :command:`nano /etc/ssh/sshd_config`.

Modifiez (ou ajoutez cas échéant) les lignes suivantes :

.. code-block:: bash

  PermitRootLogin no        # Ne pas permettre de connexion directement avec root.
  Protocol 2                # Utilisation du protocole v2 uniquement.
  AllowGroups john sitesweb # L'utilisateur doit appartenir à un de ces groupes pour pouvoir se connecter

Le groupe *sitesweb* a été créé dans le chapitre précédent (les utilisateurs). N'oubliez pas non plus de rajouter le groupe de votre utilisateur "admin" (pour nous **john**) sinon vous ne pourrez plus jamais vous connecter à votre serveur :o)

Nous pourrions aussi changer le port de connexion par défaut pour éviter quelques attaques par bruteforce sur le port 22, mais c'est un leurre un peu faible. Un scan :program:`nmap` de votre serveur permettra de trouver facilement le nouveau port pour |ssh|. Nous n'allons pas parler du port-knoking non plus car son utilisation quotidienne devient vite pénible. 

Pour prendre en compte les changements il faut relancer le serveur SSH connecté en **root** : :command:`/etc/init.d/ssh restart`.

.. note::

  Nous verrons en dans le chapitre "Firewall" comment bannir les adresses IP essayant de se connecter en |ssh| par bruteforce.