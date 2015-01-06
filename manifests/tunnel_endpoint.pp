#
define autossh::tunnel_endpoint(
  $enable,
  $user,
  $port,
  $host,
  $pubkey,
)
{
  concat::fragment{"autossh_${user}_authkey_${host}_${port}":
    target  => "/home/${user}/.ssh/authorized_keys",
    content => template('autossh/endpoint.erb'),
    order   => 10,
    tag     => "authkey_fragment_${user}_${host}",
  }
}
