class profile::galeranode {

package { 'unzip':
  ensure => installed
}
include ::profile::consulagent

Package['unzip'] -> Class['::profile::consulagent']

yumrepo { 'galera':
  name     => 'galera-server',
  ensure   => present,
  baseurl  => 'http://yum.mariadb.org/10.1/rhel6-amd64/',
  gpgkey   => 'https://yum.mariadb.org/RPM-GPG-KEY-MariaDB',
  gpgcheck => '1',
  enabled  => '1',
}
class { 'selinux':
  mode => 'permissive'
}

group {'mysql':
  ensure => present,
}
user {'mysql':
  ensure  => present,
  groups  => mysql,
  require => Group['mysql'],
}

file {'/usr/lib/mysql/':
  ensure => directory,
  owner  => root,
  group  => root,
}
file {'/usr/lib/mysql/wsrep_notify.sh':
  ensure  => present,
  owner   => mysql,
  group   => mysql,
  mode    => 0755,
  content => template('profile/wsrep_notify.sh'),
  require => [File['/usr/lib/mysql/'],User['mysql']],
}
class { '::galera':
  configure_repo      => false,
  galera_servers      => [$::fqdn],
  galera_master       => $::fqdn,
  vendor_type         => 'mariadb', # default is 'percona',
  mysql_package_name  => 'MariaDB-server',
  galera_package_name => 'galera',
  status_password     => 'mysecret',
  root_password       => 'secret',
  status_check        => 'true',
  override_options    => {
    'mysqld' => {
      'wsrep_notify_cmd' => '/usr/lib/mysql/wsrep_notify.sh',
    }
  }
}

#package {'mariadb-libs':
# ensure => absent,
# before => Class['galera']
#}

Yumrepo['galera']-> Class['selinux']->File['/usr/lib/mysql/wsrep_notify.sh']->Class['::galera']


}
