FROM node:12.10.0-buster

###################
ARG CURRENT_UID
RUN test -n "$CURRENT_UID"

WORKDIR /opt/

RUN apt-get update && apt-get install -y chromium
ENV CHROME_BIN chromium

ENV NODE_PATH /opt/node_modules

RUN npm install -g @angular/cli@8.3.5

RUN npm install dotenv@8.1.0 package-merge@0.1.2 

WORKDIR /app/

EXPOSE 8080

EXPOSE 9876

RUN mkdir /docker-entrypoint.d/
COPY ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint

RUN usermod -u $CURRENT_UID node

# ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["docker-entrypoint"]