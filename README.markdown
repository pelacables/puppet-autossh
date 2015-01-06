autossh
==============

The autossh module facilitates the automated management of ssh based port forward between nodes.  The ssh tunnels are run via the 'autossh' wrapper 
which starts/monitors and restarts the tunnels if and when they close.   This service:

* Installs the required package support.
* Configures the 'autossh' configuration file.
* Creates a system initialsation script (init script).
* exports resources to automate the configuration of the 'remote' nodes.
* automatically configures remote nodes to provide a secure tunnel capability.

This module was initially based on the following module(s) from the puppet forge:

    aimonb/autosshdd

However this module has been rewritten to provide:

* Support for multiple tunnels on any given host.
* Support for Hiera integration
* Support for configuration of the 'tunnel endpoint'
* Secure configuration of the tunnel endpoint.

As tested this module can support any number of ssh tunnels on any given host, and automatically syncronises the tunnel endpoints providing both nodesconnect to the same puppetdb.


Example
------

** Role - Source Node **

```
#
# ssh tunnels
#
class capability::autossh {
  $autossh_user = hiera('autossh::user')

  class { '::autossh': 
    user => $autossh_user
  }

  $autossh_key = hiera('autossh::privkey')
  file { "/home/${autossh_user}/.ssh/id_dsa":
    ensure => file,
    owner => $autossh_user,
    group => $autossh_user,
    mode => "0400",
    content => $autossh_key,
    replace => no,
  }

  $tunnels = hiera_hash('autossh::tunnels')
  $defaults = hiera_hash('autossh::defaults')
  create_resources('autossh::tunnel',$tunnels,$defaults)
}

```

** Profile - Source Node **

```

autossh::tunnels:
  tunnel_pmaster:
    port: 8140
    hostport: 8140
    remote_ssh_host: 172.16.255.2
    enable: true
  tunnel_smtp:
    port: 25
    hostport: 1125
    remote_ssh_host: 172.16.255.2
    enable: true

autossh::user: 'autossh'
autossh::privkey: ENC[PKCS7, OMITTED]
autossh::defaults:
  pubkey: ssh-dss OMITTED
  tunnel_type: reverse
  user: autossh
  remote_ssh_port: 22
  monitor_port: 0

```


** Role - Destination Node **

```
class capability::autosshtarget {
  $autossh_user = hiera('autossh::user')

  class { '::autossh': 
    user => $autossh_user
  }

  $autossh_hostip = hiera('autossh::hostip')
  autossh::endpoint{'load autossh enpoint details':
    user => $autossh_user,
    host => $autossh_hostip,
  }
}
```

** Profile - Destination Node **

```

autossh::hostip: 172.16.255.2
utossh::user: 'autossh'
autossh::pubkey: 'ssh-dss OMITTED'

```