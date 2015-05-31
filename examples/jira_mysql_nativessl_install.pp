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

  exec { 'tmpkey':
    command => "/bin/openssl req -x509 -nodes -days 365 -subj '/C=ZA/ST=Gautend/L=Johannesburg/O=puppetcommunity/CN=${fqdn}' -newkey rsa:1024 -keyout /tmp/key.pem -out /tmp/cert.pem",
    creates => '/tmp/cert.pem',
  } ->

  java_ks { 'jira':
    ensure => present,
    name        => 'jira',
    certificate => '/tmp/cert.pem',
    private_key => '/tmp/key.pem',
    target      => '/tmp/jira.ks',
    password    => 'changeit',
  } ->

  class { '::jira':
    javahome           => '/opt/java/latest',
    db                 => 'mysql',
    dbport             => '3306',
    dbdriver           => 'com.mysql.jdbc.Driver',
    dbtype             => 'mysql',
    tomcatNativeSsl    => true,
    tomcatKeystoreFile => '/tmp/jira.ks',
  } ->

  include ::jira::facts

}
