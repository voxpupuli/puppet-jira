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

  # Advanced configuration options
  $enable_secure_admin_sessions = true,
  $jira_config_properties    = {},

  $datacenter   = false,
  $shared_homedir = undef,

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
  $dbschema                = 'public',

  # MySQL Connector Settings
  $mysql_connector_manage  = true,
  $mysql_connector_version = '5.1.34',
  $mysql_connector_product = 'mysql-connector-java',
  $mysql_connector_format  = 'tar.gz',
  $mysql_connector_install = '/opt/MySQL-connector',
  $mysql_connector_url     = 'https://dev.mysql.com/get/Downloads/Connector-J',

  # Configure database settings if you are pooling connections
  $enable_connection_pooling     = false,
  $pool_min_size                 = 20,
  $pool_max_size                 = 20,
  $pool_max_wait                 = 30000,
  $validation_query              = undef,
  $min_evictable_idle_time       = 60000,
  $time_between_eviction_runs    = undef,
  $pool_max_idle                 = 20,
  $pool_remove_abandoned         = true,
  $pool_remove_abandoned_timeout = 300,
  $pool_test_while_idle          = true,
  $pool_test_on_borrow           = false,

  # JVM Settings
  $javahome      = undef,
  $jvm_xms       = '256m',
  $jvm_xmx       = '1024m',
  $jvm_permgen   = '256m',
  $jvm_optional  = '-XX:-HeapDumpOnOutOfMemoryError',
  $java_opts     = '',
  $catalina_opts = '',

  # Misc Settings
  $download_url          = 'https://downloads.atlassian.com/software/jira/downloads/',
  $checksum              = undef,
  $disable_notifications = false,

  # Choose whether to use puppet-staging, or puppet-archive
  $deploy_module = 'archive',

  # Manage service
  $service_manage    = true,
  $service_ensure    = running,
  $service_enable    = true,
  $service_notify    = undef,
  $service_subscribe = undef,
  # Command to stop jira in preparation to updgrade. This is configurable
  # incase the jira service is managed outside of puppet. eg: using the
  # puppetlabs-corosync module: 'crm resource stop jira && sleep 15'
  $stop_jira = 'service jira stop && sleep 15',
  # Whether to manage the 'check-java.sh' script, and where to retrieve
  # the script from.
  $script_check_java_manage = false,
  $script_check_java_template = 'jira/check-java.sh.erb',

  # Tomcat
  $tomcat_address                   = undef,
  $tomcat_port                      = 8080,
  $tomcat_shutdown_port             = 8005,
  $tomcat_max_http_header_size      = '8192',
  $tomcat_min_spare_threads         = '25',
  $tomcat_connection_timeout        = '20000',
  $tomcat_enable_lookups            = false,
  $tomcat_native_ssl                = false,
  $tomcat_https_port                = 8443,
  $tomcat_redirect_https_port       = undef,
  $tomcat_protocol                  = 'HTTP/1.1',
  $tomcat_use_body_encoding_for_uri = true,
  $tomcat_disable_upload_timeout    = true,
  $tomcat_key_alias                 = 'jira',
  $tomcat_keystore_file             = '/home/jira/jira.jks',
  $tomcat_keystore_pass             = 'changeit',
  $tomcat_keystore_type             = 'JKS',
  $tomcat_accesslog_format          = '%a %{jira.request.id}r %{jira.request.username}r %t &quot;%m %U%q %H&quot; %s %b %D &quot;%{Referer}i&quot; &quot;%{User-Agent}i&quot; &quot;%{jira.request.assession.id}r&quot;',

  # Tomcat Tunables
  $tomcat_max_threads  = '150',
  $tomcat_accept_count = '100',

  # Reverse https proxy
  $proxy = {},
  # Options for the AJP connector
  $ajp   = {},
  # Context path (usualy used in combination with a reverse proxy)
  $contextpath = '',

  # Resources for context.xml
  $resources = {},

  # Enable SingleSignOn via Crowd

  $enable_sso = false,
  $application_name = 'crowd',
  $application_password = '1234',
  $application_login_url = 'https://crowd.example.com/console/',
  $crowd_server_url = 'https://crowd.example.com/services/',
  $crowd_base_url = 'https://crowd.example.com/',
  $session_isauthenticated = 'session.isauthenticated',
  $session_tokenkey = 'session.tokenkey',
  $session_validationinterval = 5,
  $session_lastvalidation = 'session.lastvalidation',

) inherits jira::params {

  # Parameter validations
  validate_re($db, ['^postgresql','^mysql','^sqlserver','^oracle'], 'The JIRA $db parameter must be "postgresql", "mysql", "sqlserver".')
  validate_hash($proxy)
  validate_re($contextpath, ['^$', '^/.*'])
  validate_hash($resources)
  validate_hash($ajp)
  validate_bool($tomcat_native_ssl)
  validate_absolute_path($tomcat_keystore_file)
  validate_re($tomcat_keystore_type, '^(JKS|JCEKS|PKCS12)$')

  if $datacenter and !$shared_homedir {
    fail("\$shared_homedir must be set when \$datacenter is true")
  }

  if $tomcat_redirect_https_port {
    validate_integer($tomcat_redirect_https_port)
    unless ($tomcat_native_ssl) {
        fail('You need to set native_ssl to true when using tomcat_redirect_https_port')
    }
  }

  # The default Jira product starting with version 7 is 'jira-software'
  if ((versioncmp($version, '7.0.0') > 0) and ($product == 'jira')) {
    $product_name = 'jira-software'
  } else {
    $product_name = $product
  }

  if defined('$::jira_version') {
    # If the running version of JIRA is less than the expected version of JIRA
    # Shut it down in preparation for upgrade.
    if versioncmp($version, $::jira_version) > 0 {
      notify { 'Attempting to upgrade JIRA': }
      exec { $stop_jira: before => Anchor['jira::start'] }
    }
  }

  $extractdir = "${installdir}/atlassian-${product_name}-${version}-standalone"
  if $format == zip {
    $webappdir = "${extractdir}/atlassian-${product_name}-${version}-standalone"
  } else {
    $webappdir = $extractdir
  }

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

  $merged_jira_config_properties = merge({'jira.websudo.is.disabled' => !$enable_secure_admin_sessions}, $jira_config_properties)

  if $javahome == undef {
    fail('You need to specify a value for javahome')
  }

  # Archive module checksum_verify = true; this verifies checksum if provided, doesn't if not.
  if $checksum == undef {
    $checksum_verify = false
  } else {
    $checksum_verify = true
  }


  anchor { 'jira::start': } ->
  class { '::jira::install': } ->
  class { '::jira::config': } ~>
  class { '::jira::service': } ->
  anchor { 'jira::end': }

  if ($enable_sso) {
    class { '::jira::sso': }
  }
}
