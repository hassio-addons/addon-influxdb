#!/usr/bin/with-contenv bash
# ==============================================================================
# Community Hass.io Add-ons: InfluxDB
# Configures password for Kapacitor
# ==============================================================================
# shellcheck disable=SC1091
source /usr/lib/hassio-addons/base.sh

sed -i "s/password.*/password = \"${HASSIO_TOKEN}\"/" \
    /etc/kapacitor/kapacitor.conf
