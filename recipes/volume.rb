#
# Cookbook Name:: rsc_percona
# Recipe:: slave
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

include_recipe "rs-mysql::volume"

#remove auto.conf if exists in backup. causes isssues with same UUIDs
file "#{node['rs-mysql']['device']['mount_point']}/auto.conf" do
  action :delete
end
