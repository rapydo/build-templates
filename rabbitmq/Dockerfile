FROM rabbitmq:3.9.12-management

COPY --chown=rabbitmq --chmod=740 ./dump_conf_file.sh /usr/local/bin/dump_conf_file.sh
COPY --chown=rabbitmq --chmod=740 ./enable-plugins.sh /usr/local/bin/enable-plugins.sh
COPY --chown=rabbitmq --chmod=740  ./check_ssl.sh /usr/local/bin/check_ssl.sh
COPY --chown=rabbitmq --chmod=740  ./reload_certificate.sh /usr/local/bin/reload_certificate

# Adding my own scripts as third line of the original entrypoint to force execution before start

RUN sed -i '3i/usr/local/bin/dump_conf_file.sh' /usr/local/bin/docker-entrypoint.sh && \
    sed -i '3i/usr/local/bin/enable-plugins.sh' /usr/local/bin/docker-entrypoint.sh && \
    sed -i '3i/usr/local/bin/check_ssl.sh' /usr/local/bin/docker-entrypoint.sh && \
    touch /etc/rabbitmq/rabbitmq.conf && \
    chown rabbitmq /etc/rabbitmq/rabbitmq.conf

COPY --chmod=740 reload-rabbitmq.sh /usr/local/bin/reload
COPY banner.sh print_versions.sh /etc/
RUN echo "/bin/bash /etc/banner.sh" >> /etc/bash.bashrc

# TODO: should be moved in dump_conf_file.sh, probably env-based

RUN echo "consumer_timeout = 31622400000" >> /etc/rabbitmq/rabbitmq.conf
