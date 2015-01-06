#davidb-dhcpd

This is the dhcpd module.

## License
Apache License, Version 2.0

## Support

Please log tickets and issues at our [Projects site](https://github.com/david-barbion/puppet-dhcpd/issues)

## Example usage

First create the global config, this will install package if not installed.
Currently, only Redhat and derivates are supported.

```
  class { 'dhcpd':
    global_config => {
      'options'         => {
        'domain-name-servers'  => [ '10.0.2.15', '10.0.2.16' ],
        'netbios-name-servers' => [ $::ipaddress_eth0 ],
        'domain-name'          => $::domain,
      },
      include           => [
        '/etc/dhcpd.conf.others',
        '/etc/named-dhcpd.key',
      ],
      ddns_domainname   => $::domain,
      ddns_update_style => 'interim',
      ddns_zones        => { "${::domain}."           => { 'primary' => '10.0.2.15', 'key' => 'DHCP_UPDATER' },
                             '23.20.10.in-addr.arpa.' => { 'primary' => '10.0.2.15', 'key' => 'DHCP_UPDATER' },
                           },
      authoritative     => true,
      omapi_port        => 9991,
      omapi_key         => 'DHCP_UPDATER',
    },
  }
```

DDNS updates are supported, but you still have to manage security key (through the inclusion of an external file)
* include statement allows you to add external managed files
* options hash configuration global dhcpd options
* omapi supported through omapi_ items

Supported DHCP items:
* class
* subnet
* pool
* ranges
* shared-network

### Example of dhcp class

```
  dhcpd::class { 'newpcboot':
    match_if    => 'substring (option vendor-class-identifier, 0, 9) = "PXEClient"',
    filename    => '/pxelinux.0',
    next_server => $::ipaddress_eth0,
  }
```

### Example of subnet with two pools

```
  dhcpd::subnet { 'First subnet':
    network     => '10.20.22.0',
    netmask     => '255.255.254.0',
    options     => {
      'routers'              => '10.20.22.254',
    },
    pools       => {
      '1st pool' => {
        allow_members_of            => ['newpcboot'],
        allow_unknown_clients       => true,
        ranges                      => ['10.20.22.8 10.20.22.9'],
        default_lease_time          => '3600',
        max_lease_time              => '3600',
      },
      '2nd pool' => {
        allow_members_of            => ['newpcboot'],
        allow_unknown_clients       => true,
        ranges                      => ['10.20.22.12 10.20.22.40'],
        default_lease_time          => '3600',
        max_lease_time              => '3600',
      },
    },
  }
```
  
### Another subnet with only range

```
  dhcpd::subnet { 'other subnet':
    ranges  => ['192.168.100.1 192.168.100.5'],
    network => '192.168.100.0',
    netmask => '255.255.255.0',
    options => {
      'domain-name-servers' => ['192.168.100.250'],
      'routers'             => ['192.168.100.254'],
      'domain-name'         => 'example.com',
    },
  }
```

### Another example with shared-network

```
  dhcpd::shared { 'workstations-and-printers': }
  
  dhcpd::subnet { 'shared subnet 1':
    ranges  => ['192.168.101.1 192.168.101.5'],
    network => '192.168.101.0',
    netmask => '255.255.255.0',
    options => {
      'domain-name-servers' => ['192.168.101.250'],
      'routers'             => ['192.168.101.254'],
      'domain-name'         => 'shared1-example.com',
    },
    shared_network_name  => 'workstations-and-printers',
  }
  dhcpd::subnet { 'shared subnet 2':
    network => '192.168.102.0',
    netmask => '255.255.255.0',
    options => {
      'domain-name-servers' => ['192.168.102.250'],
      'routers'             => ['192.168.102.254'],
      'domain-name'         => 'shared2-example.com',
    },
    pools       => {
      'shared 1st pool' => {
        allow_members_of            => ['newpcboot'],
        allow_unknown_clients       => true,
        ranges                      => ['192.168.102.5 192.168.102.5'],
        default_lease_time          => '3600',
        max_lease_time              => '3600',
      },
    },
    shared_network_name  => 'workstations-and-printers',
  }
```
  
### Declaration of local subnet

```
  dhcpd::subnet { 'local_interface':
    network     => $::network_eth0,
    netmask     => $::netmask_eth0,
  }
```


