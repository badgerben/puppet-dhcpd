define dhcpd::class(
$config_file        = $::dhcpd::config_file,
$match_if           = undef,
$filename           = undef,
$next_server        = undef,
$order              = '03',
$max_lease_time     = undef,
$default_lease_time = undef,
) {
  include dhcpd::params

  concat::fragment { "class_${name}_start":
    content => template('dhcpd/dhcpd_class_header.conf.erb'),
    target  => $config_file,
    order   => $order
  }

}
