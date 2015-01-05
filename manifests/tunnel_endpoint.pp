#
define autossh::tunnel_endpoint(
  $enable,
  $user,
  $port,
  $host,
  $pubkey,
)
{
  if $enable {
    $permit="\"localhost:${port}\""
#    file_line{"autossh ${user}_authkey_${port}":
#      path => "/home/${user}/.ssh/authorized_keys",
#      line => "command=echo Unauthorised Access,no-agent-forwarding,no-X11-forwarding,permitopen=${permit} ${pubkey}"
#    }

    @@concat::fragment{"authssh_${user}_authkey_${port}":
      target  => "/home/${user}/.ssh/authorized_keys",
      content => "command=echo Unauthorised Access,no-agent-forwarding,no-X11-forwarding,permitopen=${permit} ${pubkey}",
      order   => 10,
    }
  }
}
