class dhcpd::service {
  include dhcpd::params
  service { $::dhcpd::params::service_name:
    ensure => running,
    enable => true,
  }
}
