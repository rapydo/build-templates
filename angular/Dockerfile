FROM node:16.10.0-buster
# https://nodejs.org/en/blog/release

ARG CURRENT_UID
RUN test -n "$CURRENT_UID"
ARG CURRENT_GID
RUN test -n "$CURRENT_GID"

RUN groupmod -og $CURRENT_GID node && usermod -u $CURRENT_UID node

ENV NODE_PATH /opt/node_modules
# used by print_versions
ENV ANGULAR_VERSION 13.3.1

RUN npm install -g npm yarn @angular/cli@${ANGULAR_VERSION} ts-json-schema-generator@1.0.0 sitemap-generator-cli@7.5.0 --force

RUN npm install --prefix /opt dotenv@16.0.0 deepmerge@4.2.2

WORKDIR /app/

EXPOSE 8080

COPY ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint
COPY ./reload-types.sh /usr/local/bin/reload-types

CMD ["docker-entrypoint"]

COPY --chmod=740 reload-angular.sh /usr/local/bin/reload
COPY banner.sh print_versions.sh /etc/
RUN echo '/bin/bash /etc/banner.sh' >> /etc/bash.bashrc
