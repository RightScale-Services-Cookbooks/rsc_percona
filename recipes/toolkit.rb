# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.




bash 'create functions' do
  code <<-EOH
mysql -u root -p#{node['mysql']['server_root_password']} -e "CREATE FUNCTION fnv1a_64 RETURNS INTEGER SONAME 'libfnv1a_udf.so'"
mysql -u root -p#{node['mysql']['server_root_password']} -e "CREATE FUNCTION fnv_64 RETURNS INTEGER SONAME 'libfnv_udf.so'"
mysql -u root -p#{node['mysql']['server_root_password']} -e "CREATE FUNCTION murmur_hash RETURNS INTEGER SONAME 'libmurmur_udf.so'"
  EOH
end

package 'percona-toolkit'
