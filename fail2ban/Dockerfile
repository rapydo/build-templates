FROM crazymax/fail2ban:0.11.2

# TODO: add core jails

COPY --chmod=740 reload-fail2ban.sh /usr/local/bin/reload
COPY banner.sh print_versions.sh /etc/
RUN echo '/bin/bash /etc/banner.sh' >> /etc/bash.bashrc
