name             'rsc_percona'
maintainer       'RightScale, Inc.'
maintainer_email 'cookbooks@rightscale.com'
license          'Apache 2.0'
description      'Installs and configures a Percona server'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.0.3'

depends 'rs-mysql', '1.1.6'

recipe 'rsc_percona::default', 'Install Percona Server'
recipe 'rsc_percona::master', 'Install Percona Server Master Server'
recipe 'rsc_percona::slave', 'Install Percona Server Slave Server'
recipe 'rsc_percona::xtrabackup', 'Installs the Percona XtraBackup package'
recipe 'rsc_percona::toolkit', 'Installs the Percona toolkit package'

attribute 'rs-mysql/server_usage',
  :display_name => 'Server Usage',
  :description => "The Server Usage method. It is either 'dedicated' or 'shared'. In a 'dedicated' server all" +
    " server resources are dedicated to MySQL. In a 'shared' server, MySQL utilizes only half of the resources." +
    " Example: 'dedicated'",
  :default => 'dedicated',
  :required => 'optional',
  :recipes => ['rsc_percona::default', 'rsc_percona::master', 'rsc_percona::slave']

attribute 'rs-mysql/bind_network_interface',
  :display_name => 'MySQL Bind Network Interface',
  :description => "The network interface to use for MySQL bind. It can be either" +
    " 'private' or 'public' interface.",
  :default => 'private',
  :choice => ['public', 'private'],
  :required => 'optional',
  :recipes => ['rsc_percona::default', 'rsc_percona::master', 'rsc_percona::slave']

attribute 'rs-mysql/server_root_password',
  :display_name => 'MySQL Root Password',
  :description => 'The root password for MySQL server. Example: cred:MYSQL_ROOT_PASSWORD',
  :required => 'required',
  :recipes => ['rsc_percona::default', 'rsc_percona::master', 'rsc_percona::slave']

attribute 'rs-mysql/application_username',
  :display_name => 'MySQL Application Username',
  :description => 'The username of the application user. Example: cred:MYSQL_APPLICATION_USERNAME',
  :required => 'optional',
  :recipes => ['rsc_percona::default', 'rsc_percona::master', 'rsc_percona::slave']

attribute 'rs-mysql/application_password',
  :display_name => 'MySQL Application Password',
  :description => 'The password of the application user. Example: cred:MYSQL_APPLICATION_PASSWORD',
  :required => 'optional',
  :recipes => ['rsc_percona::default', 'rsc_percona::master', 'rsc_percona::slave']

attribute 'rs-mysql/application_user_privileges',
  :display_name => 'MySQL Application User Privileges',
  :description => 'The privileges given to the application user. This can be an array of mysql privilege types.' +
    ' Example: select, update, insert',
  :required => 'optional',
  :type => 'array',
  :default => [:select, :update, :insert],
  :recipes => ['rsc_percona::default', 'rsc_percona::master', 'rsc_percona::slave']

attribute 'rs-mysql/application_database_name',
  :display_name => 'MySQL Database Name',
  :description => 'The name of the application database. Example: mydb',
  :required => 'optional',
  :recipes => ['rsc_percona::default', 'rsc_percona::master', 'rsc_percona::slave']

attribute 'rs-mysql/server_repl_password',
  :display_name => 'MySQL Slave Replication Password',
  :description => 'The replication password set on the master database and used by the slave to authenticate and' +
    ' connect. If not set, rs-mysql/server_root_password will be used. Example cred:MYSQL_REPLICATION_PASSWORD',
  :required => 'optional',
  :recipes => ['rsc_percona::default', 'rsc_percona::master', 'rsc_percona::slave']

attribute 'rs-mysql/backup/lineage',
  :display_name => 'Backup Lineage',
  :description => 'The prefix that will be used to name/locate the backup of the MySQL database server.',
  :required => 'required',
  :recipes => ['rsc_percona::default', 'rsc_percona::master', 'rsc_percona::slave', 'rs-mysql::backup']

attribute 'rs-mysql/dns/master_fqdn',
  :display_name => 'MySQL Database FQDN',
  :description => 'The fully qualified domain name of the MySQL master database server.',
  :required => 'optional',
  :recipes => ['rsc_percona::master']

attribute 'rs-mysql/dns/user_key',
  :display_name => 'DNS User Key',
  :description => 'The user key to access/modify the DNS records.',
  :required => 'optional',
  :recipes => ['rsc_percona::master']

attribute 'rs-mysql/dns/secret_key',
  :display_name => 'DNS Secret Key',
  :description => 'The secret key to access/modify the DNS records.',
  :required => 'optional',
  :recipes => ['rsc_percona::master']

