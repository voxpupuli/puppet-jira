#-----------------------------------------------------------------------------
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
#-----------------------------------------------------------------------------
class jira::config{

  require jira::params

  exec { 'mkdirp-homedir-jira':
    cwd     => "${jira::params::tmpdir}",
    command => "/bin/mkdir -p ${jira::params::homedir}",
    creates => "${jira::params::homedir}"
  }

  file { "${jira::params::webappdir}/bin/setenv.sh":
    content => template('jira/setenv.sh.erb'),
    mode    => '0755',
    require => Class['jira::install'],
  }
  
  if "${jira::params::db}" == 'postgresql' {
    file { "${jira::params::homedir}/dbconfig.xml":
      content => template('jira/dbconfig.postgres.xml.erb'),
      mode    => '0600',
      require => [Class['jira::install'],Exec['mkdirp-homedir-jira']],
    }
  }
  if "${jira::params::db}" == 'mysql' {
    file { "${jira::params::homedir}/dbconfig.xml":
      content => template('jira/dbconfig.mysql.xml.erb'),
      mode    => '0600',
      require => [Class['jira::install'],Exec['mkdirp-homedir-jira']],
    }
  }
}