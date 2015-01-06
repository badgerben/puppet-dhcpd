define dhcpd::pool(
$config_file                   = $::dhcpd::config_file,
$allow_members_of              = [],
$deny_members_of               = [],
$allow_known_clients           = false,
$deny_known_clients            = false,
$allow_unknown_clients         = false,
$deny_unknown_clients          = false,
$allow_dynamic_bootp_clients   = false,
$deny_dynamic_bootp_clients    = false,
$allow_all_clients             = false,
$deny_all_clients              = false,
$default_lease_time            = '',
$max_lease_time                = '',
$ranges                        = [],
$order                         = '10',
$subnet_name                   = undef,
$shared_network_name           = 'global',
) {
  include dhcpd::params

  validate_string($subnet_name)
  validate_string($shared_network_name)

  $_poolname = regsubst($title, ' ', '_', 'G')
  $_subnet_name = regsubst($subnet_name, ' ', '_', 'G')
  $_shared_network_name = regsubst($shared_network_name, ' ', '_', 'G')

  # control number of spaces before the template
  if $shared_network_name == 'global' {
    $front_spaces = ''
  }else {
    $front_spaces = '  '
  }

  concat::fragment { "${_shared_network_name}_2_${_subnet_name}_subnet_2_${_poolname}":
    content => template('dhcpd/dhcpd_subnet_pool.conf.erb'),
    target  => $config_file,
    order   => $order
  }
}
