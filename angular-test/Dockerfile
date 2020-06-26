FROM node:13.14.0-buster

ARG CURRENT_UID
RUN test -n "$CURRENT_UID"
ARG CURRENT_GID
RUN test -n "$CURRENT_GID"

# https://download-installer.cdn.mozilla.net/pub/firefox/releases/
ENV FIREFOX_VERSION "77.0.1"

ENV FIREFOX_URL "https://download-installer.cdn.mozilla.net/pub/firefox/releases/$FIREFOX_VERSION/linux-x86_64/en-US/firefox-$FIREFOX_VERSION.tar.bz2"

ENV NODE_PATH /opt/node_modules

WORKDIR /opt/

########################################
# Install Chrome and Chromium
# xvfb is required by cypress
# dbus-x11 is required by chrome
# libdbus-glib-1-2 is required by firefox
RUN \
  wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
  echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list && \
  apt-get update && \
  apt-get install --yes --no-install-recommends vim xvfb dbus-x11 libdbus-glib-1-2 google-chrome-stable chromium && \
  apt-get autoremove --yes && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

########################################
# Install Firefox
RUN \
  wget --no-verbose -O /tmp/ff.tar.bz2 ${FIREFOX_URL} && \
  tar -C /opt -xjf /tmp/ff.tar.bz2 && \
  rm /tmp/ff.tar.bz2 && \
  ln -fs /opt/firefox/firefox /usr/bin/firefox

########################################
# Install Yarn
RUN curl --compressed -o- -L https://yarnpkg.com/install.sh | bash
RUN yarn add dotenv@8.2.0 deepmerge@4.2.2

########################################
# Install AngularCli and Cypress
RUN yarn global add @angular/cli@9.1.6 cypress@4.9.0

# 777 is required to let node user to write the folder, even when uid is fixed at runtime
RUN cp -r /root/.cache/Cypress /usr/local/Cypress && chown -R node:node /usr/local/Cypress && chmod -R 777 /usr/local/Cypress

ENV CYPRESS_RUN_BINARY=/usr/local/Cypress/4.9.0/Cypress/Cypress

########################################

WORKDIR /app/

EXPOSE 8080

EXPOSE 9876

RUN mkdir /docker-entrypoint.d/
COPY ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint

RUN groupmod -og $CURRENT_GID node && usermod -u $CURRENT_UID node

RUN chromium --version && google-chrome --version && firefox --version

CMD ["docker-entrypoint"]