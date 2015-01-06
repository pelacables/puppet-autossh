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
  $autossh_build    = 3
  $user             = ''
  $enable           = true

  case $::osfamily {
    /RedHat/: {

      case $::operatingsystemmajrelease {
        /6/: {
          $autossh_package = "autossh-${autossh_version}-${autossh_build}.el6.x86_64.rpm"
        }
        default: {
          fail("Error - Unsupported OS Version: ${::operatingsystemrelease}")
        }
      } # $::operatingsystemmajrelease  
    } # RedHat

    default: {
      fail("Unsupported Operating System: ${::osfamily}")
    }
  } # $::osfamily
}
