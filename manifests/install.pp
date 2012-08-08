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
class jira::install {

  require jira::params

  case $::osfamily {
    'Darwin' : { # assuming you did download wget - ill maybe fix this and check for it
      exec { 'wget-jira-package':
        cwd     => "${jira::params::tmpdir}",
        command => "${jira::params::cmdwget} --no-check-certificate ${jira::params::downloadURL}",
        creates => "${jira::params::tmpdir}/atlassian-${jira::params::product}-${jira::params::version}.${jira::params::format}",
      }
    }
    default : {
      exec { 'wget-jira-package':
        cwd     => "${jira::params::tmpdir}",
        command => "${jira::params::cmdwget} --no-check-certificate ${jira::params::downloadURL}",
        creates => "${jira::params::tmpdir}/atlassian-${jira::params::product}-${jira::params::version}.${jira::params::format}",
      }
    }
  }

  exec { 'mkdirp-installdir':
    cwd     => "${jira::params::tmpdir}",
    command => "/bin/mkdir -p ${jira::params::installdir}",
    creates => "${jira::params::installdir}",
  }
  exec { 'unzip-jira-package':
    cwd     => "${jira::params::installdir}",
    command => "/usr/bin/unzip -o -d ${jira::params::installdir} ${jira::params::tmpdir}/atlassian-${jira::params::product}-${jira::params::version}.${jira::params::format}",
    creates => "${jira::params::webappdir}",
    require => [Exec['wget-jira-package'],Exec['mkdirp-installdir']],
  }

  file { '/etc/rc.d/init.d/jira':
    content => template('jira/etc/rc.d/init.d/jira.erb'),
    mode    => '0755',
  }
}
