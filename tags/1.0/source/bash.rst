.. include:: substitutions.inc

bash, le shell
==============

Par défaut le shell installé est :program:`bash`. Il est possible de le personnaliser en éditant le fichier :file:`.bashrc` qui se trouve dans le répertoire personnel de l'utilisateur (que ce soit **john** ou **root**).

Les deux choses qui nous intéressent le plus ici sont les *alias* et la mise en valeur du prompt quand on est connecté en **root**.

Les *alias* permettent de créer de nouvelles commandes utilisables dans le terminal, des sortes de raccourcis. Quelques alias pratiques sont (à rajouter à la fin du fichier :file:`/root/.bashrc`) :

.. code-block:: bash

  alias ls='ls -al' # Affiche le contenu de dossier en colonne et avec les fichiers cachés
  alias rm='rm -i' # Force rm à demander des confirmations pour les étourdis 
  alias ..='cd ..' # Remonter d'un répertoire facilement
  alias df='df -h' # Donne l'occupation des disques dans un format lisible
  alias du='du -hs' # Idem mais par répertoires
  alias golog='cd /var/log' # Aller dans les logs directement

Pour personnaliser le prompt, rajoutez à la fin du même fichier ``export PS1='[\t]\[\e[41;1;37m\]\u@\h:\w\[\e[0m\]\$ '``. Vous aurez ainsi un prompt blanc sur fond rouge avec la date au début. Pour prendre en compte ces modifications il faut se reconnecter ou utiliser la commande :command:`source /root/.bashrc`.