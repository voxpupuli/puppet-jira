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
# == Class: jira
#
# This module is used to install Jira.
#
# See README.md for more details
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
  $version      = '6.4.1',
  $product      = 'jira',
  $format       = 'tar.gz',
  $installdir   = '/opt/jira',
  $homedir      = '/home/jira',
  $user         = 'jira',
  $group        = 'jira',
  $uid          = undef,
  $gid          = undef,
  $shell        = '/bin/true',

  # Database Settings
  $db                      = 'postgresql',
  $dbuser                  = 'jiraadm',
  $dbpassword              = 'mypassword',
  $dbserver                = 'localhost',
  $dbname                  = 'jira',
  $dbport                  = '5432',
  $dbdriver                = 'org.postgresql.Driver',
  $dbtype                  = 'postgres72',
  $dburl                   = undef,
  $poolsize                = '20',

  # MySQL Connector Settings
  $mysql_connector_manage  = true,
  $mysql_connector_version = '5.1.34',
  $mysql_connector_product = 'mysql-connector-java',
  $mysql_connector_format  = 'tar.gz',
  $mysql_connector_install = '/opt/MySQL-connector',
  $mysql_connector_URL     = 'https://dev.mysql.com/get/Downloads/Connector-J',

  # Configure database settings if you are pooling connections
  $enable_connection_pooling = false,
  $poolMinSize               = 20,
  $poolMaxSize               = 20,
  $poolMaxWait               = 30000,
  $validationQuery           = undef,
  $minEvictableIdleTime      = 60000,
  $timeBetweenEvictionRuns   = undef,
  $poolMaxIdle               = 20,
  $poolRemoveAbandoned       = true,
  $poolRemoveAbandonedTimout = 300,
  $poolTestWhileIdle         = true,
  $poolTestOnBorrow          = true,

  # JVM Settings
  $javahome,
  $jvm_xms      = '256m',
  $jvm_xmx      = '1024m',
  $jvm_permgen  = '256m',
  $jvm_optional = '-XX:-HeapDumpOnOutOfMemoryError',
  $java_opts    = '',

  # Misc Settings
  $downloadURL           = 'http://www.atlassian.com/software/jira/downloads/binary/',
  $disable_notifications = false,

  # Choose whether to use nanliu-staging, or mkrakowitzer-deploy
  # Defaults to nanliu-staging as it is puppetlabs approved.
  $staging_or_deploy = 'staging',

  # Manage service
  $service_manage = true,
  $service_ensure = running,
  $service_enable = true,
  $service_notify = undef,
  $service_subscribe = undef,
  # Command to stop jira in preparation to updgrade. This is configurable
  # incase the jira service is managed outside of puppet. eg: using the
  # puppetlabs-corosync module: 'crm resource stop jira && sleep 15'
  $stop_jira = 'service jira stop && sleep 15',

  # Tomcat
  $tomcatAddress               = undef,
  $tomcatPort                  = 8080,
  $tomcatMaxHttpHeaderSize     = '8192',
  $tomcatMinSpareThreads       = '25',
  $tomcatConnectionTimeout     = '20000',
  $tomcatEnableLookups         = false,
  $tomcatNativeSsl             = false,
  $tomcatHttpsPort             = 8443,
  $tomcatProtocol              = 'HTTP/1.1',
  $tomcatUseBodyEncodingForURI = true,
  $tomcatDisableUploadTimeout  = true,
  $tomcatKeyAlias              = 'jira',
  $tomcatKeystoreFile          = '/home/jira/jira.jks',
  $tomcatKeystorePass          = 'changeit',
  $tomcatKeystoreType          = 'JKS',

  # Tomcat Tunables
  $tomcatMaxThreads  = '150',
  $tomcatAcceptCount = '100',
  
  # Reverse https proxy
  $proxy = {},
  # Options for the AJP connector
  $ajp   = {},
  # Context path (usualy used in combination with a reverse proxy)
  $contextpath = '',

  # Resources for context.xml
  $resources = {},

) inherits jira::params {

  # Parameter validations
  validate_re($db, ['^postgresql','^mysql','^sqlserver','^oracle'], 'The JIRA $db parameter must be "postgresql", "mysql", "sqlserver".')
  validate_hash($proxy)
  validate_re($contextpath, ['^$', '^/.*'])
  validate_hash($resources)
  validate_hash($ajp)
  validate_bool($tomcatNativeSsl)
  validate_absolute_path($tomcatKeystoreFile)
  validate_re($tomcatKeystoreType, '^(JKS|JCEKS|PKCS12)$')

  if defined('$::jira_version') {
    # If the running version of JIRA is less than the expected version of JIRA
    # Shut it down in preparation for upgrade.
    if versioncmp($version, $::jira_version) > 0 {
      notify { 'Attempting to upgrade JIRA': }
      exec { $stop_jira: before => Anchor['jira::start'] }
    }
  }

  $webappdir    = "${installdir}/atlassian-${product}-${version}-standalone"
  if $dburl {
    $dburl_real = $dburl
  }
  else {
    $dburl_real = $db ? {
      'postgresql' => "jdbc:${db}://${dbserver}:${dbport}/${dbname}",
      'mysql'      => "jdbc:${db}://${dbserver}:${dbport}/${dbname}?useUnicode=true&amp;characterEncoding=UTF8&amp;sessionVariables=storage_engine=InnoDB",
      'oracle'     => "jdbc:${db}:thin:@${dbserver}:${dbport}:${dbname}",
      'sqlserver'  => "jdbc:jtds:${db}://${dbserver}:${dbport}/${dbname}"
    }
  }

  if ! empty($ajp) {
    if ! has_key($ajp, 'port') {
      fail('You need to specify a valid port for the AJP connector.')
    } else {
      validate_re($ajp['port'], '^\d+$')
    }
    if ! has_key($ajp, 'protocol') {
      fail('You need to specify a valid protocol for the AJP connector.')
    } else {
      validate_re($ajp['protocol'], ['^AJP/1.3$', '^org.apache.coyote.ajp'])
    }
  }

  anchor { 'jira::start':
  } ->
  class { 'jira::install':
  } ->
  class { 'jira::config':
  } ~>
  class { 'jira::service':
  } ->
  anchor { 'jira::end': }

}
