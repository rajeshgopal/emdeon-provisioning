class profile::consulserver {
  package { 'unzip':
    ensure => 'installed',
  }
  include ::consul
  Package['unzip'] -> Class['consul']
}
