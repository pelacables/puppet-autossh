# == Class: autossh
#
# The autossh service configures persistent 'ssh port forwards' or 'ssh tunnels' between two nodes.  This class caters for both sides
# of the link from the 'origin' node which starts the ssh tunnel to the 'endpoint' node which terminates that tunnel.  There is a base
# assumption that both nodes connect to the same puppetdb.
#
# === Parameters
#
# $user            = The user account to be used to run the ssh sessions.
# $autossh_version = The autossh package version
# $autossh_build   = The autossh package build number
# $autossh_package = The autossh package name
# $enable          = Enable/Disable package support
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
  $enable          = $authssh::params::enable,
) inherits autossh::params {
  include ::autossh::install
}
