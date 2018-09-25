ARG BUILD_FROM=hassioaddons/ubuntu-base:2.2.0
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Setup base system
ARG BUILD_ARCH=amd64

RUN \
    apt-get update \
    && apt-get install -y --no-install-recommends \
        apache2-utils=2.4.29-1ubuntu4.1 \
        dirmngr=2.2.4-1ubuntu1.1 \
        gpg=2.2.4-1ubuntu1.1 \
        gpg-agent=2.2.4-1ubuntu1.1 \
        nginx=1.14.0-0ubuntu1.1 \
    \
    && gpg \
        --keyserver hkp://ha.pool.sks-keyservers.net:11371 \
        --recv-keys "05CE15085FC09D18E99EFB22684A14CF2582E0C5" \
    || gpg \
        --keyserver ha.pool.sks-keyservers.net \
        --recv-keys "05CE15085FC09D18E99EFB22684A14CF2582E0C5" \
    || gpg \
        --keyserver pgp.mit.edu \
        --recv-keys "05CE15085FC09D18E99EFB22684A14CF2582E0C5" \
    || gpg \
        --keyserver keyserver.pgp.com \
        --recv-keys "05CE15085FC09D18E99EFB22684A14CF2582E0C5" \
    \
    && ARCH="${BUILD_ARCH}" \
    && if [ "${BUILD_ARCH}" = "aarch64" ]; then ARCH="arm64"; fi \
    \
    && INFLUXDB="1.6.1" \
    && curl -J -L -o /tmp/influxdb.deb.asc \
        "https://dl.influxdata.com/influxdb/releases/influxdb_${INFLUXDB}_${ARCH}.deb.asc" \
    && curl -J -L -o /tmp/influxdb.deb \
        "https://dl.influxdata.com/influxdb/releases/influxdb_${INFLUXDB}_${ARCH}.deb" \
    \
    && CHRONOGRAF="1.6.1" \
    && curl -J -L -o /tmp/chronograf.deb.asc \
        "https://dl.influxdata.com/chronograf/releases/chronograf_${CHRONOGRAF}_${ARCH}.deb.asc" \
    && curl -J -L -o /tmp/chronograf.deb \
        "https://dl.influxdata.com/chronograf/releases/chronograf_${CHRONOGRAF}_${ARCH}.deb" \
    \
    && KAPACITOR="1.5.1" \
    && curl -J -L -o /tmp/kapacitor.deb.asc \
        "https://dl.influxdata.com/kapacitor/releases/kapacitor_${KAPACITOR}_${ARCH}.deb.asc" \
    && curl -J -L -o /tmp/kapacitor.deb \
        "https://dl.influxdata.com/kapacitor/releases/kapacitor_${KAPACITOR}_${ARCH}.deb" \
    \
    && gpg --batch --verify /tmp/influxdb.deb.asc /tmp/influxdb.deb \
    && gpg --batch --verify /tmp/chronograf.deb.asc /tmp/chronograf.deb \
    && gpg --batch --verify /tmp/kapacitor.deb.asc /tmp/kapacitor.deb \
    \
    && dpkg --install /tmp/influxdb.deb \
    && dpkg --install /tmp/chronograf.deb \
    && dpkg --install /tmp/kapacitor.deb \
    \
    && apt-get purge -y --auto-remove \
        dirmngr \
        gpg \
    \
    && rm -fr \
        /tmp/* \
        /root/.gnupg \
        /var/{cache,log}/* \
        /var/lib/apt/lists/*

# Copy root filesystem
COPY rootfs /

# Build arugments
ARG BUILD_DATE
ARG BUILD_REF
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="InfluxDB" \
    io.hass.description="Scalable datastore for metrics, events, and real-time analytics." \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Franck Nijhof <frenck@addons.community>" \
    org.label-schema.description="Scalable datastore for metrics, events, and real-time analytics." \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.name="InfluxDB" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.url="https://community.home-assistant.io/t/community-hass-io-add-on-influxdb/54491?u=frenck" \
    org.label-schema.usage="https://github.com/hassio-addons/addon-influxdb/tree/master/README.md" \
    org.label-schema.vcs-ref=${BUILD_REF} \
    org.label-schema.vcs-url="https://github.com/hassio-addons/addon-influxdb" \
    org.label-schema.vendor="Community Hass.io Add-ons"
