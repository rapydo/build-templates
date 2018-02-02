FROM node:carbon

WORKDIR /opt


# RUN npm install package-merge && npm cache clean
RUN npm install package-merge

ENV NODE_PATH /opt/node_modules

WORKDIR /rapydo/

EXPOSE 8080
# CMD ["npm", "start"]

RUN mkdir /docker-entrypoint.d/
COPY ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint

# ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["docker-entrypoint"]