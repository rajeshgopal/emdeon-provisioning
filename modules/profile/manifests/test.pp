class { '::consul':
  config_hash => {
    'data_dir'   => '/opt/consul',
    'datacenter' => 'east-aws',
    'log_level'  => 'INFO',
    'node_name'  => 'agent',
    'retry_join' => ['172.16.0.1'],
  }
}
