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

# @api private
class jira::install {
  include 'archive'

  if $jira::manage_user {
    group { $jira::group:
      ensure => present,
      gid    => $jira::gid,
    }
    -> user { $jira::user:
      comment          => 'Jira daemon account',
      shell            => $jira::shell,
      home             => $jira::homedir,
      password         => '*',
      password_min_age => '0',
      password_max_age => '99999',
      managehome       => false,
      uid              => $jira::uid,
      gid              => $jira::gid,
    }
  }

  if $jira::manage_homedir {
    file { $jira::homedir:
      ensure => 'directory',
      owner  => $jira::user,
      group  => $jira::group,
      mode   => $jira::homedir_mode,
    }
  }

  if ! defined(File[$jira::installdir]) {
    file { $jira::installdir:
      ensure => 'directory',
      owner  => $jira::installdir_owner,
      group  => $jira::installdir_group,
      mode   => $jira::installdir_mode,
    }
  }

  if $jira::java_package {
    package { $jira::java_package:
      ensure => 'present',
    }
  }

  $file = "atlassian-${jira::product_name}-${jira::version}.tar.gz"

  # webappdir is defined in init.pp because other things depend on it.
  if ! defined(File[$jira::webappdir]) {
    file { $jira::webappdir:
      ensure => 'directory',
      owner  => $jira::user,
      group  => $jira::group,
    }
  }

  archive { "/tmp/${file}":
    ensure          => present,
    extract         => true,
    extract_command => 'tar xfz %s --strip-components=1',
    extract_path    => $jira::webappdir,
    source          => "${jira::download_url}/${file}",
    creates         => "${jira::webappdir}/conf",
    cleanup         => true,
    checksum_verify => ($jira::checksum != undef),
    checksum_type   => 'md5',
    checksum        => $jira::checksum,
    user            => $jira::user,
    group           => $jira::group,
    proxy_server    => $jira::proxy_server,
    proxy_type      => $jira::proxy_type,
    require         => [
      File[$jira::installdir],
      User[$jira::user],
      File[$jira::webappdir],
    ],
  }

  -> exec { "chown_${jira::webappdir}":
    command     => shellquote('/bin/chown', '-R', "${jira::user}:${jira::group}", $jira::webappdir),
    refreshonly => true,
    subscribe   => User[$jira::user],
  }

  file { "${jira::installdir}/atlassian-${jira::product_name}-running":
    ensure  => 'link',
    target  => $jira::webappdir,
    notify  => Exec['stop-jira-for-version-change'],
    require => Archive["/tmp/${file}"],
  }

  exec { 'stop-jira-for-version-change':
    path        => ['/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/'],
    command     => $jira::stop_jira,
    refreshonly => true,
    # 5 means the service doesn't exist; that's fine
    returns     => [0, 5],
  }

  if $jira::db == 'mysql' and $jira::mysql_connector_manage {
    class { 'jira::mysql_connector':
      require => Archive["/tmp/${file}"],
    }
    contain jira::mysql_connector
  }
}
