# == Class: autossh
#
# Full description of class autossh here.
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
#  class { autossh:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
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
class autossh(
  $user,
  $tunnel_name,
  # 'forward' or 'reverse'
  $tunnel_type,
  $port,
  $hostport,
  $remote_ssh_host,
  $remote_ssh_port  = '22',
  $monitor_port     = '0',
  $enable           = true,
) {

  package{'autossh':
    ensure  =>  present,
  }

  autossh::tunnel{$tunnel_name:
    user              =>  $user,
    tunnel_type       =>  $tunnel_type,
    port              =>  $port,
    hostport          =>  $hostport,
    remote_ssh_host   =>  $remote_ssh_host,
    remote_ssh_port   =>  $remote_ssh_port,
    monitor_port      =>  $monitor_port,
    enable            =>  $enable,
  }

  Package['autossh'] -> Autossh::Tunnel[$tunnel_name]
}
