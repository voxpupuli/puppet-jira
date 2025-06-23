# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'jira mysql' do
  it 'installs with defaults' do
    pp = <<-EOS
      # On ubuntu 20.04 and 22.04 the default is to install mariadb
      # As the ubuntu 20.04 runner we use in github actions allready has mysql installed
      # a apparmor error is triggerd when using mariadb in this test..
      # Forcing the use of mysql
      if $facts['os']['name'] == 'Ubuntu' and versioncmp($facts['os']['release']['major'], '20.04') >= 0 {
        $mysql_service_name = 'mysql'
        $mysql_server_package = 'mysql-server'
        $mysql_client_package = 'mysql-client'
      } else {
        $mysql_service_name = undef
        $mysql_server_package = undef
        $mysql_client_package = undef
      }

      class { 'mysql::server':
        root_password => 'strongpassword',
        package_name => $mysql_server_package,
        service_name => $mysql_service_name,
      }
      class { 'mysql::client':
        package_name => $mysql_client_package,
      }

      $cs = 'utf8mb4'

      mysql::db { 'jira':
        charset  => $cs,
        collate  => "${cs}_general_ci",
        user     => 'jiraadm',
        password => 'mypassword',
        host     => 'localhost',
        grant    => ['ALL'],
      }

      class { 'java':
        distribution => 'jre',
      }

      exec { 'tmpkey':
        command => "openssl req -x509 -nodes -days 1 -subj '/C=CA/ST=QC/L=Montreal/O=FOO/CN=${facts['networking']['fqdn']}' -newkey rsa:1024 -keyout /tmp/key.pem -out /tmp/cert.pem",
        path    => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ],
        creates => '/tmp/cert.pem',
      }

      java_ks { 'jira':
        ensure      => present,
        name        => 'jira',
        certificate => '/tmp/cert.pem',
        private_key => '/tmp/key.pem',
        target      => '/tmp/jira.ks',
        password    => 'changeit',
        require     => Exec['tmpkey'],
      }

      # There is a bug in the check-java.sh that prevents jira from starting on Centos Stream 8
      # https://jira.atlassian.com/browse/JRASERVER-77097
      # Running with script_check_java_manage => true to solve this
      class { 'jira':
        installdir               => '/opt/atlassian-jira',
        homedir                  => '/opt/jira-home',
        javahome                 => '/usr',
        jvm_type                 => 'oracle-jdk-1.8',
        db                       => 'mysql',
        dbport                   => 3306,
        dbdriver                 => 'com.mysql.jdbc.Driver',
        dbtype                   => 'mysql',
        tomcat_port              => 8081,
        tomcat_native_ssl        => true,
        tomcat_keystore_file     => '/tmp/jira.ks',
        script_check_java_manage => true,
        require                  => [Mysql::Db['jira'], Java_ks['jira']],
      }
    EOS

    wget_cmd = 'wget -q --tries=24 --retry-connrefused --read-timeout=10 --no-check-certificate localhost:8081'
    apply_manifest(pp, catch_failures: true)
    sleep SLEEP_SECONDS
    shell wget_cmd, acceptable_exit_codes: [0, 8]
    sleep SLEEP_SECONDS
    shell wget_cmd, acceptable_exit_codes: [0, 8]

    apply_manifest(pp, catch_changes: true)
  end

  describe process('java') do
    it { is_expected.to be_running }
  end

  describe port(8081) do
    it { is_expected.to be_listening }
  end

  describe service('jira') do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end

  describe user('jira') do
    it { is_expected.to belong_to_group 'jira' }
    it { is_expected.to have_login_shell '/bin/true' }
  end

  specify do
    expect(command('wget -q --tries=24 --retry-connrefused --no-check-certificate --read-timeout=10 -O- localhost:8081')).
      to have_attributes(stdout: %r{8.13.5})
  end

  specify do
    expect(command('wget -q --tries=24 --retry-connrefused --no-check-certificate --read-timeout=10 -O- https://localhost:8443')).
      to have_attributes(stdout: %r{8.13.5})
  end

  describe 'shutdown' do
    it { shell('service jira stop', acceptable_exit_codes: [0, 1]) }
    it { shell('pkill -9 -f mysql', acceptable_exit_codes: [0, 1]) }
    it { shell('pkill -9 -f jira', acceptable_exit_codes: [0, 1]) }
  end
end
