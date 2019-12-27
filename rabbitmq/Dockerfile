FROM rabbitmq:3.8.2

COPY ./enable-plugins.sh /usr/local/bin/enable-plugins.sh

RUN chmod +x /usr/local/bin/enable-plugins.sh

# Adding my own script as third line of the original entrypoint to force execution before start

RUN sed -i '3i/usr/local/bin/enable-plugins.sh' /usr/local/bin/docker-entrypoint.sh

RUN apt-get update && apt-get install --yes python3 \
    && apt-get autoremove --yes && apt-get clean \
    && ln -sf /usr/bin/python3 /usr/bin/python

ADD https://raw.githubusercontent.com/rabbitmq/rabbitmq-management/v$RABBITMQ_VERSION/bin/rabbitmqadmin /usr/local/bin/rabbitmqadmin

RUN chmod +x /usr/local/bin/rabbitmqadmin
