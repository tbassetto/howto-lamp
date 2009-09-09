phpMyAdmin
==========

Installation
************

Pour installer phpMyAdmin la commande est : :command:`apt-get install phpmyadmin`.

Configuration & sécurité
************************

Dans un premier temps il faut modifier le fichier de configuration qui est :file:`/etc/phpmyadmin/config.inc.php`.

Il est conseillé de changer le type d'authentification de cookie en http :

.. code-block:: php

  $cfg['Servers'][$i]['auth_type'] = 'http'; // Authentication method (config, http or cookie based)?

Dans un second temps il faut modifier le fichier :file:`/etc/apache2/sites-available/default` et ajouter les lignes suivantes à la fin du VirtualHost :

.. code-block:: text

  Alias /phpmyadmin /usr/share/phpmyadmin

  <Directory /usr/share/phpmyadmin>
    Options Indexes FollowSymLinks
    DirectoryIndex index.php
    Order allow,deny
    Allow from all
    <Files setup.php>
        Order allow,deny
        Deny from all
    </Files>
  </Directory>