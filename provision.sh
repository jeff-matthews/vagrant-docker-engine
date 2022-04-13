#!/bin/sh
set -e

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh

sudo sh get-docker.sh

# Configure Docker to listen on a TCP socket

sudo mkdir /etc/systemd/system/docker.service.d

echo \
'[Service]
ExecStart=
ExecStart=/usr/bin/dockerd --containerd=/run/containerd/containerd.sock' | tee /etc/systemd/system/docker.service.d/docker.conf > /dev/null

echo \
'{
  "hosts": ["fd://", "tcp://0.0.0.0:2375"]
}' | tee /etc/docker/daemon.json > /dev/null

sudo systemctl daemon-reload

sudo systemctl restart docker.service
