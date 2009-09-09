#!/bin/bash
##############################################################
##           Script de désactivation d'un site web          ##
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

execute "usermod -L $NAME > /dev/null 2>&1"
echo "Utilisateur $NAME bloque                                  [OK]"

execute "a2dissite $NDD > /dev/null 2>&1"
echo "Desactivation du site                                     [OK]"

execute "apache2ctl graceful > /dev/null 2>&1"
echo "Redemarrage d'Apache                                      [OK]"

echo "Entrez votre mot de passe root pour MySQL :"
execute "mysql -u root -p --exec=\"REVOKE ALL PRIVILEGES,GRANT OPTION FROM '$NAME'@'localhost';FLUSH PRIVILEGES;\""
echo "Desactivation de l'utilisateur MySQL                      [OK]"