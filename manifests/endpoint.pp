#
define autossh::endpoint(
  $enable,
  $user,
  $port,
  $host,
  $pubkey,
)
{
  concat { "/home/${user}/.ssh/authorized_keys":
    owner => $user,
    group => $user,
    mode  => '0600',
  }

  Concat::Fragment <<| target == "/home/${user}/.ssh/authorized_keys" |>>
}
