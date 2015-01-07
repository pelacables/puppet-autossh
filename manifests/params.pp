# == Class: autossh::params
#
# This class defines the default values used in the autossh class.
# 
# === Parameters
#
# === Variables
#
# $autossh_version: The install version for the autossh package
# $autossh_build: The build number for the autossh package
# $user: The user account to be used to run autossh processes.
# $enable: enable/disable package support.
# $autossh_package: The package to be installed for autossh support.
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
class autossh::params {
  $autossh_version = '1.4d'
  $autossh_build    = 4
  $user             = 'autossh'
  $enable           = true
  $pubkey           = ''
  $tunnel_type      = 'forward'
  $remote_ssh_port  = '22'
  $monitor_port     = '0'


  case $::osfamily {
    /RedHat/: {
      case $::operatingsystemmajrelease {
        /5|6/: {
          $autossh_package =
            "autossh-${autossh_version}-${autossh_build}.el6.x86_64.rpm"
          $init_template = 'autossh.init.sysv.erb'
        }
        /7/: {
          $autossh_package =
            "autossh-${autossh_version}-${autossh_build}.el7.centos.x86_64.rpm"
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
  } # $::osfamily
}
