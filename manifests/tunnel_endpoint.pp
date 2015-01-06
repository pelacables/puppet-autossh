#
define autossh::tunnel_endpoint(
  $enable,
  $user,
  $port,
  $host,
  $pubkey,
  $name,
)
{
  $permit="\"localhost:${port}\""
#    file_line{"autossh ${user}_authkey_${port}":
#      path => "/home/${user}/.ssh/authorized_keys",
#      line => "command=echo Unauthorised Access,no-agent-forwarding,no-X11-forwarding,permitopen=${permit} ${pubkey}"
#    }

  concat::fragment{"autossh_${user}_authkey_${host}_${port}":
    target  => "/home/${user}/.ssh/authorized_keys",
    content => template('autossh/endpoint.erb'),
    order   => 10,
    tag     => "authkey_fragment_${user}_${host}",
  }

  @@haproxy::balancermember { "${name}_${port}":
    listening_service => '$name',
    server_names      => 'localhost',
    ipaddresses       => '127.0.0.1',
    ports             => '7501',
    options           => 'check'
  }
}
