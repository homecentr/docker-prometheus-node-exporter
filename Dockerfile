FROM prom/node-exporter:v1.0.1 as exporter

FROM homecentr/base:3.2.0-alpine

ENV NODE_EXPORTER_ARGS=""

LABEL maintainer="Lukas Holota <me@lholota.com>"
LABEL org.homecentr.dependency-version=v0.18.1

RUN apk add --no-cache \
    curl=7.69.1-r0

# Copy Prometheus binaries and default configuration
COPY --from=exporter /bin/node_exporter /bin/node_exporter

# Copy S6 overlay configuration
COPY ./fs/ /

HEALTHCHECK --interval=20s --timeout=5s --start-period=5s --retries=3 CMD curl --fail http://127.0.0.1:9100 || exit 1

EXPOSE 9100