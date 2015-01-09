##autossh

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

As tested this module can support any number of ssh tunnels on any given host, and automatically syncronises the tunnel endpoints providing both nodes connect to the same puppetdb.

The 'autossh' service provides a reliability and monitoring capability for the ssh tunnels, this includes monitoring the link via a separate 'monitoring ports' if configured and automatically restarting the ssh session if it fails due to an abnormal termination or error detected on the monitoring port.   I'm gradually adding more functionality here to support customisation of the ssh parameters to watch this space as the module develops.

Management of the private key is left to you as care needs to be taken to ensure this private key is adequately protected.  I've encrypted the private key using eyaml and find this a convenient approach but that does depend on having hiera configured correctly.


##Classes

autossh
----

The 'autossh' class configures the autossh environment, installs the required package support, and configures the global ssh options to be applied to ssh sessions.

```
Class {'::autossh': 
}
```

parameters
----
#####`user`

The linux user account to be used to run the ssh sessions.  Ideally this should be a service account, defaults to `autossh`

#####`autossh_version`

The version of autossh to install.  Only applies when the packaged autossh rpm is installed on systems lacking autossh support.

#####`autossh_build`

  $autossh_package = $autossh::params::autossh_package,
  $init_template   = $autossh::params::init_template,
  $enable          = $autossh::params::enable,
  $ssh_reuse_established_connections =
    $autossh::params::ssh_reuse_established_connections,
  $ssh_enable_compression = $autossh::params::ssh_enable_compression,
  $ssh_ciphers = $autossh::params::ssh_ciphers,
  $ssh_stricthostkeychecking = $autossh::params::ssh_stricthostkeychecking,
  $ssh_tcpkeepalives = $autossh::params::ssh_tcpkeepalives,



##Examples 

Simple Example
------

The simple example creates a single ssh tunnel between two nodes, starting at the origin and terminating at the 'destination' using DSL only:

**Prepare Private/Public Keys**

Generate the necessary private and public keys for the ssh sessions.   The private key will need to be placed in the '.ssh' folder
for the run user (default: /home/autossh/.ssh/) and the public key used when configuring the service.

**Origin Node**

```
  class { '::autossh':
  }

  autossh::tunnel { 'port_25_tunnel_to_server1': 
    port             => '25',
    hostport         => '25',
    remote_ssh_host  => 'server1',
    pubkey           => 'ssh-dss <OMITTED>'
  } 
```

**Destination Node**

```
  class { '::autossh':
  }

  autossh::endpoint { 'load ssh endpoints': 
    host   => 'server1',
  }
```
     



Complex Example
------

The following example creates multiple ssh port forwards between two nodes, the Origin and Destination using DSL and Hiera.  This example also includes the installation of the private key which is stored using hiera-eyaml and default values to reduce the specific instance configuration.

**Role - Origin Node**

```
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

**Profile - Origin Node**

```

autossh::tunnels:
  tunnel_pmaster:
    port: 8140
    hostport: 8140
    remote_ssh_host: 172.16.255.2
  tunnel_smtp:
    port: 25
    hostport: 1125
    remote_ssh_host: 172.16.255.2

autossh::user: 'autossh'
autossh::privkey: ENC[PKCS7, OMITTED]
autossh::defaults:
  pubkey: ssh-dss OMITTED
  tunnel_type: reverse
  user: autossh
  remote_ssh_port: 22
  monitor_port: 0
  enable: true

```


**Role - Destination Node**

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
```

**Profile - Destination Node**

```

autossh::hostip: 172.16.255.2
autossh::user: 'autossh'
autossh::pubkey: 'ssh-dss OMITTED'

```
