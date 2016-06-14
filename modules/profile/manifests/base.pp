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

## To setup masterkey and retrieve galera IPs
$consulmaster = '10.0.0.15'
$galeraips = generate("/bin/bash","-c", "python /opt/python/check_node_key.py $consulmaster")

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

}
