FROM adminer:4.7.7 AS adminer

# FROM php:7.3.24-apache-buster

# COPY --from=adminer /var/www/html /var/www/html

USER root

RUN apk --no-cache update && \
    apk --no-cache add nginx

COPY ./docker-entrypoint.sh /usr/local/bin/nginx-docker-entrypoint

COPY ./development.conf /etc/nginx/adminer-development.conf
COPY ./production.conf /etc/nginx/adminer-production.conf

RUN mkdir -p /run/nginx \
    && rm -f /etc/nginx/conf.d/default.conf \
    && chmod +x /usr/local/bin/nginx-docker-entrypoint \
    && sed -i '3i/usr/local/bin/nginx-docker-entrypoint' /usr/local/bin/docker-php-entrypoint

EXPOSE 80