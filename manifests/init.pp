# == Class: dhcpd
#
# Full description of class dhcpd here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { dhcpd:
#    config => {
#                'options' => {
#                  'domain-name-servers'  => [ '8.8.8.8', '8.8.4.4' ],
#                  'netbios-name-servers' => [ '1.2.3.4' ],
#                },
#                'include' => [
#                  '/etc/dhcpd.conf.printers',
#                  '/etc/dhcpd.conf.others',
#                ],
#                'ddns-domainname'   => 'domain.name',
#                'ddns-update-style' => 'interim',
#    }
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2014 Your name here, unless otherwise noted.
#
class dhcpd(
$config_file         = $::dhcpd::params::config_file,
$global_config       = {},
) inherits dhcpd::params {

  class { 'dhcpd::install': }->
  class { 'dhcpd::service': }


  notice("config_file = ${config_file}")

  $config_params = { 'dhcpd::config' => merge($global_config, {config_file => $config_file}) }
  create_resources( 'class', $config_params)

  Class['dhcpd::config'] ~> Class['dhcpd::service']
}
