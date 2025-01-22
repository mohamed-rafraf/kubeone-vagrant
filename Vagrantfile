# -*- mode: ruby -*-
# vi: set ft=ruby :

open("settings.sh", "r").readlines.each {
  |l|
  kv = l.split("=")
  if kv[1] != nil
    ENV[kv[0]] = kv[1].strip
  end
}

LIBVIRT_HOST_IP = ENV["LIBVIRT_HOST_IP"] || "192.168.56.1"
CONTROLE_PLANE_IP = ENV["CONTROLE_PLANE_IP"] || "192.168.56.4"
BASE_IP = ENV["BASE_IP"] || "192.168.56.43"
BASE_MAC = (ENV["BASE_MAC"] || "08:00:27:9E:F5:3A").downcase
DEST_DIR_BASE = "/sandbox/stack/"
NETWORK_NAME="k1-playground"
WORKERS_NUMBER=ENV["WORKERS_NUMBER"] || "1"
SSH_PUBLIC_KEY=(ENV["PUBLIC_SSH_KEY"] || "#{Dir.home}/.ssh/id_rsa.pub").strip.tr('"', '')

def increment_ip(base_ip, increment)
  ip_parts = base_ip.split('.').map(&:to_i)
  ip_parts[-1] += increment
  ip_parts.join('.')
end

Vagrant.configure("2") do |config|
  config.vm.provider :libvirt do |libvirt|
    libvirt.qemu_use_session = false
  end

  config.vm.boot_timeout = 3600

  config.vm.define "stack" do |stack|
    stack.vm.box = "jammy-cloud"
    stack.vm.hostname = "controle-plane-1"
    stack.vm.network "private_network", ip: CONTROLE_PLANE_IP, netmask: "255.255.255.0",
                                        libvirt__network_name: NETWORK_NAME,
                                        libvirt__host_ip: LIBVIRT_HOST_IP,
                                        libvirt__netmask: "255.255.255.0",
                                        libvirt__dhcp_enabled: false

    stack.vm.provider "libvirt" do |l, override|
      l.storage :file, :size => "40G"
      l.memory = 2048
      l.cpus = 2
    end
    stack.vm.provider "virtualbox" do |l, override|
      l.name  = "control-plane"
      l.memory = 2048
      l.cpus = 2
    end
    stack.vm.provision :shell, :inline => "ulimit -n 4048"
    ssh_pub_key = File.readlines(SSH_PUBLIC_KEY).first.strip
    stack.vm.provision "shell", inline: <<-SHELL
      echo #{ssh_pub_key} >> /root/.ssh/authorized_keys
    SHELL

  end

  # Loop to define VMs
  (1..WORKERS_NUMBER.to_i).each do |i|
    config.vm.define "worker-#{i}" do |machine|
      ssh_pub_key = File.readlines(SSH_PUBLIC_KEY).first.strip
      machine.vm.provision "shell", inline: <<-SHELL
        echo #{ssh_pub_key} >> /root/.ssh/authorized_keys
      SHELL
      ip = increment_ip(BASE_IP, i-1)
      machine.vm.box = "jammy-cloud"
      machine.vm.hostname = "worker-#{i}"
      machine.vm.boot_timeout = 300

      machine.vm.network "private_network" , ip: ip , netmask: "255.255.255.0",
                                            libvirt__network_name: NETWORK_NAME,
                                            libvirt__host_ip: LIBVIRT_HOST_IP,
                                            libvirt__netmask: "255.255.255.0",
                                            libvirt__dhcp_enabled: false

      machine.vm.provider "libvirt" do |v|
        v.storage :file, :size => "20G"
        v.memory = 2048
        v.cpus = 2
        v.machine_arch = "x86_64"
      end

      machine.vm.provider "virtualbox" do |l, override|
        l.name = "worker-#{i}"
        l.memory = 2048
        l.cpus = 2
      end
    end
    
  end

end
