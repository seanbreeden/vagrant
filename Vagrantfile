# -*- mode: ruby -*-
# vi: set ft=ruby :

  VAGRANTFILE_API_VERSION = "2"
  Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty32"
  config.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id, "--memory", "2048"]
      vb.name = "Vagrant Dev"
  end

  config.vm.network "private_network", ip: "192.168.40.74"

  # If you want to share an additional folder, (such as a project root). 
  # If you experience slow throughput or performance on the folder share, you 
  # might have to use an OS specific share. 
  # 
  # Default Share:
  # config.vm.synced_folder "../data", "/vagrant_data"
  # 
  # NFS Share, Good for Unix based OS (Mac OSX, Linux): 
  # config.vm.synced_folder "/local-folder", "/var/www/html/inside-vagrant", type: "nfs"
  #
  # SMB Share, good for Windows:
  # (If experiencing issues, upgrade PowerShell to V 3.0)
  # config.vm.synced_folder ".", "/vagrant", type: "smb"
  
  # Bootstrap script to provision box.  All installation methods can go here. 
  config.vm.provision "shell" do |s|
    s.path = "bootstrap.sh"
    # s.args   = [variable_name]  <-- Pass variables to your shell here
  end
  # If you need to forward ports, you can use this command:
  # config.vm.network "forwarded_port", guest: 80, host: 8080
end

