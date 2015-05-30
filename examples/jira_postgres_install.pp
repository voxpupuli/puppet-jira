node default {

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
    javahome    => '/opt/java/latest',
  }

  include ::jira::facts

}
