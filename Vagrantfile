Vagrant.configure('2') do |config|
  config.vm.box = 'generic/ubuntu2004'
  config.vm.hostname = 'docker.local'
  config.vm.network 'private_network', ip: '192.168.56.10'
  config.vm.network 'forwarded_port', guest: 2375, host: 2375, id: 'dockerd'
  config.vm.provider 'virtualbox' do |v|
    v.gui = false
    v.memory = '2048'
    v.cpus = 2
  end
  config.vm.provision 'shell', path: 'provision.sh'
end

