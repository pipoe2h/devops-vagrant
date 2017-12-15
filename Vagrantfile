# -*- mode: ruby -*-
# # vi: set ft=ruby :

# Specify minimum Vagrant version and Vagrant API version
Vagrant.require_version ">= 1.6.0"
VAGRANTFILE_API_VERSION = "2"

# Require YAML module
require 'yaml'

# Read YAML file with infrastructure details
hosts = YAML.load_file('servers.yaml')

# Create variables from YAML dictionary
net = hosts["subnet"]


# Create boxes
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    hosts["vms"].each_with_index do |servers, index|
        ip = servers["ip"] ||= "10#{index}"
        hostname = servers["name"]

        config.vm.define servers["name"] do |srv|
            srv.vm.box = servers["box"]
            srv.vm.hostname = servers["name"]
            srv.vm.network "private_network", ip: "#{net}.#{ip}"
            srv.vm.provider :virtualbox do |vb|
                vb.name = servers["name"]
                vb.cpus = servers["cpu"]
                vb.memory = servers["ram"]
                vb.linked_clone = hosts["linked_mode"]
                vb.customize ["modifyvm", :id, "--macaddress1", "auto"]
                vb.customize ["modifyvm", :id, "--vram", "7"]
            end
            
            dns_config = <<-SCRIPT
                echo "...Configuring /etc/hosts"
                sed 's/127.0.0.1.*#{hostname}*/#{net}.#{ip} #{hostname}/' -i /etc/hosts
            SCRIPT
            
            srv.vm.provision "shell", inline: <<-SHELL
                #{dns_config}
            SHELL
            
            if servers["provision"]
                servers["provision"].each do |file|
                    srv.vm.provision "shell", path: file["script"], args: file["args"]
                end
            end
        end
    end
end    