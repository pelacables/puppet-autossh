#
define autossh::tunnel_endpoint(
  $user,
  $port,
  $remote_ssh_host,
  $pubkey,
)
{
  $permit="\"localhost:${port}\""
  file_line{"autossh ${user}_authkey_${port}":
    path => "/home/${user}/.ssh/authorized_keys",
    line => "command=echo Unauthorised Access,no-agent-forwarding,no-X11-forwarding,permitopen=${permit} ${pubkey}"
  }
}
