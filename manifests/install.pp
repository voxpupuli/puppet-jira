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

  require jira

  deploy::file { "atlassian-${jira::product}-${jira::version}.${jira::format}":
    target  => "${jira::installdir}/atlassian-${jira::product}-${jira::version}-standalone",
    url     => $jira::downloadURL,
    strip   => true,
    notify  => Exec["chown_${jira::webappdir}"],
  } ->

  user { $jira::user:
    comment          => 'Jira daemon account',
    shell            => '/bin/true',
    home             => $jira::homedir,
    password         => '*',
    password_min_age => '0',
    password_max_age => '99999',
    managehome       => true,
  } ->

  file { $jira::homedir:
    ensure  => 'directory',
    owner   => $jira::user,
    group   => $jira::group,
    recurse => true,
  } ->

  exec { "chown_${jira::webappdir}":
    command     => "/bin/chown -R ${jira::user}:${jira::group} ${jira::webappdir}",
    refreshonly => true,
    subscribe   => User[$jira::user]
  } ->

  file { '/etc/init.d/jira':
    content => template('jira/etc/rc.d/init.d/jira.erb'),
    mode    => '0755',
  }

}
