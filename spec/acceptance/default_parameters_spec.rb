require 'spec_helper_acceptance'

# It is sometimes faster to host jira / java files on a local webserver.
# Set environment variable download_url to use local webserver
# export download_url = 'http://10.0.0.XXX/'
download_url = ENV['download_url'] if ENV['download_url']
download_url = if ENV['download_url']
                 ENV['download_url']
               else
                 'undef'
               end
java_url = if download_url == 'undef'
             'http://download.oracle.com/otn-pub/java/jdk/8u112-b15/jdk-8u112-linux-x64.tar.gz'
           else
             download_url
           end

describe 'jira postgresql', unless: UNSUPPORTED_PLATFORMS.include?(fact('osfamily')) do
  it 'installs with defaults' do
    pp = <<-EOS
      $jh = $osfamily ? {
        default => '/opt/java',
      }
      if versioncmp($::puppetversion,'3.6.1') >= 0 {
        $allow_virtual_packages = hiera('allow_virtual_packages',false)
        Package {
          allow_virtual => $allow_virtual_packages,
        }
      }
      class { '::postgresql::globals':
        manage_package_repo => true,
        version             => '9.3',
      }->
      class { '::postgresql::server': } ->
      file { $jh:
        ensure => 'directory',
      } ->
      archive { '/tmp/jdk-8u112-linux-x64.tar.gz':
        ensure          => present,
        extract         => true,
        extract_command => 'tar xfz %s --strip-components=1',
        extract_path    => $jh,
        source          => "#{java_url}",
        creates         => "${jh}/bin",
        cleanup         => true,
        cookie          => 'oraclelicense=accept-securebackup-cookie',
      } ->
      class { '::jira':
        version      => '6.3.4a',
        download_url => #{download_url},
        javahome     => $jh,
      }
      class { '::jira::facts': }
      postgresql::server::db { 'jira':
        user     => 'jiraadm',
        password => postgresql_password('jiraadm', 'mypassword'),
      }
    EOS
    apply_manifest(pp, catch_failures: true)
    shell 'wget -q --tries=240 --retry-connrefused --read-timeout=10 localhost:8080', acceptable_exit_codes: [0]
    sleep 120
    shell 'wget -q --tries=240 --retry-connrefused --read-timeout=10 localhost:8080', acceptable_exit_codes: [0]
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

  describe command('wget -q --tries=240 --retry-connrefused --read-timeout=10 -O- localhost:8080') do
    its(:stdout) { is_expected.to match(%r{6\.3\.4a}) }
  end

  describe 'shutdown' do
    it { shell('service jira stop', acceptable_exit_codes: [0, 1]) }
    it { shell('pkill -9 -f postgres', acceptable_exit_codes: [0, 1]) }
    it { shell('pkill -9 -f jira', acceptable_exit_codes: [0, 1]) }
  end
end
