#!/command/with-contenv bashio
# ==============================================================================
# Home Assistant Community Add-on: InfluxDB
# Configures Kapacitor.conf
# ==============================================================================

bashio::var.json \
    reporting "^$(bashio::config 'reporting')" \
    secret "$(</data/secret)"\
    | tempio \
        -template /etc/kapacitor/templates/kapacitor.gtpl \
        -out /etc/kapacitor/kapacitor.conf