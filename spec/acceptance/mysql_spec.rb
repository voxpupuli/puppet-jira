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

describe 'jira mysql', :unless => UNSUPPORTED_PLATFORMS.include?(fact('osfamily')) do

  it 'installs with mysql database' do
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
      class { '::mysql::server':
        root_password    => 'strongpassword',
      } ->
      class { 'mysql::bindings':
        java_enable => true,
      } ->
      mysql::db { 'jira':
        user     => 'jiraadm',
        password => 'mypassword',
        host     => 'localhost',
        grant    => ['ALL'],
      }->
      deploy::file { 'jdk-7u71-linux-x64.tar.gz':
        target          => $jh,
        fetch_options   => '-q -c --header "Cookie: oraclelicense=accept-securebackup-cookie"',
        url             => #{java_url},
        download_timout => 1800,
        strip           => true,
      } ->
      class { 'jira':
        installdir  => '/opt/atlassian-jira',
        homedir     => '/opt/jira-home',
        version     => '6.3.6',
        downloadURL => #{download_url},
        javahome    => $jh,
        db          => 'mysql',
        dbport      => '3306',
        dbdriver    => 'com.mysql.jdbc.Driver',
        dbtype      => 'mysql',
        tomcatPort  => '8081',
      }
      class { 'jira::facts': }
   EOS
    apply_manifest(pp, :catch_failures => true)
    sleep 60
    shell 'wget -q --tries=240 --retry-connrefused --read-timeout=10 localhost:8081', :acceptable_exit_codes => [0,8]
    sleep 60
    shell 'wget -q --tries=240 --retry-connrefused --read-timeout=10 localhost:8081', :acceptable_exit_codes => [0,8]
    sleep 60
    apply_manifest(pp, :catch_changes => true)
  end

  describe process("java") do
    it { should be_running }
  end

  describe port(8081) do
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

  describe command('wget -q --tries=240 --retry-connrefused --read-timeout=10 -O- localhost:8081') do
    its(:stdout) { should match /6\.3\.6/ }
  end

  describe 'shutdown' do
    it { shell("service jira stop", :acceptable_exit_codes => [0,1]) }
    it { shell("pkill -f mysql", :acceptable_exit_codes => [0,1]) }
    it { shell("pkill -f mysql", :acceptable_exit_codes => [0,1]) }
    it { shell("pkill -f jira", :acceptable_exit_codes => [0,1]) }
    it { shell("pkill -f jira", :acceptable_exit_codes => [0,1]) }
  end

end
