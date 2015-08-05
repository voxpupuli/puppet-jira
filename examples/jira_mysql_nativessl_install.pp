node default {

  $cert = hiera('cert')
  $key = hiera('key')

  class { '::mysql::server':
    root_password    => 'strongpassword',
  }

  mysql::db { 'jira':
    user     => 'jiraadm',
    password => 'mypassword',
    host     => 'localhost',
    grant    => ['ALL'],
  }

  file { '/etc/ssl/jira_cert.pem':
    owner   => 'jira',
    group   => 'jira',
    mode    => '0400',
    content => $cert,
    require => User['jira'],
  }

  file { '/etc/ssl/jira_key.pem':
    owner   => 'jira',
    group   => 'jira',
    mode    => '0400',
    content => $key,
    require => User['jira'],
  }

  java_ks { 'jira':
    ensure      => present,
    name        => 'jira',
    certificate => '/etc/ssl/jira_cert.pem',
    private_key => '/etc/ssl/jira_key.pem',
    target      => '/home/jira/jira.ks',
    password    => 'changeit',
    before      => Class['jira::service'],
    require     => [
      Class['jira::install'],
      File['/etc/ssl/jira_cert.pem'],
      File['/etc/ssl/jira_key.pem'],
    ],
  }

  class { '::jira':
    javahome           => '/opt/java/latest',
    db                 => 'mysql',
    dbport             => '3306',
    dbdriver           => 'com.mysql.jdbc.Driver',
    dbtype             => 'mysql',
    tomcatNativeSsl    => true,
    tomcatKeystoreFile => '/home/jira/jira.ks',
    require            => Mysql::Db['jira'],
  }

  include ::jira::facts

}
