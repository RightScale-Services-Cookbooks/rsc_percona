# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

#client setting
#node.override['mysql']['client']['packages'] =[ 'Percona-Server-client-56','Percona-Server-devel-56']
#
##server settings
#node.override['mysql']['server']['packages'] =['Percona-Server-server-56','Percona-Server-devel-56','Percona-Server-shared-56']
#node.override['mysql']['server']['service_name'] = 'mysql'
#node.override['mysql']['version'] = '5.6'

return unless node["percona"]["use_percona_repos"]

case node["platform_family"]
when "debian"
  include_recipe "apt"

  # Pin this repo as to avoid upgrade conflicts with distribution repos.
  p= apt_preference "00percona.pref" do
    glob "*"
    pin "release o=Percona Development Team"
    pin_priority "1001"
    action :nothing
  end
  p.run_action(:add)
  
  a= apt_repository "percona" do
    uri node["percona"]["apt_uri"]
    distribution node["lsb"]["codename"]
    components ["main"]
    keyserver node["percona"]["apt_keyserver"]
    key node["percona"]["apt_key"]
    action :nothing
  end
  a.run_action(:add)
  
  e = execute "apt-get update" do
    action :nothing
  end
  e.run_action(:run)
  #resources('apt_repository[percona]').run_action(:add)
when "rhel"
  include_recipe "yum"

  execute "create-yum-cache" do
    command "yum -q makecache"
    action :nothing
  end

  ruby_block "reload-internal-yum-cache" do
    block do
      Chef::Provider::Package::Yum::YumCache.instance.reload
    end
    action :nothing
  end
  y= yum_repository "percona" do
    description node["percona"]["yum"]["description"]
    baseurl node["percona"]["yum"]["baseurl"]
    gpgkey node["percona"]["yum"]["gpgkey"]
    gpgcheck node["percona"]["yum"]["gpgcheck"]
    sslverify node["percona"]["yum"]["sslverify"]
    notifies :run, "execute[create-yum-cache]", :immediately
    notifies :create, "ruby_block[reload-internal-yum-cache]", :immediately
    #notifies :install, "package[Percona-Server-client-56]", :immediately
    action :nothing
  end
  y.run_action(:create)
  #resources('yum_repository[percona]').run_action(:add)
end

#packages = node['mysql']['server']['packages'].concat(node['mysql']['client']['packages'])
#packages.each do |p|
#  package(p).run_action(:nothing)
#end
#node['mysql']['client']['packages'].each do |name|
#  resources("package[#{name}]").run_action(:install)
#end

#chef_gem 'mysql' do


#packages = node['mysql']['server']['packages'].concat(node['mysql']['client']['packages'])
#
#packages.each do |p|
#  package(p).run_action(:install)
#end
#


#if  node["platform_family"] == 'debian'
#  chef_gem "chef-rewind"
#  require 'chef/rewind'
#  include_recipe "mysql::_server_debian" 
#  #
#  rewind "template[/etc/mysql/my.cnf]"
#
#  template '/etc/mysql/my.cnf' do
#    source 'my.cnf.erb'
#    owner 'root'
#    group 'root'
#    mode '0644'
#    #notifies :install, 'package[mysql-server]', :immediately
#    notifies :run, 'execute[/usr/bin/mysql_install_db]', :immediately
#    notifies :run, 'bash[move mysql data to datadir]', :immediately
#    notifies :restart, 'service[mysql]', :immediately
#  end
#  
#  
#end 
#
#chef_gem "mysql" do
#  action :nothing
#end
##c.run_action(:install)
#resources("chef_gem[mysql]").run_action(:install)