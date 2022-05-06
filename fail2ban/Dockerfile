FROM crazymax/fail2ban:0.11.2

RUN apk --no-cache update && apk upgrade

COPY --chmod=740 reload-fail2ban.sh /usr/local/bin/reload
COPY banner.sh print_versions.sh /etc/
RUN echo '/bin/ash /etc/banner.sh' >> ~/.bashrc

RUN sed -i '3ised -i "s|#ignoreip =.*|ignoreip = 127.0.0.1/24 ${DOCKER_SUBNET}|g" /etc/fail2ban/jail.conf' /entrypoint.sh
