class profile::galeranode {

include ::profile::base

package { 'unzip':
  ensure => installed
}
include ::profile::consulagent

Class ['::profile::base'] -> Package['unzip'] -> Class['::profile::consulagent']

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

## To setup masterkey and retrieve galera IPs
$consulmaster = '10.0.0.141'
$galeraips = generate("/bin/bash","-c", "python /etc/puppet/modules/profile/files/check_node_key.py $consulmaster")

#Retrieves galera nodes IP
if $galeraips =~ /(.*\n)+(?!(.*\n))/ {
 if $1 == '' {
   $galeranodes = [$::fqdn]
   }
 else {
   $galeranodes = [$1]
   }
 }
#retrieves galera Master IP
if $galeraips =~ /(.*)/ {
$galeramaster = $1
}

class { '::galera':
  configure_repo      => false,
  galera_servers      => $galeranodes,
  galera_master       => $galeramaster,
  vendor_type         => 'mariadb', # default is 'percona',
  mysql_package_name  => 'MariaDB-server',
  galera_package_name => 'galera',
  status_password     => 'mysecret',
  root_password       => 'secret',
  status_check        => 'true',
  override_options    => {
    'mysqld' => {
      'wsrep_notify_cmd' => '/usr/lib/mysql/wsrep_notify.sh',
      'wsrep_on' => 'ON',
    }
  }
}

Class['::profile::consulagent']-> Yumrepo['galera']-> Class['selinux']->File['/usr/lib/mysql/wsrep_notify.sh']->Class['::galera']


}
