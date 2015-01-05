#
define autossh::tunnel(
  $user,
  # 'forward' or 'reverse'
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
    port   => $port,
    host   => $remote_ssh_host,
    pubkey => $pubkey,
  }
}
