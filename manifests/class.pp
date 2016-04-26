define dhcpd::class (
  $config_file = $::dhcpd::config_file,
  $parameters  = undef,
  $order       = '03',
) {
  include dhcpd::params

  concat::fragment { "class_${name}_start":
    content => template('dhcpd/dhcpd_class_header.conf.erb'),
    target  => $config_file,
    order   => $order
  }

}
