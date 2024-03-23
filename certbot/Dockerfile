FROM certbot/certbot

RUN apk add --no-cache docker-cli
RUN docker --version

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]