class autossh::install {
  $autossh_package = $autossh::autossh_package

  if $::osfamily == 'RedHat' {

    if(!defined(Package["redhat-lsb-core"])) {
      package{'redhat-lsb-core': ensure => installed }
    }

    if(!defined(Package["openssh-clients"])) {
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
      require  => File["/var/tmp/${autossh_package}"],
    } 
  } else {
    fail("Unsupported OS Family: $::osfamily")
  }
}
