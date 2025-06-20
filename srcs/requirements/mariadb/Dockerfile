# ------------------------------------------------------------
# Dockerfile pour le service MariaDB de mon projet Inception
#
# Ici, j'utilise l'image officielle MariaDB version 10.7.4 comme base.
# Pourquoi ? Parce qu'elle embarque déjà tout ce qui est nécessaire :
#  - Le serveur MariaDB prêt à l'emploi
#  - Un script d'initialisation qui va :
#     * Créer une base de données et un utilisateur dédié
#     * Configurer le mot de passe root
#     * Appliquer toutes les variables d'environnement transmises au conteneur
# Cela me permet d'éviter de réinventer la roue et de suivre les bonnes pratiques DevOps.
# Je n'ai pas besoin d'ajouter d'autres instructions dans ce Dockerfile pour un usage WordPress classique,
# car toute la configuration (création de la base, de l'utilisateur, etc.) sera faite automatiquement
# au premier lancement du conteneur grâce aux variables d'environnement définies dans le docker-compose.
# ------------------------------------------------------------

FROM mariadb:10.7.4
