class profile::galeranode {

package { 'unzip':
  ensure => installed
}
include ::profile::consulagent

Package['unzip'] -> Class['::profile::consulagent']

class { '::galera':
  galera_servers  => ['10.0.0.12'],
  galera_master   => $::fqdn,
  vendor_type     => 'mariadb', # default is 'percona',
  status_password => 'mariadb'
}


}
