# == Class: autossh::install
#
# This class initilises the runtime environment for the autossh package and should not be called directly as it is 
# called from the class initialiser.
# 
# === Parameters
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
class autossh::install {
  $user            = $autossh::user
  $autossh_package = $autossh::autossh_package

  ## If the target user account doesn't exist, create it...
  if ! defined(User[$user]) {
    user { $user:
      managehome => true,
      system     => true,
      shell      => '/bin/false',
    }
  }
        

  case $::osfamily {
    /RedHat/: {
      if(!defined(Package['redhat-lsb-core'])) {
        package{'redhat-lsb-core': ensure => installed }
      }

      if(!defined(Package['openssh-clients'])) {
        package{'openssh-clients': ensure => installed }
      }

      file { "/var/tmp/${autossh_package}":
        ensure => file,
        source => "puppet:///modules/autossh/${autossh_package}",
        owner  => root,
        group  => root,
        mode   => '0600'
      }
      package{'autossh':
        ensure   => installed,
        provider => 'rpm',
        source   => "/var/tmp/${autossh_package}",
        require  => [File["/var/tmp/${autossh_package}"],Package['redhat-lsb-core'],Package['openssh-clients']],
      }
    } #case RedHat

    /Debian/: {
      package{ $autossh_package: ensure => installed }
    } # Debian
    
    default: {
      fail("Unsupported OS Family: ${::osfamily}")
    }
  } #case
}
