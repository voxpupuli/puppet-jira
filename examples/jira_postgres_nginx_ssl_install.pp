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
      scheme    => 'https',
      proxyName => $::fqdn,
      proxyPort => '443',
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
    proxy                => 'http://jira',
    proxy_read_timeout   => '300',
    rewrite_to_https     => true,
    ssl                  => true,
    ssl_cert             => '/etc/nginx/ssl/jira-cert-chain.pem',
    ssl_key              => '/etc/nginx/ssl/jira-key.pem',
    location_cfg_prepend => {
      'proxy_set_header X-Forwarded-Host'   => '$host',
      'proxy_set_header X-Forwarded-Server' => '$host',
      'proxy_set_header X-Forwarded-For'    => '$proxy_add_x_forwarded_for',
      'proxy_set_header Host'               => '$host',
      'proxy_redirect'                      => 'off',
    }
  }

}
