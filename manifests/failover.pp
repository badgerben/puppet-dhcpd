class dhcpd::failover (
  $peer,
  $primary,
  $peer_address,
  $address = $::fqdn,
  $port = 647,
  $peer_port = 647,
  $max_response_delay = 60,
  $max_unacked_updates = 10,
  $load_balance_max_seconds = 3,
  $mclt = 1800,
  $split = 128,
) {

  # Validate our inputs
  validate_string($peer)
  validate_bool($primary)
  validate_string($address)
  validate_integer($port)
  validate_string($peer_address)
  validate_integer($peer_port)
  validate_integer($max_response_delay)
  validate_integer($max_unacked_updates)
  validate_integer($load_balance_max_seconds)
  validate_integer($mclt)
  validate_integer($split)

  concat::fragment { 'dhcpd_failover':
    content => template('dhcpd/dhcpd_failover.conf.erb'),
    target  => $dhcpd::config_file,
    order   => '04'
  }
}
