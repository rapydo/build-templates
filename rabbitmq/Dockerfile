FROM rabbitmq:3.8.9-management

COPY ./enable-plugins.sh /usr/local/bin/enable-plugins.sh


# Adding my own script as third line of the original entrypoint to force execution before start

RUN chmod +x /usr/local/bin/enable-plugins.sh \
    && sed -i '3i/usr/local/bin/enable-plugins.sh' /usr/local/bin/docker-entrypoint.sh
