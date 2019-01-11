require 'yaml'

hosts = YAML.load_file('vagrant.yaml')

system('openssl pkcs8 -topk8 -nocrypt -in ./files/certs/filebeat.key -out ./files/certs/filebeat.pk8.key')


Vagrant.configure("2") do |config|
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.manage_guest = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = true

  hosts.each do |host|

    config.vm.define host['name'] do |node|
      node.vm.box = "bento/ubuntu-18.04"
      node.disksize.size = host['size']
      node.vm.network :forwarded_port, guest: 22, host: host['port']
      node.vm.network :private_network, ip: host['ip']
      node.vm.synced_folder ".", "/vagrant", type: "rsync"
      node.vm.hostname  = host['name']

      node.vm.provider "virtualbox" do |vb|
        vb.name = host['host_name']
        vb.memory = host['mem']
        vb.cpus = host['cpus']
      end
      node.vm.provision "ansible" do |ansible|
        ansible.playbook = "elk.yml"
      end
    end
  end
end
