Conclusion
==========

Voilà, si vous avez suivi notre tutoriel jusqu'à la fin vous avez un serveur LAMP efficace. Bien sûr, il y a toujours des points à améliorer, ce que nous ne manquerons pas de faire dans notre prochaine version.

Petit bonus, si vous souhaitez pouvoir rajouter un nouveau site Web facilement, nous vous conseillons d'utiliser le script prévu spécialement à cet effet :

.. literalinclude:: _static/createWebSite.sh
   :linenos:

.. note:: Pour l'utiliser, enregistrer le dans un fichier :file:`creeSite.sh` par exemple, rajouter les droits d'éxecution, :file:`chmod +x creeSite.sh`, et exécuter le en étant **root**.

En superbonus, un script pour désactiver l'accès à MySQL, l'accès SFTP et l'accès HTTP à un utilisateur/site :

.. literalinclude:: _static/deactivateWebSite.sh
   :linenos:

Et un dernier pour supprimer toutes traces d'un site/compte :

.. literalinclude:: _static/deleteWebSite.sh
   :linenos:
