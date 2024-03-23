#!/bin/sh

# Exit script on error
set -e

# Assumes CERTBOT_EMAIL and CERTBOT_DOMAINS (space-separated) are passed as environment variables
# CERTBOT_RESTART_CONTAINERS is a space-separated list of container names to restart after obtaining/renewing certificates

if [ -z "${CERTBOT_EMAIL}" ]; then
    echo "CERTBOT_EMAIL is required"
    exit 1
else
    echo "CERTBOT_EMAIL=${CERTBOT_EMAIL}"
fi

if [ -z "${CERTBOT_DOMAINS}" ]; then
    echo "CERTBOT_DOMAINS is required"
    exit 1
else
    echo "CERTBOT_DOMAINS=${CERTBOT_DOMAINS}"
fi


if [ -z "${CERTBOT_RESTART_CONTAINERS}" ]; then
    echo "CERTBOT_RESTART_CONTAINERS is not set. I will not restart any containers after obtaining/renewing certificates."
else
    echo "CERTBOT_RESTART_CONTAINERS=${CERTBOT_RESTART_CONTAINERS}"
fi

# Convert space-separated DOMAINS into Certbot-compatible arguments
DOMAIN_ARGS=""
for DOMAIN in $CERTBOT_DOMAINS; do
    DOMAIN_ARGS="$DOMAIN_ARGS -d $DOMAIN"
done

echo "Obtaining certificates for domains: $CERTBOT_DOMAINS"

# Execute the initial certbot command for obtaining certificates
# Added --non-interactive and --keep-until-expiring to handle existing certs gracefully
certbot certonly --webroot --webroot-path=/var/www/certbot --email ${CERTBOT_EMAIL} --agree-tos --no-eff-email ${DOMAIN_ARGS} --non-interactive --keep-until-expiring
for CONTAINER in ${CERTBOT_RESTART_CONTAINERS};
    do echo "Restarting $CONTAINER...";
    # true to not exit this script if the container is not running
    docker container restart $CONTAINER || true;
done

# Trap SIGTERM and SIGINT to gracefully exit
trap "exit 0" SIGTERM SIGINT

# Start a loop to periodically renew the certificates
while :; do
    echo "Sleeping for 12 hours..."
    sleep 12h
    echo "Attempting to renew certificates..."
    certbot renew --deploy-hook "for CONTAINER in ${CERTBOT_RESTART_CONTAINERS}; do echo "Restarting ${CONTAINER}..."; docker container restart ${CONTAINER}; done"
done