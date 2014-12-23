name             'rsc_percona'
maintainer       'RightScale, Inc.'
maintainer_email 'cookbooks@rightscale.com'
license          'Apache 2.0'
description      'Installs and configures a Percona server'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.0.0'



recipe 'rsc_percona::default', 'Install Percona Server'
recipe 'rsc_percona::xtrabackup', 'Installs the Percona XtraBackup package'
recipe 'rsc_percona::toolkit', 'Installs the Percona toolkit package'



