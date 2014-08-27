Apache
======

Installation
------------

Pour installer Apache il suffit de faire : :command:`apt-get install apache2`.

Les modules sont stockés dans */etc/apache2/mods-available/*. Si il en manque vous pouvez voir la liste des modules disponibles avec la commande :command:`dpkg -l libapache2-mod-*` (un ii devant le nom signifie que le paquet est déjà installé).

Tous les fichiers de configuration Apache sont stockés dans */etc/apache2/* :

apache2.conf
  Configuration générale (ancien httpd.conf).

mods-available/
  Modules disponibles.

mods-enabled/
  Modules activés.

sites-available/
  Sites disponibles.

sites-enabled/
  Sites activés.

Afin d'activer les modules, utilisez :command:`a2enmod` (Apache 2 Enable Module) suivi du nom du module. Par exemple, activons *mod_rewrite* pour permettre la réécriture des URLs : :command:`a2enmod rewrite`. Afin d'activer un site dont la configuration est stockée dans *sites-available*, utilisez :command:`a2ensite` (Apache 2 Enable Site). Pour désactiver un site, utilisez :command:`a2dissite`. Pour désactiver un module, utilisez :command:`a2dismod`.

Configuration & sécurité
------------------------

Le fichier */etc/apache2/ports.conf* fait la liste des ports écoutés par apache, vous pouvez vérifier que vous avez bien les lignes suivantes :

.. code-block:: bash
	
	Listen 80
	<IfModule mod_ssl.c>
		Listen 443
	</IfModule>

Passons enfin à la modification de */etc/apache2/apache2.conf*. Modifiez ou ajoutez les lignes suivantes :

.. code-block:: bash

	ServerTokens Prod		# Mettre Prod pour eviter au serveur d'etre trop bavard quand a la configuration de votre systeme
	ServerSignature Off		# Idem
	TimeOut 60			# La valeur par defaut, 300, est bien trop grande

On modifie également la fin du fichier en ajoutant juste avant les lignes

.. code-block:: bash

	# Include the virtual host configurations:
	Include /etc/apache2/sites-enabled/

Le code suivant :

.. code-block:: bash

	LogLevel info
	ErrorLog /var/log/apache2/error.log
	CustomLog /var/log/apache2/access.log combined

	<Directory />
	    Options None
	    AllowOverride None
	    Order Deny,Allow
	    Deny from All
	</Directory>

Le code compris dans *<Directory />* est général. Il interdit l'accès au site à quiconque, désactive toutes les options et empêche la prise en compte des fichiers *.htaccess* On réglera ces options au cas par cas pour chaque site.

L'hébergement virtuel par nom (une seule IP pour tous) est habituellement plus simple, car il vous suffit de configurer votre serveur DNS pour que chaque domaine pointe sur l'adresse IP dont vous disposez, et de configurer votre serveur Apache afin qu'il reconnaisse ces domaines. À noter que l'hébergement virtuel par nom ne peut pas être utilisé avec des serveurs sécurisés SSL à cause de la nature même du protocole SSL...

Commençons par modifier le fichier de configuration par défaut, celui qui est exécuté quand on accède au serveur via son adresse IP : :command:`nano /etc/apache2/sites-available/default` : 

.. code-block:: bash

	NameVirtualHost  *:80
	<VirtualHost *:80>
	  DocumentRoot /var/www/apache2-default
	  <Directory /var/www/apache2-default>
	    Order allow,deny
	    Allow from all
	    php_admin_value open_basedir "/var/www/apache2-default/"
	    php_admin_value error_log "/var/log/apache2/php.log"
	  </Directory>
	</VirtualHost>

.. warning:: Maintenant il est temps de créer la configuration pour notre premier site *www.monsiteweb.fr*. Rappelez-vous, c'est le nom de l'utilisateur qu'on a créé au début du tutoriel. Créons des sous-dossiers et attribuons leur les bon droits : :command:`cd /home/monsiteweb-fr/; mkdir logs tmp sessions; chown -R www-data:www-data logs tmp sessions`.

Créons maintenant le fichier de configuration de notre site : :command:`nano /etc/apache2/sites-available/monsiteweb-fr` et mettons-y : 

.. code-block:: bash

	<VirtualHost *:80>
	    ServerAdmin webmaster@monsiteweb.fr
	    ServerName www.monsiteweb.fr
	    ServerAlias monsiteweb.fr *.monsiteweb.fr

	    DocumentRoot /home/monsiteweb-fr/www/
	    <Directory /home/monsiteweb-fr/www/>
	        Order allow,deny
	        Allow from all
	        php_admin_value open_basedir "/home/monsiteweb-fr/www/"
	        php_admin_value error_log "/home/monsiteweb-fr/logs/error.php.monsiteweb-fr.log"
	        php_admin_value upload_tmp_dir "/home/monsiteweb-fr/tmp/"
	        php_admin_value session.save_path "/home/monsiteweb-fr/sessions/"
	    </Directory>

	    ErrorLog /home/monsiteweb-fr/logs/error.monsiteweb-fr.log
	    CustomLog /home/monsiteweb-fr/logs/access.monsiteweb-fr.log combined
	</VirtualHost>

Si on veut rajouter la prise en compte des *.htaccess* (même si ça implique une baisse des performances) il faut rajouter *AllowOverride All*. Pour activer des *Options*, comme la création de la liste de fichiers d'un dossier vide par exemple il faut mettre un + devant : *Options +Indexes*. On remarquera que les logs sont bien créé dans le dossier *logs/* du site web.

N'oubliez pas d'activer votre site Web : :command:`a2ensite monsiteweb-fr`. Après tout changement de configuration, n'oubliez pas de recharger la configuration : :command:`/etc/init.d/apache2 force-reload`. Mais il y a mieux encore ! Quand on veut redémarrer Apache je vous conseille : :command:`apache2ctl graceful`. Cette commande vérifie d'abord la syntaxe du fichier de conf Apache, puis redémarre Apache après que toute les connexions ouvertes aient été fermées.
