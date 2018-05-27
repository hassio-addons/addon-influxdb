#!/usr/bin/with-contenv bash
# ==============================================================================
# Community Hass.io Add-ons: InfluxDB
# Ensure a user for Chronograf & Kapacitor exists within InfluxDB
# ==============================================================================
# shellcheck disable=SC1091
source /usr/lib/hassio-addons/base.sh

exec 3< <(influxd)

sleep 3

influx -execute \
    "CREATE USER chronograf WITH PASSWORD '${HASSIO_TOKEN}'" \
        || true

influx -execute \
    "SET PASSWORD FOR chronograf = '${HASSIO_TOKEN}'" \
        || true

influx -execute \
    "GRANT ALL PRIVILEGES TO chronograf" \
        || true

influx -execute \
    "CREATE USER kapacitor WITH PASSWORD '${HASSIO_TOKEN}'" \
        || true

influx -execute \
    "SET PASSWORD FOR kapacitor = '${HASSIO_TOKEN}'" \
        || true

influx -execute \
    "GRANT ALL PRIVILEGES TO kapacitor" \
        || true

kill "$(pgrep influxd)" >/dev/null 2>&1
