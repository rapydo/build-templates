FROM postgres:12.3-alpine 

ARG CURRENT_UID
RUN test -n "$CURRENT_UID"
ARG CURRENT_GID
RUN test -n "$CURRENT_GID"

COPY ./pgs_init.sh /docker-entrypoint-initdb.d/setup-my-schema.sh
COPY ./postgresql.conf /etc/postgresql/postgresql.conf

