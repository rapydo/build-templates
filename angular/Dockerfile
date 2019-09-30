FROM node:12.10.0-buster

WORKDIR /app/

RUN npm install -g @angular/cli@8.3.5 package-merge dotenv

EXPOSE 80

RUN mkdir /docker-entrypoint.d/
COPY ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint

# ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["docker-entrypoint"]