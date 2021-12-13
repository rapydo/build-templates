FROM neo4j:4.3.3

ARG CURRENT_UID
RUN test -n "$CURRENT_UID"
ARG CURRENT_GID
RUN test -n "$CURRENT_GID"

RUN groupmod -og $CURRENT_GID neo4j && usermod -u $CURRENT_UID neo4j

COPY --chmod=740 ./fix_user.sh /fix_user.sh
COPY --chmod=740 ./check_ssl.sh /check_ssl.sh

# Adding my own scripts as second line of the original entrypoint
RUN sed -i '2i/fix_user.sh' /docker-entrypoint.sh
RUN sed -i '2i/check_ssl.sh' /docker-entrypoint.sh

COPY --chmod=740 reload-neo4j.sh /usr/local/bin/reload
COPY banner.sh print_versions.sh /etc/
RUN echo '/bin/bash /etc/banner.sh' >> /etc/bash.bashrc

# CVE-2021-44228 Mitigation, waiting for a neo4j version later then 4.3.3
# https://community.neo4j.com/t/log4j-cve-mitigation-for-neo4j/48856
ENV JAVA_OPTS="${JAVA_OPTS} -Dlog4j2.formatMsgNoLookups=true"
