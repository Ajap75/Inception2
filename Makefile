# ===========================================================================
# Makefile de gestion du projet Inception (build, up, down, clean, etc.)
# Ce fichier simplifie l'utilisation de Docker Compose, la gestion des images
# et la réinitialisation des données.
# ===========================================================================

# ---------
# Variables
# ---------

# Nom du projet (utilisé pour préfixer les noms de conteneurs/images)
NAME = inception

# Chemin du fichier docker-compose
COMPOSE_FILE = srcs/docker-compose.yml

# Commande docker compose (on explicite le fichier à utiliser)
DCOMPOSE = docker compose -f $(COMPOSE_FILE)

# -------------------------
# Règles Makefile principales
# -------------------------

# Par défaut, la cible 'all' lancera 'up'
all: up

# -------------------------
# Construction et démarrage du projet
# -------------------------

up:
	@$(DCOMPOSE) up -d --build
# Construit les images et lance les conteneurs en arrière-plan (-d)


init_data:
	@mkdir -p ~/data/wordpress
	@mkdir -p ~/data/mariadb
	@echo "Dossiers ~/data/wordpress et ~/data/mariadb créés (s'ils n'existaient pas déjà)"
# Crée les dossiers de volumes persistants si besoin (à lancer avant up)


logs:
	@$(DCOMPOSE) logs --follow
# Affiche tous les logs (stdout et stderr) de tous les conteneurs du projet, et suit en temps réel (--follow)


# -------------------------
# Arrêt et suppression des conteneurs
# -------------------------
down:
	@$(DCOMPOSE) down
# Arrête et supprime tous les conteneurs définis dans docker-compose.yml

# -------------------------
# Nettoyage : arrêt des conteneurs + suppression des images Docker du projet
# -------------------------
clean: down
	@docker image rm -f $$(docker image ls -q $(NAME)_*) || true
# Supprime toutes les images Docker dont le nom commence par 'inception_'
# (les $$ servent à échapper le $ dans Makefile)
# '|| true' évite l'échec si aucune image à supprimer

# -------------------------
# Nettoyage complet : clean + suppression des données persistantes
# -------------------------
fclean: clean
	@sudo rm -rf ~/data/wordpress ~/data/mariadb
# Supprime physiquement les dossiers de données WordPress et MariaDB sur la VM (persistance)
# (attention : requiert potentiellement le mot de passe sudo)

# -------------------------
# Rebuild complet du projet (nettoyage + rebuild/lancement)
# -------------------------
re: fclean up
# Fait un nettoyage complet puis relance tout à neuf

# -------------------------
# Fin du Makefile
# -------------------------

