#!/bin/bash
##############################################################
##              Script d'ajout d'un site web                ##
##           Par Thomas Bassetto et Julien Molina           ##
##############################################################
execute ( ) {
  eval "$@"
  if [ $? -gt 0 ]; then
    echo "La commande $@ a échoué."
    exit 1
  fi;
}
exitOnEmpty ( ) {
  if [ -z "$@" ]; then
    echo "Vous devez rentrer une valeur !"
    exit 1
  fi;
}

clear
echo -n "Nom de domaine (sans le www) : "
read NDD
exitOnEmpty "$NDD"

echo -n "Nom de l'utilisateur SFTP : "
read NAME
exitOnEmpty "$NAME"

echo -n "Adresse email : "
read EMAIL
exitOnEmpty "$EMAIL"

echo -n "Mot de passe MySQL (celui système sera demandé plus tard) : "
read MDPMYSQL
exitOnEmpty "$MDPMYSQL"

echo "##############################################################"
echo "##                   Demarrage de scponly                   ##"
echo "##############################################################"
execute "cd /usr/share/doc/scponly/setup_chroot/; ./setup_chroot.sh /home/$NAME $NAME www;cd -"
echo "##############################################################"
echo "##               Fin de l'execution de scponly              ##"
echo "##############################################################"
echo ""
echo "Execution de scponly                                      [OK]"

execute "mkdir -p /home/$NAME/dev"
execute "mknod -m 666 /home/$NAME/dev/null c 1 3"
echo "Creation du dev/null                                      [OK]"

execute "usermod -aG sitesweb $NAME"
echo "Ajout de l'utilisateur au groupe sitesweb                 [OK]"

execute "mkdir /home/$NAME/logs /home/$NAME/tmp /home/$NAME/sessions"
execute "chown -R www-data:www-data /home/$NAME/logs /home/$NAME/tmp /home/$NAME/sessions"
echo "Creation des dossiers logs tmp et sessions                [OK]"
   
echo '<VirtualHost *:80>

       ServerAdmin '$EMAIL'
       ServerName www.'$NDD'
       ServerAlias '$NDD' *.'$NDD'
   
       DocumentRoot /home/'$NAME'/www/

       <Directory /home/'$NAME'/www/>
               Order allow,deny
               Allow from all
               php_admin_value open_basedir /home/'$NAME'/www/
               php_admin_value error_log /home/'$NAME'/logs/error.php.'$NAME'.log
               php_admin_value upload_tmp_dir "/home/'$NAME'/tmp/"
               php_admin_value session.save_path "/home/'$NAME'/sessions/"
       </Directory>
       ErrorLog /home/'$NAME'/logs/error.'$NAME'.log
       CustomLog /home/'$NAME'/logs/access.'$NAME'.log combined
</VirtualHost>' > /etc/apache2/sites-available/$NDD
echo "Creation du vhost                                         [OK]"

execute "a2ensite $NDD > /dev/null 2>&1"
echo "Activation du site                                        [OK]"

execute "apache2ctl graceful > /dev/null 2>&1"
echo "Redemarrage d'Apache                                      [OK]"

echo "Entrez votre mot de passe root pour MySQL :"
execute "mysql -u root -p --exec=\"CREATE DATABASE $NAME;GRANT ALL PRIVILEGES ON $NAME.* TO '$NAME'@'localhost' IDENTIFIED BY '$MDPMYSQL';FLUSH PRIVILEGES;\""
echo "Creation de l'utilisateur MySQL                           [OK]"