#!/usr/bin/with-contenv bash
# ==============================================================================
# Community Hass.io Add-ons: InfluxDB
# Configures SSL for InfluxDB
# ==============================================================================
# shellcheck disable=SC1091
source /usr/lib/hassio-addons/base.sh

declare certfile
declare keyfile

if hass.config.true 'ssl'; then
    certfile=$(hass.config.get 'certfile')
    keyfile=$(hass.config.get 'keyfile')

    sed -i 's/https-enabled=.*/https-enabled=true/' /etc/influxdb/influxdb.conf
    sed -i "s#https-certificate=.*#https-certificate=\"/ssl/${certfile}\"#" \
        /etc/influxdb/influxdb.conf
    sed -i "s#https-private-key=.*#https-private-key=\"/ssl/${keyfile}\"#" \
        /etc/influxdb/influxdb.conf
fi
