#!/usr/bin/with-contenv bashio
# ==============================================================================
# Community Hass.io Add-ons: InfluxDB
# Configures password for Kapacitor
# ==============================================================================
declare secret

secret=$(</data/secret)

sed -i "s/password.*/password = \"${secret}\"/" \
    /etc/kapacitor/kapacitor.conf
