# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'jira postgresql' do
  it 'installs with defaults' do
    pp = <<-EOS
      $java_package = $facts['os']['family'] ? {
        'RedHat' => 'java-11-openjdk-headless',
        'Debian' => 'openjdk-11-jre-headless',
      }

      $java_home = $facts['os']['family'] ? {
        'RedHat' => '/usr/lib/jvm/jre-11-openjdk',
        'Debian' => '/usr/lib/jvm/java-1.11.0-openjdk-amd64',
      }

      class { 'postgresql::server': }

      postgresql::server::db { 'jira':
        user     => 'jiraadm',
        password => postgresql::postgresql_password('jiraadm', 'mypassword'),
      }

      class { 'jira':
        java_package => $java_package,
        javahome     => $java_home,
        require      => Postgresql::Server::Db['jira'],
      }
    EOS
    pp_upgrade = <<-EOS
      $java_package = $facts['os']['family'] ? {
        'RedHat' => 'java-11-openjdk-headless',
        'Debian' => 'openjdk-11-jre-headless',
      }

      $java_home = $facts['os']['family'] ? {
        'RedHat' => '/usr/lib/jvm/jre-11-openjdk',
        'Debian' => '/usr/lib/jvm/java-1.11.0-openjdk-amd64',
      }

      class { 'jira':
        version      => '8.16.0',
        java_package => $java_package,
        javahome     => $java_home,
      }
    EOS

    # jira just takes *ages* to start up :-(
    wget_cmd = 'wget -q --tries=24 --retry-connrefused --read-timeout=10 localhost:8080'
    apply_manifest(pp, catch_failures: true)
    sleep 60
    shell wget_cmd, acceptable_exit_codes: [0, 8]
    sleep 60
    shell wget_cmd, acceptable_exit_codes: [0, 8]
    sleep 60
    apply_manifest(pp_upgrade, catch_failures: true)
    sleep 60
    shell wget_cmd, acceptable_exit_codes: [0, 8]
    sleep 60
    shell wget_cmd, acceptable_exit_codes: [0, 8]
    sleep 60
    apply_manifest(pp_upgrade, catch_failures: true)
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

  specify do
    expect(user('jira')).to exist.
      and belong_to_group 'jira'.
        and have_login_shell '/bin/true'
  end

  describe command('wget -q --tries=24 --retry-connrefused --read-timeout=10 -O- localhost:8080') do
    its(:stdout) { is_expected.to include('8.16.0') }
  end

  describe 'shutdown' do
    it { shell('service jira stop', acceptable_exit_codes: [0, 1]) }
    it { shell('pkill -9 -f postgres', acceptable_exit_codes: [0, 1]) }
    it { shell('pkill -9 -f jira', acceptable_exit_codes: [0, 1]) }
  end
end
