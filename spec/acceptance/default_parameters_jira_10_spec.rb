# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'jira 10 postgresql' do
  it 'installs jira 10 with defaults' do
    prepare = <<-EOS

      package {'diffutils':
        ensure  => installed
      }
      file_line{'enable show_diff':
        path => '/etc/puppetlabs/puppet/puppet.conf',
        line => 'show_diff = true'
      }
    EOS
    apply_manifest(prepare, catch_failures: true)

    pp = <<-EOS

      $java_package = $facts['os']['family'] ? {
        'RedHat' => 'java-17-openjdk-headless',
        'Debian' => 'openjdk-17-jre-headless',
      }

      $java_home = $facts['os']['family'] ? {
        'RedHat' => '/usr/lib/jvm/jre-17-openjdk',
        'Debian' => '/usr/lib/jvm/java-1.17.0-openjdk-amd64',
      }

      # The output of `systemctl status postgresql` is non ascii which
      # breaks the Exec in Postgresql::Server::Instance::Reload
      # on rhel based docker containers
      # We don't need the output.
      class { 'postgresql::server':
        service_status => 'systemctl status postgresql > /dev/null'
      }

      postgresql::server::db { 'jira':
        user     => 'jiraadm',
        password => postgresql::postgresql_password('jiraadm', 'mypassword'),
      }

      # There is a bug in the check-java.sh that prevents jira from starting on Centos Stream 8
      # https://jira.atlassian.com/browse/JRASERVER-77097
      # Running with script_check_java_manage => true to solve this
      class { 'jira':
        version                  => '10.3.2',
        change_dbpassword        => true,
        java_package             => $java_package,
        javahome                 => $java_home,
        script_check_java_manage => false,
        connection_settings      => 'tcpKeepAlive=true',
        require                  => Postgresql::Server::Db['jira']
      }
    EOS

    pp_upgrade = <<-EOS
      $java_package = $facts['os']['family'] ? {
        'RedHat' => 'java-17-openjdk-headless',
        'Debian' => 'openjdk-17-jre-headless',
      }

      $java_home = $facts['os']['family'] ? {
        'RedHat' => '/usr/lib/jvm/jre-17-openjdk',
        'Debian' => '/usr/lib/jvm/java-1.17.0-openjdk-amd64',
      }

      class { 'jira':
        version                  => '10.3.3',
        change_dbpassword        => true,
        java_package             => $java_package,
        javahome                 => $java_home,
        connection_settings      => 'tcpKeepAlive=true',
        script_check_java_manage => false
      }
    EOS

    # jira just takes *ages* to start up :-(
    wget_cmd = 'wget -q --tries=24 --retry-connrefused --read-timeout=10 localhost:8080'
    apply_manifest(pp, catch_failures: true)
    sleep SLEEP_SECONDS
    shell wget_cmd, acceptable_exit_codes: [0, 8]
    sleep SLEEP_SECONDS
    shell wget_cmd, acceptable_exit_codes: [0, 8]
    pp = pp.gsub(/change_dbpassword.+=> true,/, 'change_dbpassword => false,')
    apply_manifest(pp, catch_changes: true)

    apply_manifest(pp_upgrade, catch_failures: true)
    sleep SLEEP_SECONDS
    shell wget_cmd, acceptable_exit_codes: [0, 8]
    sleep SLEEP_SECONDS
    shell wget_cmd, acceptable_exit_codes: [0, 8]

    pp_upgrade = pp_upgrade.gsub(/change_dbpassword.+=> true,/, 'change_dbpassword => false,')
    apply_manifest(pp_upgrade, catch_changes: true)
  end

  describe process('java') do
    it { is_expected.to be_running }
  end

  describe port(8080) do
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
  describe command('sleep 1200') do
  end
  describe command('wget -q --tries=54 --retry-connrefused --read-timeout=10 -O- localhost:8080') do
    its(:stdout) { is_expected.to include('10.3.3') }
  end

  describe 'shutdown' do
    it { shell('service jira stop', acceptable_exit_codes: [0, 1]) }
    it { shell('pkill -9 -f postgres', acceptable_exit_codes: [0, 1]) }
    it { shell('pkill -9 -f jira', acceptable_exit_codes: [0, 1]) }
  end
end
