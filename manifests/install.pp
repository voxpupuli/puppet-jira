# -----------------------------------------------------------------------------
#   Copyright (c) 2012 Bryce Johnson
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
# -----------------------------------------------------------------------------
class jira::install {

  include '::archive'

  group { $jira::group:
    ensure => present,
    gid    => $jira::gid,
  } ->
  user { $jira::user:
    comment          => 'Jira daemon account',
    shell            => $jira::shell,
    home             => $jira::homedir,
    password         => '*',
    password_min_age => '0',
    password_max_age => '99999',
    managehome       => true,
    uid              => $jira::uid,
    gid              => $jira::gid,

  }

  if ! defined(File[$jira::installdir]) {
    file { $jira::installdir:
      ensure => 'directory',
      owner  => $jira::user,
      group  => $jira::group,
    }
  }

  # Examples of product tarballs from Atlassian
  # Core                - atlassian-jira-core-7.0.3.tar.gz
  # Service Desk        - atlassian-servicedesk-3.1.9.tar.gz
  # Software (pre-7)    - atlassian-jira-6.4.12.tar.gz
  # Software latest     - atlassian-jira-software-7.1.9.tar.gz
  # Software (7 and up) - atlassian-jira-software-7.1.8-jira-7.1.8.tar.gz

  # https://downloads.atlassian.com/software/jira/downloads/atlassian-jira-7.1.9.tar.gz
  # https://downloads.atlassian.com/software/jira/downloads/atlassian-jira-software-7.1.9.tar.gz

  if $jira::product_type {

    case $jira::product_type {

      'servicedesk':{
          $file = "atlassian-${jira::product_type}-${jira::version}.${jira::format}"
      }
      'core','software':{
        if ! $jira::latest_version{
          $file = "atlassian-${jira::product}-${jira::product_type}-${jira::version}-${jira::product}-${jira::version}.${jira::format}"
        }
        else {
          $file = "atlassian-${jira::product}-${jira::product_type}-${jira::version}.${jira::format}"
        }
      }
    }
  }

  else {
    $file = "atlassian-${jira::product}-${jira::version}.${jira::format}"
  }

  if ! defined(File[$jira::extractdir]) {
    file { $jira::extractdir:
      ensure => 'directory',
      owner  => $jira::user,
      group  => $jira::group,
    }
  }

  if ! defined(File[$jira::webappdir]) {
    file { $jira::webappdir:
      ensure => 'directory',
      owner  => $jira::user,
      group  => $jira::group,
    }
  }

  case $jira::deploy_module {
    'staging': {
      require staging
      staging::file { $file:
        source  => "${jira::download_url}/${file}",
        timeout => 1800,
      } ->
      staging::extract { $file:
        target  => $jira::extractdir,
        creates => "${jira::webappdir}/conf",
        strip   => 1,
        user    => $jira::user,
        group   => $jira::group,
        notify  => Exec["chown_${jira::extractdir}"],
        before  => File[$jira::homedir],
        require => [
          File[$jira::installdir],
          User[$jira::user],
          File[$jira::extractdir] ],
      }
    }
    'archive': {
      archive { "/tmp/${file}":
        ensure          => present,
        extract         => true,
        extract_command => 'tar xfz %s --strip-components=1',
        extract_path    => $jira::webappdir,
        source          => "${jira::download_url}/${file}",
        creates         => "${jira::webappdir}/conf",
        cleanup         => true,
        checksum_type   => 'md5',
        checksum        => $jira::checksum,
        user            => $jira::user,
        group           => $jira::group,
        before          => File[$jira::homedir],
        require         => [
          File[$jira::installdir],
          File[$jira::webappdir],
          User[$jira::user],
        ],
      }
    }
    default: {
      fail('deploy_module parameter must equal "archive" or staging""')
    }
  }

  file { $jira::homedir:
    ensure => 'directory',
    owner  => $jira::user,
    group  => $jira::group,
  } ->

  exec { "chown_${jira::extractdir}":
    command     => "/bin/chown -R ${jira::user}:${jira::group} ${jira::extractdir}",
    refreshonly => true,
    subscribe   => User[$jira::user],
  }

  if $jira::db == 'mysql' and $jira::mysql_connector_manage {
    if $jira::deploy_module == 'archive' {
      class { '::jira::mysql_connector':
        require => Archive["/tmp/${file}"],
      }
    } elsif $jira::deploy_module == 'deploy' {
      class { '::jira::mysql_connector':
        require => Staging::Extract[$file],
      }
    }
    contain ::jira::mysql_connector
  }
}
