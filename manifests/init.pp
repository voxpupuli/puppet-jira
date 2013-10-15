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
# == Class: jira
#
# This module is used to install Jira.
# I have tested it with version 6.0 and upgarded to 6.0.1 succesfully.
#
# This module requires mkrakowitzer-deploy
#
# === Parameters
#
# See jira.yaml for a complete list of parameters
#
# === Examples
#
#  class { 'jira':
#    version     => '6.0.1',
#    installdir  => '/opt/atlassian/atlassian-jira',
#    homedir     => '/opt/atlassian/atlassian-jira/jira-home',
#    user        => 'jira',
#    group       => 'jira',
#    dbpassword  => 'mysecret',
#    dbserver    => 'devecodb1',
#    javahome    => '/opt/development-tools/java/jdk1.7.0_21/',
#    downloadURL  => 'http://myurl/pub/software/atlassian/',
#  }
#
# === Authors
#
# Bryce Johnson
# Merritt Krakowitzer
#
# === Copyright
#
# Copyright (c) 2012 Bryce Johnson
#
# Published under the Apache License, Version 2.0
#
class jira (

  # Jira Settings
  $version      = '6.0',
  $product      = 'jira',
  $format       = 'tar.gz',
  $installdir   = '/opt/jira',
  $homedir      = '/home/jira',
  $user         = 'root',
  $group        = 'root',

  # Database Settings
  $db           = 'postgresql',
  $dbuser       = 'jiraadm',
  $dbpassword   = 'mypassword',
  $dbserver     = 'localhost',
  $dbname       = 'jira',
  $dbport       = '5432',
  $dbdriver     = 'org.postgresql.Driver',
  $dbtype       = 'postgres72',
  $poolsize     = '15',

  # JVM Settings
  $javahome,
  $jvm_xmx      = '1024m',
  $jvm_optional = '-XX:-HeapDumpOnOutOfMemoryError',

  # Misc Settings
  $downloadURL  = 'http://www.atlassian.com/software/jira/downloads/binary/',

) {

  $webappdir    = "${installdir}/atlassian-${product}-${version}-standalone"
  $dburl        = "jdbc:${db}://${dbserver}:${dbport}/${dbname}"

  include jira::install
  include jira::config
  include jira::service

}
