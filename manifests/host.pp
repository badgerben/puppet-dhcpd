define dhcpd::host (
  $config_file     = $::dhcpd::config_file,
  $mac_address     = undef,
  $ip_address      = undef,
  $ddns_updates    = false,
  $ddns_hostname   = $name,
  $ddns_domainname = undef,
  $order           = '07',
) {

  include dhcpd::params

  concat::fragment { "host_${name}_start":
    content => template('dhcpd/dhcpd_host_header.conf.erb'),
    target  => $config_file,
    order   => $order
  }

}
