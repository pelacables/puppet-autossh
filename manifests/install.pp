class autossh::install {
  $autossh_package = $autossh::autossh_package

  if $::osfamily == 'RedHat' {
    file { "/var/tmp/${autossh_package}": 
      ensure => file,
      source => "puppet://modules/autossh/${autossh_package}",
      owner  => root,
      group  => root,
      mode   => '0600'
    }

    if(!defined(Package["Redhat-lsb-core"])) {
      package{'redhat-lsb-core': ensure => installed }
    }

    package{'autossh': 
      ensure   =>  latest, 
      provider => 'rpm', 
      source   => "/var/tmp/${autossh_package}",
      require  => File["/var/tmp/${autossh_package}"],
    } 
  } else {
    fail("Unsupported OS Family: $::osfamily")
  }
}
