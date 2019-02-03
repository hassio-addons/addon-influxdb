#!/usr/bin/with-contenv bash
# ==============================================================================
# Community Hass.io Add-ons: InfluxDB
# Ensure a user for Chronograf & Kapacitor exists within InfluxDB
# ==============================================================================
# shellcheck disable=SC1091
source /usr/lib/hassio-addons/base.sh

declare secret

# If secret file exists, skip this script
if hass.file_exists "/data/secret"; then
    exit 0
fi

# Generate secret based on the Hass.io token
secret="${HASSIO_TOKEN:21:32}"

exec 3< <(influxd)

sleep 3

for i in {1800..0}; do
    if influx -execute "SHOW DATABASES" > /dev/null 2>&1; then
        break;
    fi
    hass.log.info "InfluxDB init process in progress..."
    sleep 5
done

if [[ "$i" = 0 ]]; then
    hass.die "InfluxDB init process failed."
fi

influx -execute \
    "CREATE USER chronograf WITH PASSWORD '${secret}'" \
         &> /dev/null || true

influx -execute \
    "SET PASSWORD FOR chronograf = '${secret}'" \
         &> /dev/null || true

influx -execute \
    "GRANT ALL PRIVILEGES TO chronograf" \
        &> /dev/null || true

influx -execute \
    "CREATE USER kapacitor WITH PASSWORD '${secret}'" \
        &> /dev/null || true

influx -execute \
    "SET PASSWORD FOR kapacitor = '${secret}'" \
        &> /dev/null || true

influx -execute \
    "GRANT ALL PRIVILEGES TO kapacitor" \
        &> /dev/null || true

kill "$(pgrep influxd)" >/dev/null 2>&1

# Save secret for future use
echo "${secret}" > /data/secret
