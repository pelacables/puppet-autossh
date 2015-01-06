# == Class: autossh::tunnel
#
# Defines an ssh tunnel resource.  This class is run on the node that 'initiates' the ssh tunnel and
#   * creates the 'autossh' configuration file
#   * creates a system 'init' script.
#   * starts/restarts the service as required.
# 
# === Parameters
#
# $user:            The user account to use to run the ssh tunnel
# $tunnel_type:     The tunnel direction. (forward --> local port to remote port, backward = remote port --> local port)
# $port:            The local port to be used for the tunnel.
# $hostport:        The remote port to be used for the tunnel.
# $remote_ssh_host: The remote host to connect to.
# $remote_ssh_port: The remote ssh port to connect to.
# $monitor_port:    ??
# $enable:          Enable/Disable this service.
# $pubkey:          The public key to be used for this service. (installed on remote host via exported resource)
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
#
# === Copyright
#
# Copyright 2014 Jason Ball.
#
define autossh::tunnel(
  $user,
  $tunnel_type,
  $port,
  $hostport,
  $remote_ssh_host,
  $remote_ssh_port  = '22',
  $monitor_port     = '0',
  $enable           = true,
  $pubkey           = '',
){

  if(!defined(Class['Autossh'])) {
    include autossh
  }

  $tun_name     = $title
  $tunnel_args  = $tunnel_type ? {
    'reverse' => "-M ${monitor_port} -f -N -R",
    'forward' => "-M ${monitor_port} -f -N -L"
  }


  if !defined(File['auto_ssh_conf_dir']) {
    file{'auto_ssh_conf_dir':
      ensure => directory,
      path   => '/etc/autossh',
      mode   => '0755',
      owner  => 'root',
      group  => 'root',
    }
  }
  file{"autossh-${tun_name}_conf":
    ensure  => 'present',
    path    => "/etc/autossh/autossh-${tun_name}.conf",
    mode    => '0660',
    owner   => $user,
    group   => $user,
    content => template('autossh/autossh.conf.erb'),
  }
  file{"autossh-${tun_name}-init":
    ensure  => 'present',
    path    => "/etc/init.d/autossh-${tun_name}",
    mode    => '0750',
    owner   => 'root',
    group   => 'root',
    content => template('autossh/autossh.init.erb'),
  }
  service{"autossh-${tun_name}":
    ensure  =>  $enable,
    enable  =>  $enable,
    require => Package['autossh']
  }

  File['auto_ssh_conf_dir'] -> File["autossh-${tun_name}_conf"]
  File["autossh-${tun_name}_conf"] -> Service["autossh-${tun_name}"]
  File["autossh-${tun_name}_conf"] ~> Service["autossh-${tun_name}"]

  ## Define remote endpoints
  @@autossh::tunnel_endpoint {"tunnel-enpoint-${remote_ssh_host}-${port}":
    user   => $user,
    port   => $hostport,
    host   => $remote_ssh_host,
    pubkey => $pubkey,
    enable => $enable,
  }
}
