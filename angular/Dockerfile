FROM node:13.14.0-buster

###################
ARG CURRENT_UID
RUN test -n "$CURRENT_UID"
ARG CURRENT_GID
RUN test -n "$CURRENT_GID"

WORKDIR /opt/

# chromium is requierd by jasmine
# xvfb is required by cypress
RUN apt-get update && apt-get install --yes --no-install-recommends chromium vim xvfb && apt-get autoremove --yes && apt-get clean && rm -rf /var/lib/apt/lists/*

ENV CHROME_BIN chromium
ENV NODE_PATH /opt/node_modules

# yarn installation
RUN curl --compressed -o- -L https://yarnpkg.com/install.sh | bash

RUN yarn global add @angular/cli@9.1.6 cypress@4.9.0

RUN yarn add dotenv@8.2.0 deepmerge@4.2.2

# not needed: npx cypress install
RUN cp -r /root/.cache/Cypress /usr/local/Cypress && chown -R node:node /usr/local/Cypress

ENV CYPRESS_RUN_BINARY=/usr/local/Cypress/4.9.0/Cypress/Cypress

WORKDIR /app/

EXPOSE 8080

EXPOSE 9876

RUN mkdir /docker-entrypoint.d/
COPY ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint

RUN groupmod -og $CURRENT_GID node && usermod -u $CURRENT_UID node

CMD ["docker-entrypoint"]