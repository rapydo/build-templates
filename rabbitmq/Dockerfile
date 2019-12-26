FROM rabbitmq:3.8.2 

COPY ./enable-plugins.sh /usr/local/bin/enable-plugins.sh

RUN chmod +x /usr/local/bin/enable-plugins.sh

# Adding my own script as third line of the original entrypoint to force execution before start

RUN sed -i '3i/usr/local/bin/enable-plugins.sh' /usr/local/bin/docker-entrypoint.sh
