define dhcpd::append(
$config_file           = '',
$content               = undef,
$order                 = '99',
) {
  include dhcpd::params

  concat::fragment { "append_${::name}":
    content => $content,
    target  => $config_file,
    order   => $order
  }
}
