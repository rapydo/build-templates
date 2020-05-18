FROM neo4j:3.5.18

ARG CURRENT_UID
RUN test -n "$CURRENT_UID"
ARG CURRENT_GID
RUN test -n "$CURRENT_GID"

RUN groupmod -og $CURRENT_GID node && usermod -u $CURRENT_UID node

COPY ./fix_user.sh /fix_user.sh

RUN chmod +x /fix_user.sh

RUN echo -e '\n\n/fix_user.sh\n' >> /docker-entrypoint.sh
