FROM node:16.3.0-buster
# https://nodejs.org/en/blog/release

ARG CURRENT_UID
RUN test -n "$CURRENT_UID"
ARG CURRENT_GID
RUN test -n "$CURRENT_GID"

WORKDIR /opt/

# used by print_versions
ENV ANGULAR_VERSION 12.1.0
ENV NODE_PATH /opt/node_modules
ENV CYPRESS_PATH /usr/local/Cypress
ENV CYPRESS_VERSION 8.0.0
ENV CYPRESS_RUN_BINARY=${CYPRESS_PATH}/${CYPRESS_VERSION}/Cypress/Cypress

# Install Chrome
# from libgtk2.0-0 to xvfb are required by cypress as reported here:
# https://docs.cypress.io/guides/guides/continuous-integration.html#Dependencies
# dbus-x11 is required by chrome
RUN \
  wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
  echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list && \
  apt-get update && \
  apt-get install --yes --no-install-recommends vim libgtk2.0-0 libgtk-3-0 libgbm-dev libnotify-dev libgconf-2-4 libnss3 libxss1 libasound2 libxtst6 xauth xvfb dbus-x11 google-chrome-stable && \
  apt-get autoremove --yes && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

########################################################################
# Force installation of google-chrome 88 (Cypress becomes very slow starting from chrome 89)
########################################################################
RUN wget --no-verbose -O /tmp/chrome.deb http://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_88.0.4324.182-1_amd64.deb \
 && dpkg -i  /tmp/chrome.deb \
 && rm /tmp/chrome.deb
########################################################################


# Install Yarn and npm libs

RUN curl --compressed -o- -L https://yarnpkg.com/install.sh | bash && \
    yarn config set network-timeout 600000 -g

# 777 is required to let node user to write the folder, even when uid is fixed at runtime.
RUN yarn global add @angular/cli@${ANGULAR_VERSION} cypress@${CYPRESS_VERSION} ts-json-schema-generator@0.93.0 sitemap-generator-cli@7.5.0 angular-spec-generator@1.1.0 && mv /root/.cache/Cypress /usr/local/Cypress && chown -R node:node /usr/local/Cypress && chmod -R 777 /usr/local/Cypress

RUN yarn add dotenv@10.0.0 deepmerge@4.2.2 @types/node@15.12.5

WORKDIR /app/

EXPOSE 8080

EXPOSE 9876

# RUN mkdir /docker-entrypoint.d/
COPY ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint
COPY ./reload-types.sh /usr/local/bin/reload-types

RUN groupmod -og $CURRENT_GID node && usermod -u $CURRENT_UID node

# RUN chromium --version && google-chrome --version && firefox --version
RUN google-chrome --version

CMD ["docker-entrypoint"]

COPY banner.sh print_versions.sh /etc/
RUN echo '/bin/bash /etc/banner.sh' >> /etc/bash.bashrc

