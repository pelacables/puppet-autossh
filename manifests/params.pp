#
class autossh::params {
  $autossh_version  = "1.4d"
  $autossh_build    = 2
  $user		    = ""
  $tunnel_name      = ""
  # 'forward' or 'reverse'
  $tunnel_type      = ""
  $port             = ""
  $hostport         = ""
  $remote_ssh_host  = ""
  $remote_ssh_port  = '22'
  $monitor_port     = '0'
  $enable           = true

  case $::osfamily {
    /RedHat/: {

      case $::operatingsystemmajrelease {
        /6/: {
          $autossh_package = "autossh-${autossh_version}-${autossh_build}.el6.x86_64.rpm"
        } 
        default: {
	  fail("Error - Unsupported OS Version: $::operatingsystemrelease") 
        }
      } # $::operatingsystemmajrelease  
    } # RedHat

    default: { 
      fail("Unsupported Operating System: $::osfamily")
    }
  } # $::osfamily
}
