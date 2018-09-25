#!/usr/bin/with-contenv bash
# ==============================================================================
# Community Hass.io Add-ons: InfluxDB
# Ensure a user for Chronograf & Kapacitor exists within InfluxDB
# ==============================================================================
# shellcheck disable=SC1091
source /usr/lib/hassio-addons/base.sh

exec 3< <(influxd)

sleep 3

for i in {30..0}; do
    if influx -execute "SHOW DATABASES" &> /dev/null; then
        break;
    fi
    hassio.log.info "InfluxDB init process in progress..."
    sleep 2
done

if [[ "$i" = 0 ]]; then
    hass.die "InfluxDB init process failed."
fi

influx -execute \
    "CREATE USER chronograf WITH PASSWORD '${HASSIO_TOKEN}'" \
         &> /dev/null || true

influx -execute \
    "SET PASSWORD FOR chronograf = '${HASSIO_TOKEN}'" \
         &> /dev/null || true

influx -execute \
    "GRANT ALL PRIVILEGES TO chronograf" \
        &> /dev/null || true

influx -execute \
    "CREATE USER kapacitor WITH PASSWORD '${HASSIO_TOKEN}'" \
        &> /dev/null || true

influx -execute \
    "SET PASSWORD FOR kapacitor = '${HASSIO_TOKEN}'" \
        &> /dev/null || true

influx -execute \
    "GRANT ALL PRIVILEGES TO kapacitor" \
        &> /dev/null || true

kill "$(pgrep influxd)" >/dev/null 2>&1
