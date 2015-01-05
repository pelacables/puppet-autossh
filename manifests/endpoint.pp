#
define autossh::endpoint(
  $user,
)
{
  concat { "/home/${user}/.ssh/authorized_keys":
    owner => $user,
    group => $user,
    mode  => '0600',
  }

  Autossh::Tunnel_endpoint <<| |>>

}
