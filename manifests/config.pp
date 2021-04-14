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


  # This class should be used from init.pp with a dependency on jira::install
  # and sending a refresh to jira::service
  # We need to inherit jira because the templates use lots of @var
  assert_private()

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


  if $jira::java_opts {
    deprecation('jira::java_opts', 'jira::java_opts is deprecated. Please use jira::jvm_extra_args')
    $jvm_extra_args_real = "${jira::java_opts} ${jira::jvm_extra_args}"
  } else {
    $jvm_extra_args_real = $jira::jvm_extra_args
  }

  # Allow some backwards compatibility;
  if $jira::poolsize {
    deprecation('jira::poolsize', 'jira::poolsize is deprecated and simply sets max-pool-size. Please use jira::pool_max_size instead and remove this configuration')
    $pool_max_size_real = pick($jira::pool_max_size, $jira::poolsize)
  } else {
    $pool_max_size_real = $jira::pool_max_size
  }

  if $jira::tomcat_redirect_https_port {
    unless $jira::tomcat_native_ssl {
      fail('You need to set jira::tomcat_native_ssl to true when using jira::tomcat_redirect_https_port')
    }
  }

  if $jira::dbport {
    $dbport_real = $jira::dbport
  } else {
    $dbport_real = $jira::db ? {
      'postgresql' => '5432',
      'mysql'      => '3306',
      'oracle'     => '1521',
      'sqlserver'  => '1433',
      'h2'         => '',
    }
  }

  if $jira::dbdriver {
    $dbdriver_real = $jira::dbdriver
  } else {
    $dbdriver_real = $jira::db ? {
      'postgresql' => 'org.postgresql.Driver',
      'mysql'      => 'com.mysql.jdbc.Driver',
      'oracle'     => 'oracle.jdbc.OracleDriver',
      'sqlserver'  => 'com.microsoft.sqlserver.jdbc.SQLServerDriver',
      'h2'         => 'org.h2.Driver',
    }
  }

  if $jira::dbtype {
    $dbtype_real = $jira::dbtype
  } else {
    $dbtype_real = $jira::db ? {
      'postgresql' => 'postgres72',
      'mysql'      => 'mysql',
      'oracle'     => 'oracle10g',
      'sqlserver'  => 'mssql',
      'h2'         => 'h2',
    }
  }

  if $jira::dburl {
    $dburl_real = $jira::dburl
  }
  else {
    $dburl_real = $jira::db ? {
      'postgresql' => "jdbc:${jira::db}://${jira::dbserver}:${dbport_real}/${jira::dbname}",
      'mysql'      => "jdbc:${jira::db}://${jira::dbserver}:${dbport_real}/${jira::dbname}?useUnicode=true&amp;characterEncoding=UTF8&amp;sessionVariables=default_storage_engine=InnoDB",
      'oracle'     => "jdbc:${jira::db}:thin:@${jira::dbserver}:${dbport_real}:${jira::dbname}",
      'sqlserver'  => "jdbc:jtds:${jira::db}://${jira::dbserver}:${dbport_real}/${jira::dbname}",
      'h2'         => "jdbc:h2:file:/${jira::homedir}/database/${jira::dbname}",
    }
  }

  if $jira::tomcat_protocol_ssl {
    $tomcat_protocol_ssl_real = $jira::tomcat_protocol_ssl
  } else {
    if versioncmp($jira::version, '7.3.0') >= 0 {
      $tomcat_protocol_ssl_real = 'org.apache.coyote.http11.Http11NioProtocol'
    } else {
      $tomcat_protocol_ssl_real = 'org.apache.coyote.http11.Http11Protocol'
    }
  }

  $merged_jira_config_properties = merge({ 'jira.websudo.is.disabled' => !$jira::enable_secure_admin_sessions }, $jira::jira_config_properties)

  # Configuration logic ends, resources begin:

  file { "${jira::webappdir}/bin/user.sh":
    content => template('jira/user.sh.erb'),
    mode    => '0755',
  }

  file { "${jira::webappdir}/bin/setenv.sh":
    content => epp('jira/setenv.sh.epp'),
    mode    => '0755',
  }

  file { "${jira::homedir}/dbconfig.xml":
    content => epp('jira/dbconfig.xml.epp'),
    mode    => '0600',
  }

  if $jira::script_check_java_manage {
    file { "${jira::webappdir}/bin/check-java.sh":
      content => template($jira::script_check_java_template),
      mode    => '0755',
      require => File["${jira::webappdir}/bin/setenv.sh"],
    }
  }

  file { "${jira::webappdir}/conf/server.xml":
    content => template('jira/server.xml.erb'),
    mode    => '0600',
  }

  file { "${jira::webappdir}/conf/context.xml":
    content => template('jira/context.xml.erb'),
    mode    => '0600',
  }

  file { "${jira::homedir}/jira-config.properties":
    content => template('jira/jira-config.properties.erb'),
    mode    => '0600',
  }

  if $jira::datacenter {
    file { "${jira::homedir}/cluster.properties":
      content => template('jira/cluster.properties.erb'),
      mode    => '0600',
    }
  }
}
