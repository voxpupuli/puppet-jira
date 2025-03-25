# frozen_string_literal: true

require 'spec_helper_acceptance'

def on_supported_os
  family = fact('os.family')
  major = fact('os.release.major')
  (family == 'Debian' and (major >= '22.04' or major >= '11')) or (family == 'RedHat' and major >= '8')
end

prepare = <<-EOS
  # package {'diffutils':
  #   ensure  => installed
  # }
  # file_line{'enable show_diff':
  #   path => '/etc/puppetlabs/puppet/puppet.conf',
  #   line => 'show_diff = true'
  # }
EOS

pre = <<-EOS
  if $facts['os']['family']  == 'RedHat' {
    $java_package = 'java-17-openjdk'
    $java_home = '/usr/lib/jvm/jre-17-openjdk'
    $postgresql_version = '13'
    $pgsql_package_name = 'postgresql-server'
    $pgsql_data_dir = '/var/lib/pgsql'
    $manage_dnf_module = $facts['os']['release']['major'] ? {
      '8'       => true,
      default   => false # RHEL-9 has pgsql 13 as a default
    }
    $autoremove_command = 'dnf --exclude="systemd*" autoremove -y'
  }
  elsif $facts['os']['family']  == 'Debian' {
    $postgresql_version = $facts['os']['release']['major'] ? {
      '11'    => '13',
      '20.04' => '13',
      default => '14'
    }
    $java_package = 'openjdk-17-jre'
    $java_home = '/usr/lib/jvm/java-17-openjdk-amd64'
    $pgsql_package_name = "postgresql-${postgresql_version}"
    $pgsql_data_dir = "/var/lib/postgresql/${postgresql_version}/main/"
    $manage_dnf_module = false
    $autoremove_command = 'apt autoremove -y'
  }
  $jira_install_dir = '/opt/jira/'
  $postgres_service = 'postgresql'
  $jira_service = 'jira'
EOS

pp = <<-EOS
  # The output of `systemctl status postgresql` is non ascii which
  # breaks the Exec in Postgresql::Server::Instance::Reload
  # on rhel based docker containers
  # We don't need the output.
  class { 'postgresql::globals':
    manage_dnf_module => $manage_dnf_module,
    version           => $postgresql_version,
  }
  class { 'postgresql::server':
    service_status => 'systemctl status postgresql > /dev/null',
    needs_initdb   => true
  }

  postgresql::server::db { 'jira':
    user     => 'jiraadm',
    password => postgresql::postgresql_password('jiraadm', 'mypassword'),
  }

  # There is a bug in the check-java.sh that prevents jira from starting on Centos Stream 8
  # https://jira.atlassian.com/browse/JRASERVER-77097
  # Running with script_check_java_manage => true to solve this
  class { 'jira':
    version                  => '10.3.2',
    java_package             => $java_package,
    javahome                 => $java_home,
    script_check_java_manage => false,
    connection_settings      => 'tcpKeepAlive=true',
    require                  => Postgresql::Server::Db['jira']
  }
EOS
pp = pre + pp

pp_upgrade = <<-EOS
  class { 'jira':
    version                  => '10.3.3',
    java_package             => $java_package,
    javahome                 => $java_home,
    connection_settings      => 'tcpKeepAlive=true',
    script_check_java_manage => false
  }
EOS
pp_upgrade = pre + pp_upgrade

pp_remove = <<-EOS
  package {$java_package:
    ensure => purged
  }
  exec {'clear JIRA home':
    command => 'rm -Rf ~jira/*',
    provider => shell,
  }
  package {$pgsql_package_name:
     ensure => purged
  }
  if $manage_dnf_module {
    exec {"dnf module reset postgresql":
      command => 'dnf module reset -y postgresql',
      provider => shell,
    }
  }
  exec {"autoremove cleanup":
    command => $autoremove_command,
    provider => shell,
  }
  exec {'cleanup pgsql and JIRA install dir':
    command => "rm -Rf ${pgsql_data_dir}/* ${$jira_install_dir}/atlassian-jira-software*",
    provider => shell,
    require => Exec['autoremove cleanup'],
  }
  service{$postgres_service:
    ensure => stopped
  }
  service{$jira_service:
    ensure => stopped
  }
EOS
pp_remove = pre + pp_remove

context 'jira 10 only on RedHat >=8 and Debian-11', if: on_supported_os do
  describe 'jira 10 postgresql' do
    it 'installs jira 10 with defaults' do
      apply_manifest(prepare, catch_failures: true)
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

    expected_version = '10.3.3'
    describe command("wget -q --tries=54 --retry-connrefused --read-timeout=10 -O- localhost:8080 | grep '#{expected_version}'") do
      its(:stdout) { is_expected.to include(expected_version) }
    end

    # cleanup after this spec to ensure that following tests start without any unmanaged
    # packages and data
    describe 'shutdown' do
      it 'cleans up nicely' do
        apply_manifest(pp_remove, catch_failures: true)
      end

      it { shell('service jira stop', acceptable_exit_codes: [0, 1]) }
      it { shell('pkill -9 -f postgres', acceptable_exit_codes: [0, 1]) }
      it { shell('pkill -9 -f jira', acceptable_exit_codes: [0, 1]) }
    end
  end
end
