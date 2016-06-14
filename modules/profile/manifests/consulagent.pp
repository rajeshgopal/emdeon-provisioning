class profile::consulagent {
  
#include ::consul
class { '::consul':
 config_hash => {
   'data_dir'   => '/opt/consul',
   'datacenter' => 'aws-east',
   'log_level'  => 'INFO',
   'retry_join' => ["$::profile::galeranode::consulmaster"],
   'client_addr' => $::ipaddress,
 },
 version => '0.6.4',
 bin_dir => '/usr/bin',
}

}
