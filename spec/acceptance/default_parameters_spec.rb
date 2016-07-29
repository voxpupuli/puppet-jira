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
             'http://download.oracle.com/otn-pub/java/jdk/7u71-b14/'
           else
             download_url
           end

describe 'jira postgresql', unless: UNSUPPORTED_PLATFORMS.include?(fact('osfamily')) do
  it 'installs with defaults' do
    pp = <<-EOS
      $jh = $osfamily ? {
        default   => '/opt/java',
      }
      if versioncmp($::puppetversion,'3.6.1') >= 0 {
        $allow_virtual_packages = hiera('allow_virtual_packages',false)
        Package {
          allow_virtual => $allow_virtual_packages,
        }
      }
      class { 'postgresql::globals':
        manage_package_repo => true,
        version             => '9.3',
      }->
      class { 'postgresql::server': } ->
      deploy::file { 'jdk-7u71-linux-x64.tar.gz':
        target          => $jh,
        fetch_options   => '-q -c --header "Cookie: oraclelicense=accept-securebackup-cookie"',
        url             => #{java_url},
        download_timout => 1800,
        strip           => true,
      } ->
      class { 'jira':
        version      => '6.2.7',
        download_url => #{download_url},
        javahome     => $jh,
      }
      class { 'jira::facts': }
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
    it { should be_running }
  end

  describe port(8080) do
    it { is_expected.to be_listening }
  end

  describe service('jira') do
    it { should be_enabled }
    it { should be_running }
  end

  describe user('jira') do
    it { should exist }
  end

  describe user('jira') do
    it { should belong_to_group 'jira' }
  end

  describe user('jira') do
    it { should have_login_shell '/bin/true' }
  end

  describe command('wget -q --tries=240 --retry-connrefused --read-timeout=10 -O- localhost:8080') do
    its(:stdout) { should match(%r{6\.2\.7}) }
  end

  describe 'shutdown' do
    it { shell('service jira stop', acceptable_exit_codes: [0, 1]) }
    it { shell('pkill -f postgres', acceptable_exit_codes: [0, 1]) }
    it { shell('pkill -f postgres', acceptable_exit_codes: [0, 1]) }
    it { shell('pkill -f jira', acceptable_exit_codes: [0, 1]) }
    it { shell('pkill -f jira', acceptable_exit_codes: [0, 1]) }
  end
end
