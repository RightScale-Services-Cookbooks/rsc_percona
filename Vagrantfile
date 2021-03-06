# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  #config.vm.box = "opscode-ubuntu-12.04"
  config.vm.box = "opscode-ubuntu-14.04"
  #config.vm.box = "opscode-centos-6.4"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  #config.vm.box_url = "https://opscode-vm-bento.s3.amazonaws.com/vagrant/opscode_ubuntu-12.04_provisionerless.box"
  config.vm.box_url = "https://opscode-vm-bento.s3.amazonaws.com/vagrant/opscode_ubuntu-14.04_provisionerless.box"
  #config.vm.box_url ="http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_centos-6.4_chef-provisionerless.box"
  
  # Assign this VM to a host-only network IP, allowing you to access it
  # via the IP. Host-only networks can talk to the host machine as well as
  # any other machines on the same network, but cannot be accessed (through this
  # network interface) by any external networks.
  #config.vm.network :private_network, ip: "33.33.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.

  # config.vm.network :public_network

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "~/vagrant", "/vagrant", disabled: true

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider :virtualbox do |vb|
    #   # Don't boot with headless mode
    #   vb.gui = true
    #
    #   # Use VBoxManage to customize the VM. For example to change memory:
    vb.customize ["modifyvm", :id, "--memory", "1024"]
  end
  #
  # View the documentation for the provider you're using for more
  # information on available options.

  # The path to the Berksfile to use with Vagrant Berkshelf
  # config.berkshelf.berksfile_path = "./Berksfile"

  # Enabling the Berkshelf plugin. To enable this globally, add this configuration
  # option to your ~/.vagrant.d/Vagrantfile file
  config.berkshelf.enabled = true

  # An array of symbols representing groups of cookbook described in the Vagrantfile
  # to exclusively install and copy to Vagrant's shelf.
  # config.berkshelf.only = []

  #config.omnibus.chef_version = :latest
  config.omnibus.chef_version = "11.6.0"

  # An array of symbols representing groups of cookbook described in the Vagrantfile
  # to skip installing and copying to Vagrant's shelf.
  # config.berkshelf.except = []
  #config.vm.provision "shell",
  #    inline: "yum install gcc kernel-devel"
  
  config.vm.define :master do |master|
    master.vm.network :private_network, ip: '33.33.33.10'

    master.vm.hostname = 'rsc-percona'

    master.vm.provision :chef_solo do |chef|
      chef.log_level='info'
      chef.json = {
        :cloud => {
          :provider => 'vagrant',
          :private_ips => ['33.33.33.10'],
          :local_ipv4 => '33.33.33.10'
        },
        :'rs-mysql' => {
          backup: {:lineage => 'lineage',},
          :server_root_password => 'rootpass',
          :server_repl_password => 'replpass',
          :application_username => 'appuser',
          :application_password => 'apppass',
          :application_database_name => 'app_test'
        },
        :rightscale => {
          :instance_uuid => '1111111'
        }
      }

      chef.run_list = [
        "recipe[apt::default]",
        #"recipe[yum::epel]",
        "recipe[rsc_percona::default]",
        "recipe[fake::database_mysql]",
      ]
       chef.arguments = "--logfile /var/log/chef-solo.log --log_level debug"
    end
  end
  config.vm.define :slave_1 do |slave|
    slave.vm.network :private_network, ip: '33.33.33.11'

    slave.vm.hostname = 'rs-mysql-slave-1'

    slave.vm.provision :chef_solo do |chef|
      chef.log_level= "info"
      chef.json = {
        :cloud => {
          :provider => 'vagrant',
          :private_ips => ['33.33.33.11'],
          :local_ipv4 => '33.33.33.11'
        },
        :'rs-mysql' => {
          backup: {:lineage => 'lineage',},
          :server_root_password => 'rootpass',
          :server_repl_password => 'replpass',
          :application_username => 'appuser',
          :application_password => 'apppass',
          :application_database_name => 'app_test'
        },
        :rightscale => {
          :instance_uuid => '2222222'
        }
      }

      chef.run_list = [
        "recipe[apt::default]",
        #"recipe[yum::epel]",
        "recipe[rsc_percona::slave]",
      ]

      chef.arguments = "--logfile /var/log/chef-solo.log --log_level debug"
    end
  end

  config.vm.define :slave_2 do |slave|
    slave.vm.network :private_network, ip: '33.33.33.12'

    slave.vm.hostname = 'rs-mysql-slave-2'

    slave.vm.provision :chef_solo do |chef|
      chef.log_level= "info"
      chef.json = {
        :cloud => {
          :provider => 'vagrant',
          :private_ips => ['33.33.33.12'],
          :local_ipv4 => '33.33.33.12'
        },
        :'rs-mysql' => {
          :backup => {
            :lineage => 'lineage'
          },
          :server_root_password => 'rootpass',
          :server_repl_password => 'replpass',
          :application_username => 'appuser',
          :application_password => 'apppass',
          :application_database_name => 'app_test'
        },
        :rightscale => {
          :instance_uuid => '3333333'
        }
      }

      chef.run_list = [
        "recipe[apt::default]",
        #"recipe[yum::epel]",
        "recipe[rsc_percona::default]",
        "recipe[rs-mysql::slave]"
      ]

       chef.arguments = "--logfile /var/log/chef-solo.log --log_level debug"
    end
  end
end
