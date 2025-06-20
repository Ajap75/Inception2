
# Utiliser une image de base minimale (Alpine Linux v3.17) pour Nginx
FROM alpine:3.17


# Installer Nginx et OpenSSL (pour le certificat)
RUN apk update && apk add --no-cache nginx openssl


# Créer les dossiers nécessaires
RUN mkdir -p /run/nginx /etc/nginx/ssl /var/www/wordpress


# Copier la configuration Nginx dans le conteneur
COPY conf/nginx.conf /etc/nginx/conf.d/default.conf


# Générer un certificat auto-signé pour le domaine
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
-keyout /etc/nginx/ssl/website.key -out /etc/nginx/ssl/website.crt \
-subj "/C=FR/ST=Paris/L=Paris/O=42/OU=Inception/CN=${DOMAIN_NAME}"


# Exposer le port 443 (HTTPS)
EXPOSE 443


# Lancer Nginx en mode non-démon (au premier plan)
CMD ["nginx", "-g", "daemon off;"]