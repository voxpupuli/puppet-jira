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
#
# @author Bryce Johnson, Merritt Krakowitzer, Vox Pupuli
# @param version
#   The JIRA version to install or upgrade to. Changing this will trigger a restart
# @param product
#   Atlassian product to install.
# @param installdir
#   The directory in which JIRA software packages will be extracted
# @param homedir
#   The directory for JIRA's runtime data that persists between versions.
# @param manage_user
#   Whether to manage the service user
# @param user
#   User that the service will run as
# @param group
#   Group that the service will run as
# @param installdir_owner
#   The owner of the installation directory.
# @param installdir_group
#   The group of the installation directory.
# @param installdir_mode
#   The permissions of the installation directory. Note that the JIRA service user must have at least execute permission on the directory.
# @param homedir_mode
#   The permissions of the service user's home directory, where JIRA's data will reside
# @param uid
#   The desired UID for the service user
# @param gid
#   The desired GID for the service group
# @param shell
#   The shell of the service user
# @param enable_secure_admin_sessions
#   Enables secure administrator sessions
# @param jira_config_properties
#   Allows configuring advanced JIRA properties as a key-value hash.
#   See https://confluence.atlassian.com/adminjiraserver0813/advanced-jira-application-configuration-1027138631.html
# @param datacenter
#   Set to true to enable clustered mode (JIRA Datacenter)
# @param shared_homedir
#   Shared data directory for all JIRA instances in a cluster
# @param ehcache_listener_host
#   EHCache configuration for clustered mode
# @param ehcache_listener_port
#   EHCache configuration for clustered mode
# @param ehcache_object_port
#   EHCache configuration for clustered mode
# @param use_jndi_ds
#   If true, the database will be configured as JNDI datasource in server.xml and then referenced in dbconfig.xml
# @param jndi_ds_name
#   Configures the JNDI datasource name
# @param db
#   The kind of database to use.
# @param dbname
#   The database name to connect to
# @param dbuser
#   Database username
# @param dbpassword
#   Database password
# @param dbserver
#   Database host DNS name or IP address
# @param dbport
#   The database port. Default depends on `$db`
# @param dbtype
#   The database type. Default depends on `$db`
# @param dbdriver
#   The database driver class. Default depends on `$db`
# @param dbschema
#   The database schema, if applicable. Defaults to 'public' with PostgreSQL
# @param dburl
#   Set this if you wish to use a custom database URL
# @param connection_settings
#   Configures additional JDBC connection properties in dbconfig.xml
#   For PostgreSQL, a default value of "tcpKeepAlive=true;socketTimeout=240" will be used
#   See https://confluence.atlassian.com/jirakb/connection-problems-to-postgresql-result-in-stuck-threads-in-jira-1047534091.html
# @param oracle_use_sid
#   Affects the database URL format for Oracle depending on whether you connect via a SID or a service name
# @param mysql_connector_manage
#   If true, the module will download and install the MySQL connector for JDBC
# @param mysql_connector_version
#   Version of the connector to install
# @param mysql_connector_product
#   Determines the filename for the download
# @param mysql_connector_install
#   Directory in which the connector will be installed
# @param mysql_connector_format
#   Format of the downloaded package
# @param mysql_connector_url
#   Source for the connector
# @param pool_min_size
#   Configures pool-min-size in dbconfig.xml
# @param pool_max_size
#   Configures pool-max-size in dbconfig.xml
# @param pool_max_wait
#   Configures pool-max-wait in dbconfig.xml
# @param validation_query
#   Configures validation_query in dbconfig.xml
# @param validation_query_timeout
#   Configures validation_query_timeout in dbconfig.xml
# @param min_evictable_idle_time
#   Configures min-evictable-idle-time-millis in dbconfig.xml
# @param time_between_eviction_runs
#   Configures time-between-eviction-runs-millis in dbconfig.xml
# @param pool_max_idle
#   Configures pool-max-idle in dbconfig.xml
# @param pool_remove_abandoned
#   Configures pool-remove-abandoned in dbconfig.xml
# @param pool_remove_abandoned_timeout
#   Configures pool-remove-abandoned-timeout in dbconfig.xml
# @param pool_test_while_idle
#   Configures pool-test-while-idle in dbconfig.xml
# @param pool_test_on_borrow
#   Configures pool-test-on-borrow in dbconfig.xml
# @param java_package
#   If defined, the module will install this package before installing JIRA.
# @param javahome
#   The location of an installed JVM. Must be set even if you specify java_package
# @param jvm_type
#   The type of JVM to use. Affects some defaults for the arguments below
# @param jvm_xms
#   Java -Xms parameter
# @param jvm_xmx
#   Java -Xmx parameter
# @param java_opts
#   Configures JVM_SUPPORT_RECOMMENDED_ARGS in setenv.sh. This is the preferred option to override.
# @param jvm_gc_args
#   Configures JVM_GC_ARGS in setenv.sh
# @param jvm_code_cache_args
#   Configures JVM_CODE_CACHE_ARGS in setenv.sh
# @param jvm_extra_args
#   Configures JVM_EXTRA_ARGS in setenv.sh
# @param jvm_nofiles_limit
#   Set the limit for open files
# @param download_url
#   Base URL for downloading Atlassian software
# @param checksum
#   Optional checksum to verify the downloaded package
# @param disable_notifications
#   Configures JIRA to disable e-mail handlers
# @param proxy_server
#   Configures the proxy server to use for downloads
# @param proxy_type
#   Configures the proxy type
# @param service_manage
#   Whether to manage the jira service
# @param service_ensure
#   Service state to ensure
# @param service_enable
#   Whether to enable the service on boot
# @param service_notify
#   Service notify parameter
# @param service_subscribe
#   Service subscribe parameter
# @param stop_jira
#   The command used to stop jira prior to upgrades. You can override this if you use an external too l to manage the jira service. Must return either 0 or 5 for success
# @param script_check_java_manage
#   undocumented
# @param script_check_java_template
#   undocumented
# @param tomcat_address
#   Tomcat bind address
# @param tomcat_port
#   Tomcat bind port
# @param tomcat_shutdown_port
#   Tomcat shutdown command port
# @param tomcat_max_http_header_size
#   Tomcat connector setting
# @param tomcat_min_spare_threads
#   Tomcat connector setting
# @param tomcat_connection_timeout
#   Tomcat connector setting
# @param tomcat_enable_lookups
#   Tomcat connector setting
# @param tomcat_native_ssl
#   Enables a native SSL connector
# @param tomcat_https_port
#   Tomcat port for the native SSL connector
# @param tomcat_redirect_https_port
#   Specify which port to redirect internally when using port redirection from 80 to 8080 and
#   from 443 to 8443 or with proxy server in front, defaults to $tomcat_https_port. To be used
#   with tomcat_native_ssl.
# @param tomcat_protocol
#   Tomcat connector setting
# @param tomcat_protocol_ssl
#   Tomcat connector setting
# @param tomcat_use_body_encoding_for_uri
#   Tomcat connector setting
# @param tomcat_disable_upload_timeout
#   Tomcat connector setting
# @param tomcat_key_alias
#   Key alias in the keystore for the SSL connector
# @param tomcat_keystore_file
#   Path to a Java keystore for the SSL connector
# @param tomcat_keystore_pass
#   Keystore passphrase
# @param tomcat_keystore_type
#   Keystore type
# @param tomcat_accesslog_format
#   Format string for Tomcat access log
# @param tomcat_accesslog_enable_xforwarded_for
#   Configures tomcat to respect X-Forwarded-For and X-Forwarded-By headers
#   If a proxy operates before JIRA, the access logs will only contain the IP addresses of the proxy
#   instead of the address of the user. With `X-Forwarded-For` the proxy can forward the users IP
#   address to the JIRA application server so that it can be logged correctly.
# @param tomcat_max_threads
#   Tomcat connector setting
# @param tomcat_accept_count
#   Tomcat connector setting
# @param proxy
#   Hash of additional settings to configure on the connectors.
#   The confusing naming is retained for backwards compatibility
# @param ajp
#   Properties for an AJP connector
# @param tomcat_default_connector
#   If set to false, the default connector will be omitted
# @param tomcat_additional_connectors
#   Well-formed, complex Hash where each key represents a port number and the key's
#   value is a hash whose key/value pairs represent the attributes and their values
#   that define the connector's behaviour. Default is `{}`.
#
#   Use this parameter to specify arbitrary, additional connectors with arbitrary
#   attributes. There are no defaults here, so you must take care to specify all
#   attributes a connector requires to work in Jira. See below for examples.
#
#   This is useful if you need to access your Jira instance directly through an
#   additional HTTP port, e.g. one that is not configured for reverse proxy use.
#   Atlassian describes use cases for this in
#   https://confluence.atlassian.com/kb/how-to-create-an-unproxied-application-link-719095740.html
#   and
#   https://confluence.atlassian.com/kb/how-to-bypass-a-reverse-proxy-or-ssl-in-application-links-719095724.html
# @param contextpath
#   Tomcat context path for the web service
# @param resources
#   undocumented
# @param enable_sso
#   Enable single sign-on via Crowd
# @param application_name
#   Crowd application name
# @param application_password
#   Crowd application password
# @param application_login_url
#   Crowd application login URL
# @param crowd_server_url
#   Crowd server URL
# @param crowd_base_url
#   Crowd base URL
# @param session_isauthenticated
#   undocumented SSO parameter
# @param session_tokenkey
#   undocumented SSO parameter
# @param session_validationinterval
#   undocumented SSO parameter
# @param session_lastvalidation
#   undocumented SSO parameter
# @param plugins
#   an array of hashes defining custom plugins to install
#   a single plugin configuration will has the following form
#     installation_name: this name wil be used to install the plugin within jira
#     source: url of plugin to be fetched
#     username: the username for authentification, if necessary
#     password: the password for authentification, if necessary
#     checksum: the checksum of the plugin, to determine the need for an upgrade
#     checksumtype: the type of checksum used (none|md5|sha1|sha2|sha256|sha384|sha512). (default: none)
# @param jvm_permgen
#   Deprecated. Exists to notify users that they're trying to configure a parameter that has no effect
# @param poolsize
#   Deprecated alias for `$pool_max_size`.
# @param enable_connection_pooling
#   Deprecated. Has no effect.
# @summary Downloads and installs Atlassian JIRA
class jira (

  # Jira Settings
  String $version                                                   = '8.13.5',
  String[1] $product                                                = 'jira',
  Stdlib::Absolutepath $installdir                                  = '/opt/jira',
  Stdlib::Absolutepath $homedir                                     = '/home/jira',
  Boolean $manage_user                                              = true,
  String $user                                                      = 'jira',
  String $group                                                     = 'jira',
  String[1] $installdir_owner                                       = 'root',
  String[1] $installdir_group                                       = 'root',
  Stdlib::Filemode $installdir_mode                                 = '0755',
  Optional[Stdlib::Filemode] $homedir_mode                          = undef,
  Optional[Integer[0]] $uid                                         = undef,
  Optional[Integer[0]] $gid                                         = undef,
  Stdlib::Absolutepath $shell                                       = '/bin/true',
  # Advanced configuration options
  Boolean $enable_secure_admin_sessions                             = true,
  Hash $jira_config_properties                                      = {},
  Boolean $datacenter                                               = false,
  Optional[Stdlib::AbsolutePath] $shared_homedir                    = undef,
  Optional[Stdlib::Host] $ehcache_listener_host                     = undef,
  Optional[Stdlib::Port] $ehcache_listener_port                     = undef,
  Optional[Stdlib::Port] $ehcache_object_port                       = undef,
  # Database Settings
  Boolean $use_jndi_ds                                              = false,
  String[1] $jndi_ds_name                                           = 'JiraDS',
  Enum['postgresql','mysql','sqlserver','oracle','h2'] $db          = 'postgresql',
  String $dbuser                                                    = 'jiraadm',
  String $dbpassword                                                = 'mypassword',
  String $dbserver                                                  = 'localhost',
  String $dbname                                                    = 'jira',
  Optional[Variant[Integer,String]] $dbport                         = undef,
  Optional[String] $dbdriver                                        = undef,
  Optional[String] $dbtype                                          = undef,
  Optional[String] $dburl                                           = undef,
  Optional[String] $connection_settings                             = undef,
  Boolean $oracle_use_sid                                           = true,
  Optional[String[1]] $dbschema                                     = undef,
  # MySQL Connector Settings
  Boolean $mysql_connector_manage                                   = true,
  String $mysql_connector_version                                   = '8.0.23',
  String $mysql_connector_product                                   = 'mysql-connector-java',
  String $mysql_connector_format                                    = 'tar.gz',
  Stdlib::Absolutepath $mysql_connector_install                     = '/opt/MySQL-connector',
  Stdlib::HTTPUrl $mysql_connector_url                              = 'https://dev.mysql.com/get/Downloads/Connector-J',
  Optional[Integer[0]] $pool_min_size                               = undef,
  Optional[Integer[0]] $pool_max_size                               = undef,
  Optional[Integer[-1]] $pool_max_wait                              = undef,
  Optional[String] $validation_query                                = undef,
  Optional[Integer[0]] $validation_query_timeout                    = undef,
  Optional[Integer[0]] $min_evictable_idle_time                     = undef,
  Optional[Integer[0]] $time_between_eviction_runs                  = undef,
  Optional[Integer[0]] $pool_max_idle                               = undef,
  Optional[Boolean] $pool_remove_abandoned                          = undef,
  Optional[Integer[0]]  $pool_remove_abandoned_timeout              = undef,
  Optional[Boolean] $pool_test_while_idle                           = undef,
  Optional[Boolean] $pool_test_on_borrow                            = undef,
  # JVM Settings
  Optional[String[1]] $java_package                                 = undef,
  Optional[Stdlib::AbsolutePath] $javahome                          = undef,
  Jira::Jvm_types $jvm_type                                         = 'openjdk-11',
  String $jvm_xms                                                   = '256m',
  String $jvm_xmx                                                   = '1024m',
  Optional[String] $java_opts                                       = undef,
  Optional[String] $jvm_gc_args                                     = undef,
  Optional[String] $jvm_code_cache_args                             = undef,
  Optional[String] $jvm_extra_args                                  = undef,
  Integer $jvm_nofiles_limit                                        = 16384,
  # Misc Settings
  Stdlib::HTTPUrl $download_url                                     = 'https://product-downloads.atlassian.com/software/jira/downloads',
  Optional[String] $checksum                                        = undef,
  Boolean $disable_notifications                                    = false,
  Optional[String] $proxy_server                                    = undef,
  Optional[Enum['none','http','https','ftp']] $proxy_type           = undef,
  # Manage service
  Boolean $service_manage                                           = true,
  Stdlib::Ensure::Service $service_ensure                           = 'running',
  Boolean $service_enable                                           = true,
  $service_notify                                                   = undef,
  $service_subscribe                                                = undef,
  # Command to stop jira in preparation to upgrade. This is configurable
  # in case the jira service is managed outside of puppet. eg: using the
  # puppetlabs-corosync module: 'crm resource stop jira && sleep 15'
  # Note: the command should return either 0 or 5 when the service doesn't exist
  String $stop_jira                                                 = 'systemctl stop jira.service && sleep 15',
  # Whether to manage the 'check-java.sh' script, and where to retrieve
  # the script from.
  Boolean $script_check_java_manage                                 = false,
  String $script_check_java_template                                = 'jira/check-java.sh.erb',
  # Tomcat
  Optional[String] $tomcat_address                                  = undef,
  Stdlib::Port $tomcat_port                                         = 8080,
  Stdlib::Port $tomcat_shutdown_port                                = 8005,
  Integer $tomcat_max_http_header_size                              = 8192,
  Integer[0] $tomcat_min_spare_threads                              = 25,
  Integer[0] $tomcat_connection_timeout                             = 20000,
  Boolean $tomcat_enable_lookups                                    = false,
  Boolean $tomcat_native_ssl                                        = false,
  Stdlib::Port $tomcat_https_port                                   = 8443,
  Optional[Stdlib::Port] $tomcat_redirect_https_port                = undef,
  String $tomcat_protocol                                           = 'HTTP/1.1',
  Optional[String] $tomcat_protocol_ssl                             = undef,
  Boolean $tomcat_use_body_encoding_for_uri                         = true,
  Boolean $tomcat_disable_upload_timeout                            = true,
  String $tomcat_key_alias                                          = 'jira',
  Stdlib::Absolutepath $tomcat_keystore_file                        = '/home/jira/jira.jks',
  String $tomcat_keystore_pass                                      = 'changeit',
  Enum['JKS', 'JCEKS', 'PKCS12'] $tomcat_keystore_type              = 'JKS',
  String $tomcat_accesslog_format                                   = '%a %{jira.request.id}r %{jira.request.username}r %t &quot;%m %U%q %H&quot; %s %b %D &quot;%{Referer}i&quot; &quot;%{User-Agent}i&quot; &quot;%{jira.request.assession.id}r&quot;',
  Boolean $tomcat_accesslog_enable_xforwarded_for                   = false,
  # Tomcat Tunables
  Integer $tomcat_max_threads                                       = 150,
  Integer $tomcat_accept_count                                      = 100,
  # Reverse https proxy
  Hash $proxy                                                       = {},
  # Options for the AJP connector
  Hash $ajp                                                         = {},
  Boolean $tomcat_default_connector                                 = true,
  # Additional connectors in server.xml
  Jira::Tomcat_connectors $tomcat_additional_connectors             = {},
  # Context path (usualy used in combination with a reverse proxy)
  Optional[String[1]] $contextpath                                  = undef,
  # Resources for context.xml
  Hash $resources                                                   = {},
  # Enable SingleSignOn via Crowd
  Boolean $enable_sso                                               = false,
  String $application_name                                          = 'crowd',
  String $application_password                                      = '1234',
  Variant[Stdlib::HTTPUrl, Stdlib::HTTPSUrl] $application_login_url = 'https://crowd.example.com/console/',
  Variant[Stdlib::HTTPUrl, Stdlib::HTTPSUrl] $crowd_server_url      = 'https://crowd.example.com/services/',
  Variant[Stdlib::HTTPUrl, Stdlib::HTTPSUrl] $crowd_base_url        = 'https://crowd.example.com/',
  String $session_isauthenticated                                   = 'session.isauthenticated',
  String $session_tokenkey                                          = 'session.tokenkey',
  Integer $session_validationinterval                               = 5,
  String $session_lastvalidation                                    = 'session.lastvalidation',
  # Deprecated parameters
  Optional[String] $jvm_permgen                                     = undef,
  Optional[Integer[0]] $poolsize                                    = undef,
  Optional[Boolean] $enable_connection_pooling                      = undef,
  # plugin installation
  Array[Hash] $plugins                                              = [],
) {
  # To maintain compatibility with previous behaviour, we check for not-servicedesk instead of specifying the
  if $product != 'servicedesk' and versioncmp($jira::version, '8.0.0') < 0 {
    fail('JIRA versions older than 8.0.0 are no longer supported. Please use an older version of this module to upgrade first.')
  }
  if $product == 'servicedesk' and versioncmp($jira::version, '4.10.0') < 0 {
    fail('JIRA servicedesk versions older than 4.10.0 are no longer supported. Please use an older version of this module to upgrade first.')
  }

  if $datacenter and !$shared_homedir {
    fail("\$shared_homedir must be set when \$datacenter is true")
  }

  if $jvm_permgen {
    fail('jira::jvm_permgen', 'jira::jvm_permgen has been removed and no longer does anything. Configuring it hasn\'t been supported since JDK 8')
  }

  if $enable_connection_pooling != undef {
    deprecation('jira::enable_connection_pooling', 'jira::enable_connection_pooling has been removed and does nothing. Please simply configure the connection pooling parameters')
  }

  if $tomcat_redirect_https_port {
    unless ($tomcat_native_ssl) {
      fail('You need to set native_ssl to true when using tomcat_redirect_https_port')
    }
  }

  # The default Jira product starting with version 7 is 'jira-software',
  # but some old configuration may explicitly specify 'jira'
  if $product == 'jira' {
    $product_name = 'jira-software'
  } else {
    $product_name = $product
  }

  $webappdir = "${installdir}/atlassian-${product_name}-${version}-standalone"

  if ! empty($ajp) {
    if ! ('port' in $ajp) {
      fail('You need to specify a valid port for the AJP connector.')
    } else {
      assert_type(Variant[Pattern[/^\d+$/], Stdlib::Port], $ajp['port'])
    }
    if ! ('protocol' in $ajp) {
      fail('You need to specify a valid protocol for the AJP connector.')
    } else {
      assert_type(Enum['AJP/1.3', 'org.apache.coyote.ajp', 'org.apache.coyote.ajp.AjpNioProtocol'], $ajp['protocol'])
    }
  }

  if $javahome == undef {
    fail('You need to specify a value for javahome')
  }

  contain jira::install
  contain jira::config
  contain jira::service

  Class['jira::install']
  -> Class['jira::config']
  ~> Class['jira::service']

  if ($enable_sso) {
    class { 'jira::sso': }
  }

  # install any given library or remove them
  $plugins.each |Hash $plugin_data| {
    $target = "${jira::webappdir}/atlassian-jira/WEB-INF/lib/${$plugin_data['installation_name']}"
    if  $plugin_data['ensure'] == 'absent' {
      archive {
        $target:
          ensure        => 'absent',
      }
    } else {
      $_target_defaults = {
        ensure        => 'present',
        source        => $plugin_data['source'],
        checksum      => $plugin_data['checksum'],
        checksum_type => $plugin_data['checksum_type'],
      }
      $_username = !empty($plugin_data['username']) ? {
        default => {},
        true    => { username => $plugin_data['username'] }
      }
      $_password = !empty($plugin_data['password']) ? {
        default => {},
        true    => { password => $plugin_data['password'] },
      }
      $_plugin_archive = {
        $target => $_target_defaults + $_username + $_password,
      }
      create_resources(archive, $_plugin_archive)
    }
  }
}
