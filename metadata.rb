name             'rsc_percona'
maintainer       'RightScale, Inc.'
maintainer_email 'cookbooks@rightscale.com'
license          'Apache 2.0'
description      'Installs and configures a Percona server'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.0.2'

depends 'rs-mysql', '1.1.6'

recipe 'rsc_percona::default', 'Install Percona Server'
recipe 'rsc_percona::master', 'Install Percona Server Master Server'
recipe 'rsc_percona::slave', 'Install Percona Server Slave Server'
recipe 'rsc_percona::xtrabackup', 'Installs the Percona XtraBackup package'
recipe 'rsc_percona::toolkit', 'Installs the Percona toolkit package'



