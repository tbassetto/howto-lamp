#!/bin/bash
##############################################################
##           Script de suppression d'un site web            ##
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

execute "deluser --remove-home $NAME > /dev/null 2>&1"
echo "Fichiers de $NAME supprime                                [OK]"

#execute "delgroup $NAME > /dev/null 2>&1"
#echo "Groupe $NAME supprime                                     [OK]"

execute "rm -f /etc/apache2/sites-enabled/$NDD > /dev/null 2>&1;rm -f /etc/apache2/sites-available/$NDD > /dev/null 2>&1;"
echo "Suppression du site dans Apache                           [OK]"

execute "apache2ctl graceful > /dev/null 2>&1"
echo "Redemarrage d'Apache                                      [OK]"

echo "Entrez votre mot de passe root pour MySQL :"
execute "mysql -u root -p --exec=\"DROP DATABASE $NAME;DROP USER $NAME;FLUSH PRIVILEGES;\""
echo "Suppression de l'utilisateur MySQL et de sa base          [OK]"