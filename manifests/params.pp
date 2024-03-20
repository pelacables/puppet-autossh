# == Class: autossh::params
#
# This class defines the default values used in the autossh class.
#
# === Parameters
#
# The parameters are defined in init.pp
#
# === Authors
#
# Jason Ball <jason@ball.net>
# Gerard Castillo <gerardcl@gmail.com> -- forked from https://github.com/agronaught/puppet-autossh
#
# === Copyright
#
# Copyright 2014 Jason Ball.

class autossh::params {
  $autossh_version                   = '1.4e'
  $autossh_build                     = 1
  $user                              = 'autossh'
  $enable                            = true
  $pubkey                            = ''
  $tunnel_type                       = 'forward'
  $remote_ssh_user                   = 'autossh'
  $remote_ssh_port                   = '22'
  $bind                              = 'localhost'
  $forward_host                      = 'localhost'
  $monitor_port                      = '0'
  $ssh_reuse_established_connections = false
  $ssh_enable_compression            = false
  $ssh_ciphers                       = 'aes128-cbc,3des-cbc,aes192-cbc,aes256-cbc,aes128-ctr,aes192-ctr,aes256-ctr'
  $ssh_stricthostkeychecking         = false
  $ssh_tcpkeepalives                 = true
  $server_alive_interval             = '30'
  $server_alive_count_max            = '3'

  case $::osfamily {
    /RedHat/: {
      case $::operatingsystemmajrelease {
        /5|6/: {
          $autossh_package = 'autossh'
          $init_template = 'autossh.init.sysv.erb'
        }
        /7/: {
          $autossh_package = 'autossh'
          $init_template = 'autossh.init.systemd.erb'
        }
        /9/: {
          $autossh_package = 'autossh'
          $init_template = 'autossh.init.systemd.erb'
        }
        default: {
          fail("Error - Unsupported OS Version: ${::operatingsystemrelease}")
        }
      } # $::operatingsystemmajrelease
    } # RedHat

    /Debian/: {
          $autossh_package = 'autossh'
          $init_template = 'autossh.init.systemd.erb'
    }

    default: {
      fail("Unsupported Operating System: ${::osfamily}")
    }
  } 
}
