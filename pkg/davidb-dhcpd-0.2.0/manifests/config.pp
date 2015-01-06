# == Class: dhcpd::config
#
# Configure dhcpd
#
# === Parameters
#
# [*config_file*]
#   specify config file to manage
#
# [*config*]
#   hash, contains global config
#
# === Examples
#
#  class { 'dhcpd::config':
#    options           => {
#      'domain-name-servers'  => [ '8.8.8.8', '8.8.4.4' ],
#      'netbios-name-servers' => [ '1.2.3.4' ],
#    },
#    include           => [
#      '/etc/dhcpd.conf.printers',
#      '/etc/dhcpd.conf.others',
#    ],
#    ddns_domainname   => 'domain.name',
#    ddns_update_style => 'interim',
#  }
#
# === Authors
#
# David Barbion <dbarbion@gmail.com>
#
class dhcpd::config(
$config_file       = '',
$options           = {},
$include           = [],
$ddns_domainname   = '',
$ddns_update_style = '',
$ddns_zones        = {},
$omapi_port        = undef,
$omapi_key         = undef,
$authoritative     = undef,
) {
  include dhcpd::params

  concat { $config_file:
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }


  file { $include:
    ensure => present,
  }

  concat::fragment { 'dhcpd_header':
    content => template('dhcpd/dhcpd_header.conf.erb'),
    target  => $config_file,
    order   => '01'
  }

  concat::fragment { 'dhcpd_global_conf':
    content => template('dhcpd/dhcpd_global.conf.erb'),
    target  => $config_file,
    order   => '05'
  }
}
