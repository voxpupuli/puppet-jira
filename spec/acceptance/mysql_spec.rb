# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'jira mysql' do
  it 'installs with defaults' do
    pp = <<-EOS
      class { 'mysql::server':
        root_password => 'strongpassword',
      }
      include mysql::client

      $cs = 'utf8mb4'

      mysql::db { 'jira':
        charset  => $cs,
        collate  => "${cs}_general_ci",
        user     => 'jiraadm',
        password => 'mypassword',
        host     => 'localhost',
        grant    => ['ALL'],
      }

      class { 'jira':
        db      => 'mysql',
        require => Mysql::Db['jira'],
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

  describe command('wget -q --tries=54 --retry-connrefused --read-timeout=10 -O- localhost:8080') do
    its(:stdout) { is_expected.to include('9.12.0') }
  end

  describe 'shutdown' do
    it { shell('service jira stop', acceptable_exit_codes: [0, 1]) }
    it { shell('pkill -9 -f mysql', acceptable_exit_codes: [0, 1]) }
    it { shell('pkill -9 -f jira', acceptable_exit_codes: [0, 1]) }
  end
end
