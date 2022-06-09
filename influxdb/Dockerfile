ARG BUILD_FROM=ghcr.io/hassio-addons/debian-base/amd64:6.0.0
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Setup base system
ARG BUILD_ARCH=amd64

RUN \
    apt-get update \
    && apt-get install -y --no-install-recommends \
        libnginx-mod-http-lua=1.18.0-6.1 \
        luarocks=2.4.2+dfsg-1.1 \
        nginx=1.18.0-6.1 \
        procps=2:3.3.17-5 \
    \
    && luarocks install lua-resty-http 0.15-0 \
    \
    && ARCH="${BUILD_ARCH}" \
    && if [ "${BUILD_ARCH}" = "aarch64" ]; then ARCH="arm64"; fi \
    && if [ "${BUILD_ARCH}" = "armv7" ]; then ARCH="armhf"; fi \
    \
    && INFLUXDB="1.8.10" \
    && curl -J -L -o /tmp/influxdb.deb \
        "https://dl.influxdata.com/influxdb/releases/influxdb_${INFLUXDB}_${ARCH}.deb" \
    \
    && CHRONOGRAF="1.9.4" \
    && curl -J -L -o /tmp/chronograf.deb \
        "https://dl.influxdata.com/chronograf/releases/chronograf_${CHRONOGRAF}_${ARCH}.deb" \
    \
    && KAPACITOR="1.5.9-1" \
    && curl -J -L -o /tmp/kapacitor.deb \
        "https://dl.influxdata.com/kapacitor/releases/kapacitor_${KAPACITOR}_${ARCH}.deb" \
    \
    && dpkg --install /tmp/influxdb.deb \
    && dpkg --install /tmp/chronograf.deb \
    && dpkg --install /tmp/kapacitor.deb \
    \
    && rm -fr \
        /tmp/* \
        /etc/nginx \
        /var/{cache,log}/* \
        /var/lib/apt/lists/* \
    \
    && mkdir -p /var/log/nginx \
    && touch /var/log/nginx/error.log


# Copy root filesystem
COPY rootfs /

# Build arguments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Franck Nijhof <frenck@addons.community>" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.vendor="Home Assistant Community Add-ons" \
    org.opencontainers.image.authors="Franck Nijhof <frenck@addons.community>" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://addons.community" \
    org.opencontainers.image.source="https://github.com/${BUILD_REPOSITORY}" \
    org.opencontainers.image.documentation="https://github.com/${BUILD_REPOSITORY}/blob/main/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}
