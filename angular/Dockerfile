FROM node:14.8.0-buster
# https://nodejs.org/en/blog/release

ARG CURRENT_UID
RUN test -n "$CURRENT_UID"
ARG CURRENT_GID
RUN test -n "$CURRENT_GID"

WORKDIR /opt/

ENV NODE_PATH /opt/node_modules

# yarn installation
RUN curl --compressed -o- -L https://yarnpkg.com/install.sh | bash

RUN yarn global add @angular/cli@10.0.8 ts-json-schema-generator@0.73.0

RUN yarn add dotenv@8.2.0 deepmerge@4.2.2

WORKDIR /app/

EXPOSE 8080

EXPOSE 9876

# RUN mkdir /docker-entrypoint.d/
COPY ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint

RUN groupmod -og $CURRENT_GID node && usermod -u $CURRENT_UID node

CMD ["docker-entrypoint"]