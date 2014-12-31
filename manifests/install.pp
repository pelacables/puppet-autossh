class autossh::install {
  $autossh_package = $autossh::autossh_package

  if $::osfamily == 'RedHat' {

    if(!defined(Package["Redhat-lsb-core"])) {
      package{'redhat-lsb-core': ensure => installed }
    }

    if(!defined(Package["Openssh-clients"])) {
      package{'Openssh-clients': ensure => installed }
    }

    notice("Installing ${autossh_package}")

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
      require  => File["/var/tmp/${autossh_package}"],
    } 
  } else {
    fail("Unsupported OS Family: $::osfamily")
  }
}
