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

describe 'jira mysql', unless: UNSUPPORTED_PLATFORMS.include?(fact('osfamily')) do
  it 'installs with mysql database' do
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
      class { '::mysql::server':
        root_password => 'strongpassword',
      } ->
      mysql::db { 'jira':
        user     => 'jiraadm',
        password => 'mypassword',
        host     => 'localhost',
        grant    => ['ALL'],
      } ->
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
      file { "/bin/keytool":
        ensure => link,
        target => "/opt/java/bin/keytool",
      } ->
      exec { 'tmpkey':
        command => "openssl req -x509 -nodes -days 1 -subj '/C=CA/ST=QC/L=Montreal/O=FOO/CN=${fqdn}' -newkey rsa:1024 -keyout /tmp/key.pem -out /tmp/cert.pem",
        path    => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ],
        creates => '/tmp/cert.pem',
      } ->
      java_ks { 'jira':
        ensure      => present,
        name        => 'jira',
        certificate => '/tmp/cert.pem',
        private_key => '/tmp/key.pem',
        target      => '/tmp/jira.ks',
        password    => 'changeit',
      } ->
      class { '::jira':
        installdir           => '/opt/atlassian-jira',
        homedir              => '/opt/jira-home',
        version              => '6.3.6',
        download_url         => #{download_url},
        javahome             => $jh,
        db                   => 'mysql',
        dbport               => '3306',
        dbdriver             => 'com.mysql.jdbc.Driver',
        dbtype               => 'mysql',
        tomcat_port          => '8081',
        tomcat_native_ssl    => true,
        tomcat_keystore_file => '/tmp/jira.ks',
      }

      include ::jira::facts
    EOS
    apply_manifest(pp, catch_failures: true)
    sleep 60
    shell 'wget -q --tries=240 --retry-connrefused --read-timeout=10 --no-check-certificate localhost:8081', acceptable_exit_codes: [0, 8]
    sleep 60
    shell 'wget -q --tries=240 --retry-connrefused --read-timeout=10 --no-check-certificate localhost:8081', acceptable_exit_codes: [0, 8]
    sleep 60
    apply_manifest(pp, catch_changes: true)
  end

  describe process('java') do
    it { is_expected.to be_running }
  end

  describe port(8081) do
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

  describe command('wget -q --tries=240 --retry-connrefused --no-check-certificate --read-timeout=10 -O- localhost:8081') do
    its(:stdout) { is_expected.to match(%r{6\.3\.6}) }
  end

  describe command('wget -q --tries=240 --retry-connrefused --no-check-certificate --read-timeout=10 -O- https://localhost:8443') do
    its(:stdout) { is_expected.to match(%r{6\.3\.6}) }
  end

  describe 'shutdown' do
    it { shell('service jira stop', acceptable_exit_codes: [0, 1]) }
    it { shell('pkill -9 -f mysql', acceptable_exit_codes: [0, 1]) }
    it { shell('pkill -9 -f jira', acceptable_exit_codes: [0, 1]) }
  end
end
