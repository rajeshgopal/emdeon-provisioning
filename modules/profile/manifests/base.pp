class profile::base {

file { '/opt/python':
    ensure  => 'directory',
  }->
file { '/opt/python/check_node_key.py':
    ensure  => 'present',
    content => template('profile/checknode.erb'),
    mode    => '0644',
  }->
file { '/opt/python/shell_comm.py':
    ensure  => 'present',
    content => template('profile/shellcomm.erb'),
    mode    => '0644',
  }

}
