FROM postgres:13.2-alpine

ARG CURRENT_UID
RUN test -n "$CURRENT_UID"
ARG CURRENT_GID
RUN test -n "$CURRENT_GID"

COPY ./pgs_init.sh /docker-entrypoint-initdb.d/setup-my-schema.sh
COPY ./postgresql.conf /etc/postgresql/postgresql.conf
COPY ./version_upgrade.sh /usr/local/bin/version_upgrade
COPY ./check_datadir.sh /check_datadir.sh

# o is required because postgres does not run with CURRENT_UID
RUN chmod o+r /etc/postgresql/postgresql.conf
RUN chmod +rx /usr/local/bin/version_upgrade
RUN chmod o+rx /check_datadir.sh

# Adding my own script as second line of the original entrypoint
RUN sed -i '4ibash /check_datadir.sh' /usr/local/bin/docker-entrypoint.sh

RUN DATADIR=$(dirname "${PGDATA}") && mkdir -p "${DATADIR}"/"${PG_MAJOR}"

WORKDIR /var/lib/postgresql/

COPY banner.sh print_versions.sh /etc/
RUN echo '/bin/ash /etc/banner.sh' >> ~/.bashrc

