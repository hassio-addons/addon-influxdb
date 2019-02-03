#!/usr/bin/with-contenv bash
# ==============================================================================
# Community Hass.io Add-ons: InfluxDB
# Configures password for Kapacitor
# ==============================================================================
# shellcheck disable=SC1091
source /usr/lib/hassio-addons/base.sh

declare secret

secret=$(</data/secret)

sed -i "s/password.*/password = \"${secret}\"/" \
    /etc/kapacitor/kapacitor.conf
