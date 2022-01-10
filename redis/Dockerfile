FROM redis:6.2.5

ARG CURRENT_UID
RUN test -n "$CURRENT_UID"
ARG CURRENT_GID
RUN test -n "$CURRENT_GID"

COPY --chmod=740 reload-redis.sh /usr/local/bin/reload
COPY --chmod=740 ./fix_user.sh /fix_user.sh

RUN sed -i '3iif [ $(whoami) == "root" ]; then /fix_user.sh; fi' /usr/local/bin/docker-entrypoint.sh
COPY banner.sh print_versions.sh /etc/
RUN echo '/bin/bash /etc/banner.sh' >> /etc/bash.bashrc
