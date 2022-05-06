FROM adminer:4.8.1

USER root

RUN apk --no-cache update && \
    apk --no-cache upgrade && \
    apk --no-cache add nginx autoconf gcc g++ make libffi-dev openssl-dev && \
    pecl install mongodb && \
    echo "extension=mongodb.so" > /usr/local/etc/php/conf.d/docker-php-ext-mongodb.ini

COPY --chmod=740 ./docker-entrypoint.sh /usr/local/bin/nginx-docker-entrypoint

COPY ./development.conf /etc/nginx/adminer-development.conf
COPY ./production.conf /etc/nginx/adminer-production.conf

RUN mkdir -p /run/nginx \
    && rm -f /etc/nginx/http.d/default.conf \
    && sed -i '3i/usr/local/bin/nginx-docker-entrypoint' /usr/local/bin/docker-php-entrypoint

EXPOSE 80

COPY --chmod=740 reload-adminer.sh /usr/local/bin/reload
COPY banner.sh print_versions.sh /etc/
RUN echo '/bin/ash /etc/banner.sh' >> ~/.bashrc
