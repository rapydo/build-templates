FROM node:12.10.0-buster

WORKDIR /app/

ENV NODE_PATH /opt/node_modules

RUN npm --prefix /opt install -g @angular/cli@8.3.5 dotenv@8.1.0 package-merge@0.1.2 

EXPOSE 80

RUN mkdir /docker-entrypoint.d/
COPY ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint

# ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["docker-entrypoint"]