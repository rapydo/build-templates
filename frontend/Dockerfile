FROM node:carbon

WORKDIR /opt

RUN git clone https://github.com/angular/angular-cli.git && cd angular-cli && npm link

RUN npm install package-merge

ENV NODE_PATH /opt/node_modules

WORKDIR /rapydo/

EXPOSE 8080

RUN mkdir /docker-entrypoint.d/
COPY ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint

# Only required for Angularjs ... remove me in a near future
RUN apt-get update && apt-get install -y unzip

# ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["docker-entrypoint"]