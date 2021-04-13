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
class jira::config inherits jira {
  File {
    owner => $jira::user,
    group => $jira::group,
  }

  $dbschema_default = $jira::db ? {
    'postgresql' => 'public',
    default      => undef
  }

  # can't use pick_default: https://tickets.puppetlabs.com/browse/MODULES-11018
  $dbschema = if $jira::dbschema { $jira::dbschema } else { $dbschema_default }

  file { "${jira::webappdir}/bin/user.sh":
    content => template('jira/user.sh.erb'),
    mode    => '0755',
    require => [
      Class['jira::install'],
      File[$jira::webappdir],
      File[$jira::homedir],
    ],
  }

  -> file { "${jira::webappdir}/bin/setenv.sh":
    content => template('jira/setenv.sh.erb'),
    mode    => '0755',
    require => Class['jira::install'],
    notify  => Class['jira::service'],
  }

  -> file { "${jira::homedir}/dbconfig.xml":
    content => epp('jira/dbconfig.xml.epp'),
    mode    => '0600',
    require => [Class['jira::install'],File[$jira::homedir]],
    notify  => Class['jira::service'],
  }

  if $jira::script_check_java_manage {
    file { "${jira::webappdir}/bin/check-java.sh":
      content => template($jira::script_check_java_template),
      mode    => '0755',
      require => [
        Class['jira::install'],
        File["${jira::webappdir}/bin/setenv.sh"],
      ],
      notify  => Class['jira::service'],
    }
  }

  file { "${jira::webappdir}/conf/server.xml":
    content => template('jira/server.xml.erb'),
    mode    => '0600',
    require => Class['jira::install'],
    notify  => Class['jira::service'],
  }
  -> file { "${jira::webappdir}/conf/context.xml":
    content => template('jira/context.xml.erb'),
    mode    => '0600',
    require => Class['jira::install'],
    notify  => Class['jira::service'],
  }

  file { "${jira::homedir}/jira-config.properties":
    content => template('jira/jira-config.properties.erb'),
    mode    => '0600',
    require => [Class['jira::install'],File[$jira::homedir]],
    notify  => Class['jira::service'],
  }

  if $jira::datacenter {
    file { "${jira::homedir}/cluster.properties":
      content => template('jira/cluster.properties.erb'),
      mode    => '0600',
      require => [Class['jira::install'],File[$jira::homedir]],
      notify  => Class['jira::service'],
    }
  }
}
