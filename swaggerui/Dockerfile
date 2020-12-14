FROM swaggerapi/swagger-ui:v3.36.0 AS swaggerui

FROM nginx:1.19.5-alpine

COPY --from=swaggerui /usr/share/nginx/html /usr/share/nginx/html

###################
RUN apk --no-cache update && apk --no-cache add tini

COPY ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint

COPY ./development.conf /etc/nginx/adminer-development.conf
COPY ./production.conf /etc/nginx/adminer-production.conf

RUN chmod +x /usr/local/bin/docker-entrypoint

EXPOSE 80

ENTRYPOINT ["/sbin/tini", "/usr/local/bin/docker-entrypoint"]