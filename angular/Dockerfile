FROM node:12.10.0-buster

WORKDIR /opt

RUN npm install -g @angular/cli

RUN npm install package-merge

ENV NODE_PATH /opt/node_modules

# WORKDIR /rapydo/
WORKDIR /modules/

EXPOSE 8080

RUN mkdir /docker-entrypoint.d/
COPY ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint

# ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["docker-entrypoint"]