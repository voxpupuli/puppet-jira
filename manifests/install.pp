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

  group { $jira::group:
    ensure => present,
    gid    => $jira::gid
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

  $file = "atlassian-${jira::product}-${jira::version}.${jira::format}"
  if $jira::staging_or_deploy == 'staging' {

    require staging

    if ! defined(File[$jira::webappdir]) {
      file { $jira::webappdir:
        ensure => 'directory',
        owner  => $jira::user,
        group  => $jira::group,
      }
    }

    staging::file { $file:
      source  => "${jira::downloadURL}/${file}",
      timeout => 1800,
    } ->

    staging::extract { $file:
      target  => $jira::webappdir,
      creates => "${jira::webappdir}/conf",
      strip   => 1,
      user    => $jira::user,
      group   => $jira::group,
      notify  => Exec["chown_${jira::webappdir}"],
      before  => File[$jira::homedir],
      require => [
        File[$jira::installdir],
        User[$jira::user],
        File[$jira::webappdir] ],
    }
  } elsif $jira::staging_or_deploy == 'deploy' {

    deploy::file { $file:
      target          => $jira::webappdir,
      url             => $jira::downloadURL,
      strip           => true,
      download_timout => 1800,
      owner           => $jira::user,
      group           => $jira::group,
      notify          => Exec["chown_${jira::webappdir}"],
      before          => File[$jira::homedir],
      require         => [ File[$jira::installdir], User[$jira::user] ],
    }

  } else {
    fail('staging_or_deploy must equal "staging" or "deploy"')
  }

  file { $jira::homedir:
    ensure => 'directory',
    owner  => $jira::user,
    group  => $jira::group,
  } ->

  exec { "chown_${jira::webappdir}":
    command     => "/bin/chown -R ${jira::user}:${jira::group} ${jira::webappdir}",
    refreshonly => true,
    subscribe   => User[$jira::user]
  }

  if $jira::db == 'mysql' and $jira::mysql_connector_manage {
    if $jira::staging_or_deploy == 'staging' {
      class { '::jira::mysql_connector':
        require => Staging::Extract[$file],
      }
    } elsif $jira::staging_or_deploy == 'deploy' {
      class { '::jira::mysql_connector':
        require => Deploy::File[$file],
      }
    }
    contain ::jira::mysql_connector
  }
}
