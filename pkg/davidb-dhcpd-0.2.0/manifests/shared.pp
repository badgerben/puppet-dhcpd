define dhcpd::shared(
$config_file               = $::dhcpd::config_file,
$options                   = {},
$order                     = '10',
) {
  include dhcpd::params

  $_name = regsubst($title, ' ', '_', 'G')
  concat::fragment { "${_name}_0":
    content => template('dhcpd/dhcpd_shared_header.conf.erb'),
    target  => $config_file,
    order   => $order,
  }

  concat::fragment { "${_name}_4":
    content => template('dhcpd/dhcpd_shared_end.conf.erb'),
    target  => $config_file,
    order   => $order,
  }
}
