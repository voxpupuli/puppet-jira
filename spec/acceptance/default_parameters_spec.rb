require 'spec_helper_acceptance'

describe 'jira postgresql' do
  it 'installs with defaults' do
    pp = <<-EOS
      if versioncmp($facts['puppetversion'],'3.6.1') >= 0 {
        $allow_virtual_packages = hiera('allow_virtual_packages',false)
        Package {
          allow_virtual => $allow_virtual_packages,
        }
      }
      # This is needed for testing, so just including here
      ensure_packages(['wget'])
      class { 'postgresql::globals':
        manage_package_repo => true,
      }
      -> class { 'postgresql::server': }
      -> class { 'java':
        distribution => 'jre',
      }
      -> class { 'jira':
        version      => '6.3.4a',
        javahome     => '/usr',
      }
      class { 'jira::facts': }
      postgresql::server::db { 'jira':
        user     => 'jiraadm',
        password => postgresql_password('jiraadm', 'mypassword'),
      }
    EOS
    apply_manifest(pp, catch_failures: true)
    shell 'wget -q --tries=24 --retry-connrefused --read-timeout=10 localhost:8080', acceptable_exit_codes: [0]
    sleep 120
    shell 'wget -q --tries=24 --retry-connrefused --read-timeout=10 localhost:8080', acceptable_exit_codes: [0]
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
    its(:stdout) { is_expected.to match(%r{6\.3\.4a}) }
  end

  describe 'shutdown' do
    it { shell('service jira stop', acceptable_exit_codes: [0, 1]) }
    it { shell('pkill -9 -f postgres', acceptable_exit_codes: [0, 1]) }
    it { shell('pkill -9 -f jira', acceptable_exit_codes: [0, 1]) }
  end
end
