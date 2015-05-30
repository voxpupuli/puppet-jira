node default {

  class { 'nginx': } ->

  class { 'postgresql::globals':
    manage_package_repo => true,
    version             => '9.3',
  } ->

  class { 'postgresql::server': } ->

  postgresql::server::db { 'jira':
    user     => 'jiraadm',
    password => postgresql_password('jiraadm', 'mypassword'),
  } ->

  class { '::jira':
    javahome => '/opt/java/latest',
    proxy    => {
      scheme    => 'http',
      proxyName => $::fqdn,
      proxyPort => '80',
    },
  }

  include ::jira::facts

  nginx::resource::upstream { 'jira':
    ensure  => present,
    members => [ 'localhost:8080' ],
  }

  nginx::resource::vhost { 'jira_vhost':
    ensure               => present,
    server_name          => [ $::ipaddress, $::fqdn, $hostname ],
    listen_port          => '80',
    proxy                => 'http://jira',
    proxy_read_timeout   => '300',
    location_cfg_prepend => {
      'proxy_set_header X-Forwarded-Host'   => '$host',
      'proxy_set_header X-Forwarded-Server' => '$host',
      'proxy_set_header X-Forwarded-For'    => '$proxy_add_x_forwarded_for',
      'proxy_set_header Host'               => '$host',
      'proxy_redirect'                      => 'off',
    }
  }

}
