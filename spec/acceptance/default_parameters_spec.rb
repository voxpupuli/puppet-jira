require 'spec_helper_acceptance'

# It is sometimes faster to host jira / java files on a local webserver.
# Set environment variable download_url to use local webserver
# export download_url = 'http://10.0.0.XXX/'
download_url = ENV['download_url'] if ENV['download_url']
if ENV['download_url'] then
  download_url = ENV['download_url']
else 
  download_url = 'undef'
end
if download_url == 'undef' then
  java_url = "'http://download.oracle.com/otn-pub/java/jdk/7u71-b14/'"
else 
  java_url = download_url
end

describe 'jira', :unless => UNSUPPORTED_PLATFORMS.include?(fact('osfamily')) do

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
        version     => '6.2.7',
        downloadURL => #{download_url},
        javahome    => $jh,
      }
      class { 'jira::facts': }
      postgresql::server::db { 'jira':
        user     => 'jiraadm',
        password => postgresql_password('jiraadm', 'mypassword'),
      }
    EOS
    apply_manifest(pp, :catch_failures => true)
    shell 'wget -q --tries=240 --retry-connrefused --read-timeout=10 localhost:8080', :acceptable_exit_codes => [0]
    sleep 120
    shell 'wget -q --tries=240 --retry-connrefused --read-timeout=10 localhost:8080', :acceptable_exit_codes => [0]
    sleep 60
    apply_manifest(pp, :catch_changes => true)
  end

# Need to insert license key before upgrade
#  it 'upgrades with defaults' do
#    pp_update = <<-EOS
#      $jh = $osfamily ? {
#        'RedHat'  => '/usr/lib/jvm/java-1.7.0-openjdk.x86_64',
#        'Debian'  => '/usr/lib/jvm/java-7-openjdk-amd64',
#        default   => '/opt/java',
#      }
#      class { 'stash':
#        version     => '3.3.1',
#        downloadURL => 'http://10.43.230.24/',
#        javahome    => $jh,
#      }
#    EOS
#    sleep 180
#    shell 'wget -q --tries=180 --retry-connrefused --read-timeout=10 localhost:8080', :acceptable_exit_codes => [0]
#    apply_manifest(pp_update, :catch_failures => true)
#    shell 'wget -q --tries=180 --retry-connrefused --read-timeout=10 localhost:8080', :acceptable_exit_codes => [0]
#    sleep 180
#    shell 'wget -q --tries=180 --retry-connrefused --read-timeout=10 localhost:8080', :acceptable_exit_codes => [0]
#    apply_manifest(pp_update, :catch_changes => true)
#  end
#
  describe process("java") do
    it { should be_running }
  end

  describe port(8080) do
    it { is_expected.to be_listening }
  end

  describe service('jira') do
    it { should be_enabled }
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

end
