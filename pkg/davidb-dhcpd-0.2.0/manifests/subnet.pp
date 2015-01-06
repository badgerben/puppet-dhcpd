define dhcpd::subnet(
$config_file               = $::dhcpd::config_file,
$network                   = '',
$netmask                   = '',
$options                   = {},
$order                     = '10',
$pools                     = undef,
$ranges                    = undef,
$next_server               = undef,
$filename                  = undef,
$deny_duplicates           = false,
$allow_duplicates          = false,
$deny_client_updates       = false,
$allow_client_updates      = false,
$update_conflict_detection = false,
$disable_ddns_updates      = false,
$shared_network_name       = 'global',
) {
  include dhcpd::params

  $_shared_network_name = regsubst($shared_network_name, ' ', '_', 'G')
  $_subnet_name        = regsubst($title, ' ', '_', 'G')

  # control number of spaces before the template
  if $shared_network_name == 'global' {
    $front_spaces = ''
  }else {
    $front_spaces = '  '
  }

  concat::fragment { "${_shared_network_name}_2_${_subnet_name}_subnet_1":
    content => template('dhcpd/dhcpd_subnet_header.conf.erb'),
    target  => $config_file,
    order   => $order,
  }
  if $pools {
    create_resources(dhcpd::pool, $pools, {config_file => $config_file, order => $order, subnet_name => $name, shared_network_name => $shared_network_name})
  }
  concat::fragment { "${_shared_network_name}_2_${_subnet_name}_subnet_3":
    content => template('dhcpd/dhcpd_subnet_end.conf.erb'),
    target  => $config_file,
    order   => $order,
  }

}
