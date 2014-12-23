# rsc_percona cookbook

Provides recipes for installing a Percona server with RightScale, including:

* installs XTRABackup, 
* installs Percona toolkit
* for use the with rs-mysql cookbook

Github Repository: [https://github.com/rightscale-services-cookbooks/rsc_percona](https://github.com/rightscale-services-cookbooks/rsc_percona)

# Requirements

* Requires Chef 11 or higher
* Requires Ruby 1.9 of higher
* Platform
  * Ubuntu 12.04
  * CentOS 6
* Cookbooks

See the `Berksfile` and `metadata.rb` for up to date dependency information.

# Usage

To setup a install Percona server only, place the `rsc_percona::default` recipe in the runlist.
To setup a install Percona xtrabackup, place the `rsc_percona::xtrabackup` recipe in the runlist.
To setup a install Percona toolkit, place the `rsc_percona::toolkit` recipe in the runlist.

