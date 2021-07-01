FROM node:16.3.0-buster
# https://nodejs.org/en/blog/release

ARG CURRENT_UID
RUN test -n "$CURRENT_UID"
ARG CURRENT_GID
RUN test -n "$CURRENT_GID"

WORKDIR /opt/

ENV NODE_PATH /opt/node_modules
# used by print_versions
ENV ANGULAR_VERSION 12.1.0

# yarn installation
RUN curl --compressed -o- -L https://yarnpkg.com/install.sh | bash && \
    yarn config set network-timeout 600000 -g

RUN yarn global add @angular/cli@${ANGULAR_VERSION} ts-json-schema-generator@0.93.0 sitemap-generator-cli@7.5.0

RUN yarn add dotenv@10.0.0 deepmerge@4.2.2 @types/node@15.12.5

WORKDIR /app/

EXPOSE 8080

EXPOSE 9876

# RUN mkdir /docker-entrypoint.d/
COPY ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint
COPY ./reload-types.sh /usr/local/bin/reload-types

RUN groupmod -og $CURRENT_GID node && usermod -u $CURRENT_UID node

CMD ["docker-entrypoint"]

COPY banner.sh print_versions.sh /etc/
RUN echo '/bin/bash /etc/banner.sh' >> /etc/bash.bashrc

