FROM node:14.15.0-buster
# https://nodejs.org/en/blog/release

ARG CURRENT_UID
RUN test -n "$CURRENT_UID"
ARG CURRENT_GID
RUN test -n "$CURRENT_GID"

WORKDIR /opt/

ENV NODE_PATH /opt/node_modules

# yarn installation
RUN curl --compressed -o- -L https://yarnpkg.com/install.sh | bash && \
    yarn config set network-timeout 600000 -g


RUN yarn global add @angular/cli@10.2.0 ts-json-schema-generator@0.73.0

RUN yarn add dotenv@8.2.0 deepmerge@4.2.2 @types/node@14.14.6

WORKDIR /app/

EXPOSE 8080

EXPOSE 9876

# RUN mkdir /docker-entrypoint.d/
COPY ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint
COPY ./reload-types.sh /usr/local/bin/reload-types

RUN groupmod -og $CURRENT_GID node && usermod -u $CURRENT_UID node

CMD ["docker-entrypoint"]