# ==========================================================================
# Dockerfile MariaDB — Projet Inception (42)
# Construction manuelle et sécurisée d'un conteneur MariaDB à partir d'Alpine
# ==========================================================================

# 1. Image de base — Alpine 3.17 (légère, maintenue, autorisée au sujet)
FROM alpine:3.17

# 2. Installation des paquets MariaDB et utilitaires nécessaires
RUN apk update && apk add mariadb mariadb-client mariadb-openrc
# - mariadb : le serveur principal
# - mariadb-client : outils pour se connecter/déboguer
# - mariadb-openrc : gestion du service (optionnel mais recommandé)

# 3. Initialisation de la base de données (création de la structure interne)
RUN mysql_install_db --user=mysql --datadir=/var/lib/mysql
# - Initialise les fichiers et dossiers nécessaires à MariaDB dans /var/lib/mysql
# - --user=mysql : fait en sorte que tout appartienne au bon user dès le début

# 4. Attribution des droits au user mysql (sinon MariaDB refusera de démarrer)
RUN chown -R mysql:mysql /var/lib/mysql
# - Permet à l'utilisateur mysql d'écrire/lire dans son dossier de base
# - Évite les erreurs "Permission denied" ou "Cannot run as root"

# 5. À partir de cette étape, on bascule sur l'utilisateur "mysql" pour la sécurité
USER mysql
# - Toutes les commandes suivantes, y compris le lancement du serveur, sont faites avec les droits "mysql"
# - Conforme aux exigences sécurité Docker et MariaDB

# 6. Déclaration du volume persistant (le dossier où MariaDB stocke toutes ses données)
VOLUME /var/lib/mysql
# - Docker va monter ici le volume défini dans docker-compose.yml (ex: /home/<login>/data/mariadb)
# - Assure la persistance des bases, users, mots de passe, etc.

# 7. Ouverture du port 3306 (interne à Docker, pas forcément exposé à l'extérieur)
EXPOSE 3306

# 8. Commande par défaut : lance le serveur MariaDB en "foreground" (pas en daemon)
CMD ["mysqld"]
# - PID 1 du conteneur, surveillé par Docker
# - Reste up tant que le serveur tourne
# - MariaDB refusera de démarrer en root (c'est pour ça qu'on a fait le USER ci-dessus)
