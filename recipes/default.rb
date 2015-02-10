#
# Cookbook Name:: rsc_percona
# Recipe:: default
#
# Copyright (C) 2014 RightScale, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

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
    action :nothing
  end
  y.run_action(:create)
end


include_recipe "rs-mysql::default"