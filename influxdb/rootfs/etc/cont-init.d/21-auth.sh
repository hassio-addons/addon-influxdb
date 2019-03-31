#!/usr/bin/with-contenv bashio
# ==============================================================================
# Community Hass.io Add-ons: InfluxDB
# Configures authentication
# ==============================================================================
if bashio::config.true 'auth'; then
    sed -i 's/auth-enabled=.*/auth-enabled=true/' /etc/influxdb/influxdb.conf
else
    bashio::log.warning "InfluxDB authentication protection is disabled!"
    bashio::log.warning "This is NOT recommended!!!"
fi
