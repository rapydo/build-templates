FROM mongo:4.4.2

ARG CURRENT_UID
RUN test -n "$CURRENT_UID"
ARG CURRENT_GID
RUN test -n "$CURRENT_GID"

COPY ./init-mongo.sh /docker-entrypoint-initdb.d/init-mongo.sh
COPY ./fix_user.sh /fix_user.sh

# Adding my own script as third line of the original entrypoint. The script 
# is only executed when the docker entrypoint is run as root to prevent
# permission denied errors
RUN chmod +x /fix_user.sh \
    && sed -i '3iif [[ $(whoami) == "root" ]]; then /fix_user.sh; fi' /usr/local/bin/docker-entrypoint.sh

