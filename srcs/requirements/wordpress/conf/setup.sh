#!/bin/sh

# ----------------------------
#  VARIABLES
# ----------------------------

# Dossier où sera installé WordPress (dans le conteneur)
WP_DIR="/var/www/wordpress"

# ----------------------------
#  ATTENTE DE LA BASE DE DONNÉES
# ----------------------------

# On attend que MariaDB soit prêt à accepter les connexions
echo "Waiting for MariaDB to be ready..."
until
    mysqladmin ping -h"$MYSQL_HOST" -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" --silent
do
    sleep 1
done
echo "MariaDB is up! Proceeding..."

# ----------------------------
#  INSTALLATION DE WORDPRESS
# ----------------------------

# Si WordPress n'est pas déjà installé (pas de fichier wp-config.php)
if [ ! -f "$WP_DIR/wp-config.php" ]; then
    # 1. Télécharger les fichiers du noyau WordPress (s'il n'existe pas déjà)
    echo "Downloading WordPress core files..."
    wp core download --path="$WP_DIR" --allow-root

    # 2. Créer le fichier de configuration principal (wp-config.php)
    #    qui lie WordPress à la base de données MariaDB
    echo "Creating wp-config.php..."
    wp config create --path="$WP_DIR" \
        --dbhost="$MYSQL_HOST" \
        --dbname="$MYSQL_DATABASE" \
        --dbuser="$MYSQL_USER" \
        --dbpass="$MYSQL_PASSWORD" \
        --allow-root

    # 3. Installer WordPress (premier démarrage)
    #    --url : URL du site (doit correspondre au nom de domaine défini)
    #    --title : titre du site
    #    --admin_user / --admin_password / --admin_email : création du compte admin WP
    #    --skip-email : ne pas envoyer de mail de bienvenue
    echo "Installing WordPress..."
    wp core install --path="$WP_DIR" \
        --url="https://$DOMAIN_NAME" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN" \
        --admin_password="$WP_ADMIN_PWD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --skip-email \
        --allow-root

    # 4. Créer un utilisateur WordPress supplémentaire (rôle "auteur")
    echo "Creating additional WordPress user..."
    wp user create "$WP_USER" "$WP_USER_EMAIL" \
        --role=author \
        --user_pass="$WP_USER_PWD" \
        --path="$WP_DIR" \
        --allow-root

    echo "WordPress installation completed. Admin user '${WP_ADMIN}' and standard user '${WP_USER}' created."
else
    # Si déjà installé, on saute l'installation
    echo "WordPress is already configured (wp-config.php found). Skipping installation."
fi

# ----------------------------
#  LANCEMENT DU SERVICE PHP-FPM
# ----------------------------

# Démarre PHP-FPM en mode premier plan (option -F) pour rester "PID 1" dans le conteneur
echo "Starting PHP-FPM..."
php-fpm8.2 -F
