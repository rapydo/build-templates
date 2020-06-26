FROM node:13.14.0-buster

ARG CURRENT_UID
RUN test -n "$CURRENT_UID"
ARG CURRENT_GID
RUN test -n "$CURRENT_GID"

# http://archive.ubuntu.com/ubuntu/pool/universe/c/chromium-browser/?C=M;O=D
# March 2018
ENV CHROMIUM_VERSION "65.0.3325.181" 
ENV CHROMIUM_URL "http://archive.ubuntu.com/ubuntu/pool/universe/c/chromium-browser"

# https://download-installer.cdn.mozilla.net/pub/firefox/releases/
# November 2017
# ENV FIREFOX_VERSION "57.0.1"
# November 2016
ENV FIREFOX_VERSION "50.0.1"
ENV FIREFOX_URL "https://download-installer.cdn.mozilla.net/pub/firefox/releases/$FIREFOX_VERSION/linux-x86_64/en-US/firefox-$FIREFOX_VERSION.tar.bz2"
ENV NODE_PATH /opt/node_modules

WORKDIR /opt/

########################################
# libgnome-keyring0 is required by chromium 49 (NOT required for chromium 65)
RUN \
  apt-get update && \
  apt-get install --yes --no-install-recommends vim xvfb && \
  apt-get autoremove --yes && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

########################################
# Install Chromium 65
RUN \
  wget --no-verbose -O /tmp/chromium-codecs-ffmpeg.deb "${CHROMIUM_URL}/chromium-codecs-ffmpeg_${CHROMIUM_VERSION}-0ubuntu1_amd64.deb" && \
  wget --no-verbose -O /tmp/chromium-codecs-ffmpeg-extra.deb "${CHROMIUM_URL}/chromium-codecs-ffmpeg-extra_${CHROMIUM_VERSION}-0ubuntu1_amd64.deb" && \
  wget --no-verbose -O /tmp/chromium-browser.deb "${CHROMIUM_URL}/chromium-browser_${CHROMIUM_VERSION}-0ubuntu1_amd64.deb" && \
  apt --yes install /tmp/chromium-codecs-ffmpeg.deb && \
  apt --yes install /tmp/chromium-codecs-ffmpeg-extra.deb && \
  apt --yes install /tmp/chromium-browser.deb &&
  rm /tmp/chromium-*.deb

ENV CHROME_BIN chromium
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

RUN chromium-browser --version && firefox --version

CMD ["docker-entrypoint"]