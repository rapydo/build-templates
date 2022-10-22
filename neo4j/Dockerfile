FROM neo4j:4.4.5

ARG CURRENT_UID
RUN test -n "$CURRENT_UID"
ARG CURRENT_GID
RUN test -n "$CURRENT_GID"

RUN groupmod -og $CURRENT_GID neo4j && usermod -u $CURRENT_UID neo4j

COPY --chmod=740 ./fix_user.sh /fix_user.sh
COPY --chmod=740 ./check_ssl.sh /check_ssl.sh

# Adding my own scripts as second line of the original entrypoint
RUN sed -i '2i/fix_user.sh' /startup/docker-entrypoint.sh
RUN sed -i '2i/check_ssl.sh' /startup/docker-entrypoint.sh

RUN mv ${NEO4J_HOME}/labs/apoc-*-core.jar ${NEO4J_HOME}/plugins

RUN apt-get update -qq \
    && apt-get dist-upgrade --yes -qq \
    && apt-get install --yes --no-install-recommends unzip \
    && apt-get autoremove --yes \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY --chmod=740 reload-neo4j.sh /usr/local/bin/reload
COPY banner.sh print_versions.sh /etc/
RUN echo '/bin/bash /etc/banner.sh' >> /etc/bash.bashrc
