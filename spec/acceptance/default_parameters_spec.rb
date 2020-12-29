require 'spec_helper_acceptance'

describe 'jira postgresql' do
  it 'installs with defaults' do
    pp = <<-EOS
      class { 'java':
        distribution => 'jre',
      }

      class { 'postgresql::server': }

      postgresql::server::db { 'jira':
        user     => 'jiraadm',
        password => postgresql::postgresql_password('jiraadm', 'mypassword'),
      }

      class { 'jira':
        javahome => '/usr',
        require  => [Class['java'], Postgresql::Server::Db['jira']],
      }

      class { 'jira::facts': }
    EOS

    apply_manifest(pp, catch_failures: true)
    sleep 60
    shell 'wget -q --tries=24 --retry-connrefused --read-timeout=10 localhost:8080', acceptable_exit_codes: [0, 8]
    sleep 60
    shell 'wget -q --tries=24 --retry-connrefused --read-timeout=10 localhost:8080', acceptable_exit_codes: [0, 8]
    sleep 60
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
    it { is_expected.to exist }
  end

  describe user('jira') do
    it { is_expected.to belong_to_group 'jira' }
  end

  describe user('jira') do
    it { is_expected.to have_login_shell '/bin/true' }
  end

  describe command('wget -q --tries=24 --retry-connrefused --read-timeout=10 -O- localhost:8080') do
    its(:stdout) { is_expected.to include('8.13.4') }
  end

  describe 'shutdown' do
    it { shell('service jira stop', acceptable_exit_codes: [0, 1]) }
    it { shell('pkill -9 -f postgres', acceptable_exit_codes: [0, 1]) }
    it { shell('pkill -9 -f jira', acceptable_exit_codes: [0, 1]) }
  end
end
