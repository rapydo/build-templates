FROM node:carbon

WORKDIR /data/frontend/

# RUN npm install
# RUN npm install --only=production

# COPY . .

EXPOSE 8080
# CMD ["npm", "start"]

RUN mkdir /docker-entrypoint.d/
COPY ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint

# ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["docker-entrypoint"]