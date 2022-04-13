#!/bin/sh
set -e

# Install VirtualBox
brew install --cask virtualbox

# Install Vagrant and the vbguest plugin to manage VirtualBox Guest Additions on the VM
brew install vagrant

vagrant plugin install vagrant-vbguest

# Install Docker CLI
brew install docker

brew install docker-compose

# Create a Vagrantfile and a provisioning script
# mkdir vagrant-docker-engine

echo \
"Vagrant.configure('2') do |config|
  config.vm.box = 'generic/ubuntu2004'
  config.vm.hostname = 'docker.local'
  config.vm.network 'private_network', ip: '192.168.56.10'
  config.vm.network 'forwarded_port', guest: 80, host: 8080, id: 'dockerd'
  config.vm.provider 'virtualbox' do |v|
    v.gui = false
    v.memory = '2048'
    v.cpus = 2
  end
  config.vm.provision 'shell', path: 'provision.sh'
end
" | tee Vagrantfile > /dev/null

echo \
"#!/bin/sh
set -e

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh

sudo sh get-docker.sh

# Configure Docker to listen on a TCP socket

sudo mkdir /etc/systemd/system/docker.service.d

echo \\
'[Service]
ExecStart=
ExecStart=/usr/bin/dockerd --containerd=/run/containerd/containerd.sock' | tee /etc/systemd/system/docker.service.d/docker.conf > /dev/null

echo \\
'{
  \"hosts\": [\"fd://\", \"tcp://0.0.0.0:80\"]
}' | tee /etc/docker/daemon.json > /dev/null

sudo systemctl daemon-reload

sudo systemctl restart docker.service" >> provision.sh

sudo chmod +x provision.sh

# Spin up the machine
vagrant up
