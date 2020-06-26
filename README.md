[![Project status](https://badgen.net/badge/project%20status/stable%20%26%20actively%20maintaned?color=green)](https://github.com/homecentr/docker-prometheus-node-exporter/graphs/commit-activity) [![](https://badgen.net/github/label-issues/homecentr/docker-prometheus-node-exporter/bug?label=open%20bugs&color=green)](https://github.com/homecentr/docker-prometheus-node-exporter/labels/bug) [![](https://badgen.net/github/release/homecentr/docker-prometheus-node-exporter)](https://hub.docker.com/repository/docker/homecentr/prometheus-node-exporter)
[![](https://badgen.net/docker/pulls/homecentr/prometheus-node-exporter)](https://hub.docker.com/repository/docker/homecentr/prometheus-node-exporter) 
[![](https://badgen.net/docker/size/homecentr/prometheus-node-exporter)](https://hub.docker.com/repository/docker/homecentr/prometheus-node-exporter)

![CI/CD on master](https://github.com/homecentr/docker-prometheus-node-exporter/workflows/CI/CD%20on%20master/badge.svg)
![Regular Docker image vulnerability scan](https://github.com/homecentr/docker-prometheus-node-exporter/workflows/Regular%20Docker%20image%20vulnerability%20scan/badge.svg)


# HomeCentr - prometheus-node-exporter

This Docker image is a repack of the original [Prometheus Node exporter](https://github.com/prometheus/node_exporter) with the usual Homecentr bells and whistles.

## Usage

```yml
version: "3.7"
services:
  exporter:
    build: .
    image: homecentr/prometheus-node-exporter
    restart: unless-stopped
    environment:
      NODE_ID: "myserver"
      NODE_EXPORTER_ARGS: "--path.sysfs=/host/sys --path.procfs=/host/proc --collector.textfile.directory=/etc/node-exporter/ --collector.filesystem.ignored-mount-points=^/(sys|proc|dev|host|etc)($$|/) --no-collector.ipvs"
    ports:
      - 9100:9100
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /:/rootfs:ro
      - /etc/hostname:/etc/nodename
```

## Environment variables

| Name | Default value | Description |
|------|---------------|-------------|
| PUID | 7077 | UID of the user prometheus-node-exporter should be running as. |
| PGID | 7077 | GID of the user prometheus-node-exporter should be running as. |
| NODE_ID | | Name of the node which should be used as metrics label |
| NODE_EXPORTER_ARGS | | Additional command line arguments passed to the Node exporter executable. Please check the documentation in the [original project](https://github.com/prometheus/node_exporter). |

## Exposed ports

| Port | Protocol | Description |
|------|------|-------------|
| 9100 | TCP | Metrics served over HTTP by the Node exporter |

## Volumes

This container does not expose any explicit volumes, but for correct function, you need to mount the host's `/proc`, `/sys/` and `/` so the exporter can evaluate the host's state a report it in the metrics. These directories can be mounted pretty much anywhere, you just need to specify the same path in the NODE_EXPORTER_ARGS variable as shown in the example above.

## Security
The container is regularly scanned for vulnerabilities and updated. Further info can be found in the [Security tab](https://github.com/homecentr/docker-prometheus-node-exporter/security).

### Container user
The container supports privilege drop. Even though the container starts as root, it will use the permissions only to perform the initial set up. The prometheus-node-exporter process runs as UID/GID provided in the PUID and PGID environment variables.

:warning: Do not change the container user directly using the `user` Docker compose property or using the `--user` argument. This would break the privilege drop logic.