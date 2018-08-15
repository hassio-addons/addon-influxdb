#!/usr/bin/with-contenv bash
# ==============================================================================
# Community Hass.io Add-ons: InfluxDB
# This files check if all user configuration requirements are met
# ==============================================================================
# shellcheck disable=SC1091
source /usr/lib/hassio-addons/base.sh

# Require username / password
if ! hass.config.has_value 'username' \
    && ! ( \
        hass.config.exists 'leave_front_door_open' \
        && hass.config.true 'leave_front_door_open' \
    );
then
    hass.die 'You need to set a username!'
fi

if ! hass.config.has_value 'password' \
    && ! ( \
        hass.config.exists 'leave_front_door_open' \
        && hass.config.true 'leave_front_door_open' \
    );
then
    hass.die 'You need to set a password!';
fi

# Require a secure password
if hass.config.has_value 'password' \
    && ! hass.config.is_safe_password 'password'; then
    hass.die "Please choose a different password, this one is unsafe!"
fi

# Check SSL requirements, if enabled
if hass.config.true 'ssl'; then
    if ! hass.config.has_value 'certfile'; then
        hass.die 'SSL is enabled, but no certfile was specified'
    fi

    if ! hass.config.has_value 'keyfile'; then
        hass.die 'SSL is enabled, but no keyfile was specified'
    fi

    if ! hass.file_exists "/ssl/$(hass.config.get 'certfile')"; then
        hass.die 'The configured certfile is not found'
    fi

    if ! hass.file_exists "/ssl/$(hass.config.get 'keyfile')"; then
        hass.die 'The configured keyfile is not found'
    fi
fi
