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
class jira::service {

  service { 'jira':
    provider  => base,
    ensure    => 'running',
    start     => '/etc/init.d/jira start',
    restart   => '/etc/init.d/jira restart',
    stop      => '/etc/init.d/jira stop',
    status    => '/etc/init.d/jira status',
    require   => Class['jira::config'],
  }
}
  #status   => "pg_lsclusters -h | awk 'BEGIN {rc=0} {if (\$4 != \"online\") rc=3} END { exit rc }'",
#/opt/java/jdk1.6.0_33/bin/jps |grep Bootstrap  # but has high risk for any tomcadt
