FROM prom/alertmanager:latest

USER root
RUN apk add --no-cache gettext

COPY config.template.yml /tmp/config.template.yml
RUN envsubst < /tmp/config.template.yml > /etc/alertmanager/config.yml
RUN chown nobody:nogroup /etc/alertmanager/config.yml

USER nobody
