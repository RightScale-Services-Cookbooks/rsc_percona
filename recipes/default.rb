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
  apt_preference "00percona.pref" do
    glob "*"
    pin "release o=Percona Development Team"
    pin_priority "1001"
  end

  a= apt_repository "percona" do
    uri node["percona"]["apt_uri"]
    distribution node["lsb"]["codename"]
    components ["main"]
    keyserver node["percona"]["apt_keyserver"]
    key node["percona"]["apt_key"]
    action :nothing
  end
  a.run_action(:create)

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
end

#package "Percona-Server-client-56" do
#  action :nothing
#end
