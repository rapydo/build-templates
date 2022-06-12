FROM mariadb:10.8.2

ARG CURRENT_UID
RUN test -n "$CURRENT_UID"
ARG CURRENT_GID
RUN test -n "$CURRENT_GID"

RUN groupmod -og $CURRENT_GID mysql && usermod -u $CURRENT_UID mysql

COPY --chmod=740 ./fix_user.sh /fix_user.sh

# Adding my own scripts as second line of the original entrypoint
RUN sed -i '2i/fix_user.sh' /usr/local/bin/docker-entrypoint.sh

COPY --chmod=740 reload-mariadb.sh /usr/local/bin/reload
COPY banner.sh print_versions.sh /etc/
RUN echo '/bin/bash /etc/banner.sh' >> /etc/bash.bashrc
