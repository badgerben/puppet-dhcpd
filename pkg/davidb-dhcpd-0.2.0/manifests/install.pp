# == Class: dhcpd::install
#
# Install and manage dhcpd service
#
# === Authors
#
# David Barbion <dbarbion@gmail.com>
#
class dhcpd::install {
  include dhcpd::params

  package { $::dhcpd::params::package_name:
    ensure => present,
  }

}
