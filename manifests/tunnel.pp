# == Class: autossh::tunnel
#
# Defines an ssh tunnel resource.  This class is run on the node that 
# 'initiates' the ssh tunnel and
#   * creates the 'autossh' configuration file
#   * creates a system 'init' script.
#   * starts/restarts the service as required.
# 
# === Parameters
#
# $user:            The user account to use to run the ssh tunnel
# $tunnel_type:     The tunnel direction. (forward --> local port to 
#                   remote port, backward = remote port --> local port)
# $port:            The local port to be used for the tunnel.
# $hostport:        The remote port to be used for the tunnel.
# $remote_ssh_host: The remote host to connect to.
# $remote_ssh_port: The remote ssh port to connect to.
# $monitor_port:    ??
# $enable:          Enable/Disable this service.
# $pubkey:          The public key to be used for this service. 
#                   (installed on remote host via exported resource)
#
# === Variables
#
#
# === Examples
#
#  autossh::tunnel  { 'testtunnel': 
#    user            => 'autossh',
#    tunnel_type     => 'backward',
#    port            => '25',
#    hostport        => '25',
#    remote_ssh_host => 'server1.foo.bar',
#    remort_ssh_port => '22',
#    monitor_port    => '0',
#    enable          => true,
#    pubkey          => 'ssh-dss IOUEOWDOQ...'
#  }
#
# === Authors
#
# Jason Ball <jason@ball.net>
# Aimon Bustardo -- forked from https://github.com/aimonb/puppet-autossh.git
#
# === Copyright
#
# Copyright 2014 Jason Ball.
#
define autossh::tunnel(
  $port,
  $hostport,
  $remote_ssh_host,
  $user             = $autossh::user,
  $tunnel_type      = $autossh::tunnel_type,
  $remote_ssh_port  = $autossh::remote_ssh_port,
  $monitor_port     = $autossh::monitor_port,
  $enable           = $autossh::enable,
  $pubkey           = $autossh::pubkey,
){
  $tun_name     = $title
  $tunnel_args  = $tunnel_type ? {
    'reverse' => "-M ${monitor_port} -f -N -R",
    'forward' => "-M ${monitor_port} -f -N -L"
  }

  file{"autossh-${tun_name}_conf":
    ensure  => 'present',
    path    => "/etc/autossh/autossh-${tun_name}.conf",
    mode    => '0660',
    owner   => $user,
    group   => $user,
    content => template('autossh/autossh.conf.erb'),
  }


  #
  # User sysV or systemd init depending on the OS
  #
  case $::osfamily {
    /RedHat/: {
      case $::operatingsystemmajrelease {
        /5|6/: {
          file{"autossh-${tun_name}-init":
            ensure  => 'present',
            path    => "/etc/init.d/autossh-${tun_name}",
            mode    => '0750',
            owner   => 'root',
            group   => 'root',
            content => template('autossh/autossh.init.sysv.erb'),
          }
        } # case rhel 5|6

        /7/: {
          file{"systemd-service-${tun_name}":
            ensure  => 'present',
            path    => "/etc/systemd/system/autossh-${tun_name}.service",
            mode    => '0750',
            owner   => 'root',
            group   => 'root',
            content => template('autossh/autossh.service.erb'),
          }
        }

        default: {
        }
      }
    } # case Redhat

    default: {
    } # default
  } # end case osfamily

  service{"autossh-${tun_name}":
    ensure  =>  $enable,
    enable  =>  $enable,
    require => Package['autossh']
  }

  ## Define remote endpoints
  @@autossh::tunnel_endpoint {"tunnel-enpoint-${remote_ssh_host}-${port}":
    user   => $user,
    port   => $hostport,
    host   => $remote_ssh_host,
    pubkey => $pubkey,
    enable => $enable,
  }
}
