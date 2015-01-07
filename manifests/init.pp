# == Class: autossh
#
# The autossh service configures persistent 'ssh port forwards' or 'ssh tunnels'
# between two nodes.  This class caters for both sides of the link from the 
# 'origin' node which starts the ssh tunnel to the 'endpoint' node which 
# terminates that tunnel.  There is a base assumption that both nodes connect 
# to the same puppetdb.
#
# === Parameters
#
# $user            = The user account to be used to run the ssh sessions.
# $autossh_version = The autossh package version
# $autossh_build   = The autossh package build number
# $autossh_package = The autossh package name
# $init_template   = Template to use for the init script
# $enable          = Enable/Disable package support
# $pubkey          = Public key to use for tunnels.  If supplied at this level 
#                    is used as the default for all tunnels.
# $enable          = enable/disable the tunnel
# $tunnel_type     = forward/backward tunnel.  
# $remote_ssh_port = remote port to connect to (ssh port)
# $monitor_port    = autossh monitor port.
#
# === Variables
#
# === Examples
#
#  class { autossh:
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
class autossh(
  $user            = $autossh::params::user,
  $autossh_version = $autossh::params::autossh_version,
  $autossh_build   = $autossh::params::autossh_build,
  $autossh_package = $autossh::params::autossh_package,
  $init_template   = $autossh::params::init_template,
  $pubkey          = $autossh::params::pubkey,
  $enable          = $autossh::params::enable,
  $tunnel_type     = $autossh::params::tunnel_type,
  $remote_ssh_port = $autossh::params::remote_ssh_port,
  $monitor_port    = $autossh::params::montior_port,
) inherits autossh::params {
  include ::autossh::install
}
