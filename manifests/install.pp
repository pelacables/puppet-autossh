# == Class: autossh::install
#
# This class initilises the runtime environment for the autossh package and 
# should not be called directly as it is called from the class initialiser.
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
      shell      => '/bin/bash',
    }
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

  case $::osfamily {
    /RedHat/: {

      # redhat-lsb-core is not supporte on rhel 7...
      case $::operatingsystemmajrelease {
        /6/: {
          if(!defined(Package['redhat-lsb-core'])) {
            package{'redhat-lsb-core': ensure => installed }
          }
        } # case rhel 6
        /7/: {
          file{'autossh-tunnel.sh':
            ensure  => 'present',
            path    => '/etc/autossh/autossh-tunnel.sh',
            mode    => '0750',
            owner   => 'root',
            group   => 'root',
            content => template('autossh/autossh.init.systemd.erb'),
          }
        } # case rhel 7
        default: {
        }
      }

      # requireed on all rhel platforms
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
        require  => [File["/var/tmp/${autossh_package}"]],
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
