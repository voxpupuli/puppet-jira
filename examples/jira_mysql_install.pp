node default {

  class { '::mysql::server':
    root_password    => 'strongpassword',
  } ->

  mysql::db { 'jira':
    user     => 'jiraadm',
    password => 'mypassword',
    host     => 'localhost',
    grant    => ['ALL'],
  } ->

  class { '::jira':
    javahome => '/opt/java/latest',
    db       => 'mysql',
    dbport   => '3306',
    dbdriver => 'com.mysql.jdbc.Driver',
    dbtype   => 'mysql',
  }

  include ::jira::facts

}
