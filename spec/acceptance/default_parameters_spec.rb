# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'jira postgresql' do
  it 'installs with defaults' do
    pp = <<-EOS
      # The output of `systemctl status postgresql` is non ascii which
      # breaks the Exec in Postgresql::Server::Instance::Reload
      # on rhel based docker containers
      # We don't need the output.
      class { 'postgresql::server':
        service_status => 'systemctl status postgresql > /dev/null',
        needs_initdb   => true,
      }

      postgresql::server::db { 'jira':
        user     => 'jiraadm',
        password => postgresql::postgresql_password('jiraadm', 'mypassword'),
      }

      class { 'jira':
        require => Postgresql::Server::Db['jira'],
      }
    EOS

    pp_upgrade = <<-EOS
      class { 'jira':
        version => '9.12.29',
      }
    EOS

    # jira just takes *ages* to start up :-(
    wget_cmd = 'wget -q --tries=24 --retry-connrefused --read-timeout=10 localhost:8080'
    apply_manifest(pp, catch_failures: true)
    sleep SLEEP_SECONDS
    shell wget_cmd, acceptable_exit_codes: [0, 8]
    sleep SLEEP_SECONDS
    shell wget_cmd, acceptable_exit_codes: [0, 8]

    apply_manifest(pp, catch_changes: true)

    apply_manifest(pp_upgrade, catch_failures: true)
    sleep SLEEP_SECONDS
    shell wget_cmd, acceptable_exit_codes: [0, 8]
    sleep SLEEP_SECONDS
    shell wget_cmd, acceptable_exit_codes: [0, 8]

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

  describe command('tail -100 ~jira/log/atlassian-jira.log') do
    its(:stdout) { is_expected.to include('INFO') }
  end

  describe command('wget -q --tries=54 --retry-connrefused --read-timeout=10 -O- localhost:8080') do
    its(:stdout) { is_expected.to include('9.12.29') }
  end

  describe 'shutdown' do
    it { shell('service jira stop', acceptable_exit_codes: [0, 1]) }
    it { shell('pkill -9 -f postgres', acceptable_exit_codes: [0, 1]) }
    it { shell('pkill -9 -f jira', acceptable_exit_codes: [0, 1]) }
  end
end
