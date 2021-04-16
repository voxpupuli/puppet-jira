# JIRA module for Puppet

[![Build Status](https://travis-ci.org/voxpupuli/puppet-jira.png?branch=master)](https://travis-ci.org/voxpupuli/puppet-jira)
[![Code Coverage](https://coveralls.io/repos/github/voxpupuli/puppet-jira/badge.svg?branch=master)](https://coveralls.io/github/voxpupuli/puppet-jira)
[![Puppet Forge](https://img.shields.io/puppetforge/v/puppet/jira.svg)](https://forge.puppetlabs.com/puppet/jira)
[![Puppet Forge - downloads](https://img.shields.io/puppetforge/dt/puppet/jira.svg)](https://forge.puppetlabs.com/puppet/jira)
[![Puppet Forge - endorsement](https://img.shields.io/puppetforge/e/puppet/jira.svg)](https://forge.puppetlabs.com/puppet/jira)
[![Puppet Forge - scores](https://img.shields.io/puppetforge/f/puppet/jira.svg)](https://forge.puppetlabs.com/puppet/jira)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with JIRA](#setup)
    * [JIRA Prerequisites](#JIRA-prerequisites)
    * [What JIRA affects](#what-JIRA-affects)
    * [Beginning with JIRA](#beginning-with-JIRA)
    * [Upgrades](#upgrades)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
6. [Limitations - OS compatibility, etc.](#limitations)
7. [Development - Guide for contributing to the module](#development)
8. [Testing - How to test the JIRA module](#testing)
9. [Contributors](#contributors)

## Overview

This module allows you to install, upgrade and manage Atlassian JIRA.

## Module Description

This module installs/upgrades Atlassian's Enterprise Issue Tracking and project
management tool. The JIRA module also manages the JIRA configuration files with
Puppet.

## Setup

### JIRA Prerequisites

* JIRA requires a Java Developers Kit (JDK) or Java Run-time Environment (JRE)
  platform to be installed on your server's operating system. Oracle JDK / JRE
  (formerly Sun JDK / JRE) versions 8 (and 11 since JIRA 8.2) are currently
  supported by Atlassian. OpenJDK version 8 (and 11 since JIRA 8.2) are supported
  as well - Atlassian recommends to use AdoptOpenJDK to get better support

* JIRA requires a relational database to store its issue data. This module
  currently supports PostgreSQL and MySQL and Oracle and Microsoft SQL Server.
  We suggest using puppetlabs-postgresql/puppetlabs-mysql modules to
  configure/manage the database. The module uses PostgreSQL as a default.

* Whilst not required, for production use we recommend using nginx/apache as a
  reverse proxy to JIRA. We suggest using the jfryman/nginx puppet module.

### What JIRA affects

If installing to an existing JIRA instance, it is your responsibility to backup
your database. We also recommend that you backup your JIRA home directory and
that you align your current JIRA version with the version you intend to use with
puppet JIRA module.

You must have your database setup with the account user that JIRA will use. This
can be done using the puppetlabs-postgresql and puppetlabs-mysql modules.

When using this module to upgrade JIRA, please make sure you have a database/JIRA
home backup.

When using MySQL, We call the jira::mysql_connector class to install the MySQL java
connector directory from mysql.com as per Atlassian's documented recommendations.

### Beginning with JIRA

This puppet module will automatically download the JIRA archive from Atlassian and
extracts it into /opt/jira/atlassian-jira-$version. The default JIRA home is
/home/jira.

If you would prefer to use Hiera then see jira.yaml file for available options.

#### Basic example

```puppet
  # Java 11 is managed externally and installed in /opt/java
  class { 'jira':
    javahome     => '/opt/java',
  }
```

The module can install a package for you using your OS's package manager.
Note that there's no smarts here. You need to set javahome correctly.

```puppet
  # this example works on RHEL
  class { 'jira':
    java_package  => 'java-11-openjdk-headless'
    javahome      => '/usr/lib/jvm/jre-11-opendjk/',
  }
```

#### Upgrades

##### Upgrades to JIRA

Jira can be upgraded by incrementing this version number. This will *STOP* the
running instance of Jira and attempt to upgrade. You should take caution when
doing large version upgrades. Always backup your database and your home directory.
The jira::facts class is required for upgrades.

```puppet
  class { 'jira':
    java_package  => 'java-11-openjdk-headless'
    javahome      => '/usr/lib/jvm/jre-11-opendjk/',
    version     => '8.16.0',
  }
  class { 'jira::facts': }
```


## Reference

### Classes

#### Public Classes

* `jira`: Main class, manages the installation and configuration of JIRA
* `jira::facts`: Enable external facts for running instance of JIRA. This class is
  required to handle upgrades of jira. As it is an external fact, we chose not to
  enable it by default.

#### Private Classes

* `jira::install`: Installs JIRA binaries
* `jira::config`: Modifies jira/tomcat configuration files
* `jira::service`: Manage the JIRA service.
* `jira::mysql_connector`: Install/Manage the MySQL Java connector

### Parameters

#### JIRA parameters

##### `$version`

Specifies the version of JIRA to install, defaults to latest available at time of
module upload to the forge. It is recommended to pin the version number to avoid
unnecessary upgrades of JIRA.

##### `$product`

Product name, defaults to jira

##### `$format`

The default file format of the JIRA install file, defaults to tar.gz

##### `$installdir`

The directory to install to, defaults to '/opt/jira'. Note that
any parent directories must exist.

##### `$homedir`

The default home directory of JIRA, defaults to '/home/jira'. Note that
any parent directories must exist.

##### `$user`

The user to run/install JIRA as, defaults to 'jira'

##### `$group`

The group to run/install JIRA as, defaults to 'jira'

##### `$uid`

The uid of the JIRA user, defaults to next available (undef)

##### `$gid`

The gid of the JIRA user, defaults to next available (undef)

##### `$shell`

The shell of the JIRA user, defaults to '/bin/true'

##### `$enable_secure_admin_sessions`

Enables or disables JIRA Secure Administrator Sessions, defaults to true

##### `$jira_config_properties = {}`

Override default values for advanced configuration. Default values are defined
in jpm.xml, see <https://confluence.atlassian.com/jira/advanced-jira-configuration-126006.html>
for details. Specify key/value pairs as a hash. Example:

```
jira_config_properties => {
      'ops.bar.group.size.opsbar-transitions' => '4',
}
```

##### `$datacenter`

Enables or disables clustering, defaults to false

##### `$shared_homedir`

The directory of the shared home directory, defaults to undef. When clustering
is enabled, this parameter is *required*.

#### Database parameters

##### `$db`

Which database to use for JIRA, defaults to 'postgresql'. Can be:
'postgresql', 'mysql', 'oracle', 'sqlserver', or 'h2'.

##### `$dbuser`

The default database user for JIRA, defaults to 'jiraadm'

##### `$dbpassword`

The password for the database user, defaults to 'mypassword'

##### `$dbserver`

The hostname of the database server, defaults to 'localhost'

##### `$dbname`

The name of the database, defaults to 'jira'. If using oracle this should be the
SID.

##### `$dbport`

The port of the database, defaults to an appropriate port for the $db:

| $db | DEFAULT |
|------|--------|
| postgresql | 5432 |
| mysql | 3306 |
| oracle | 1521 |
| sqlserver | 1443 |
| h2 | N/A |

##### `$dbdriver`

The database driver to use, defaults to an appropriate value for $db:

| $db | DEFAULT |
|------|--------|
| postgresql | org.postgresql.Driver |
| mysql | com.mysql.jdbc.Driver |
| oracle | oracle.jdbc.OracleDriver (*) |
| sqlserver | com.microsoft.sqlserver.jdbc.SQLServerDriver |
| h2 | org.h2.Driver |

(*) NOTE: You must add the Oracle JDBC Driver manually with recent versions of JIRA (for now).
See: https://confluence.atlassian.com/doc/database-jdbc-drivers-171742.html

##### `$dbtype`

Database type, defaults to an appropriate value for $db:

| $db | DEFAULT |
|------|--------|
| postgresql | postgresql72 |
| mysql | mysql |
| oracle | oracle10g |
| sqlserver | mssql |
| h2 | h2 |

NOTE: Atlassian only supports Oracle 11g/12g, even so this value should be as documented here.

##### `$dbschema`

Set the schema

The default value is 'public' for PostgreSQL, and undef for others

##### `$dburl`

This parameter is not required nor do we recommend setting it. However it can be
used to customize the database connection string.

##### `$pool_max_size`

Setting most of the advanced JDBC parameters is not required unless you want to tune JIRA
settings.

defaults to undef

##### `$pool_min_size`

defaults to undef

##### `$pool_max_wait`

defaults to undef

##### `$validation_query`

defaults to undef

##### `$min_evictable_idle_time`

defaults to undef

##### `$time_between_eviction_runs`

defaults to undef

##### `$pool_max_idle`

defaults to undef

##### `$pool_remove_abandoned`

defaults to undef

##### `$pool_remove_abandoned_timeout`

defaults to undef

##### `$pool_test_while_idle`

defaults to undef

##### `$pool_test_on_borrow`

defaults to undef

#### MySQL Java Connector parameters

##### `mysql_connector_manage`

Manage the MySQL Java Connector with the JIRA module, defaults to 'true'

##### `mysql_connector_version`

Specifies the version of  MySQL Java Connector you would like installed. Defaults
to '5.1.34',

##### `$mysql_connector_product`

Product name, defaults to 'mysql-connector-java'

##### `$mysql_connector_format`

The default file format of the MySQL Java Connector install file, defaults to tar.gz

##### `$mysql_connector_install`

Installation directory of the MySQL connector. Defaults to '/opt/MySQL-connector'

##### `$mysql_connector_url`

The URL used to download the MySQL Java Connector installation file.
Defaults to `http://cdn.mysql.com/Downloads/Connector-J`

#### JVM Java parameters

##### `$javahome`

The `JAVA_HOME` directory, defaults to undef. This is a *required* parameter

##### `$java_package`

If defined, the module will install this package before it runs the JIRA service.
Defaults to undef.

##### `$jvm_xms`

The initial memory allocation pool for a Java Virtual Machine.
defaults to '256m'

##### `$jvm_xmx`

Maximum memory allocation pool for a Java Virtual Machine.
defaults to '1024m'

##### `$jvm_type`

Choose your JVM type. Valid values are 'openjdk-11', 'oracle-jdk-1.8'
This setting affects various defaults in setenv.sh if the options aren't defined

##### `$java_opts`

defaults to ''. This sets `JVM_SUPPORT_RECOMMENDED_ARGS` in setenv.sh

##### `$jvm_gc_args`

This sets `JVM_GC_ARGS` in `setenv.sh`. Defaults to undef, meaning
the module makes a choice based on `jvm_type`

##### `$jvm_code_cache_args`

This sets `JVM_CODE_CACHE_ARGS` in `setenv.sh`. Defaults to undef, meaning
the module makes a choice based on `jvm_type`

##### `$jvm_extra_args`
This sets `JVM_EXTRA_ARGS` in `setenv.sh`. Defaults to undef, meaning
the module makes a choice based on `jvm_type`

##### `$catalina_opts`

defaults to ''

#### Miscellaneous parameters

##### `$download_url`

The URL used to download the JIRA installation file.
Defaults to `https://product-downloads.atlassian.com/software/jira/downloads/`

##### `checksum`

The md5 checksum of the archive file. Defaults to 'undef'

##### `$proxy_server`

Specify a proxy server, with port number if needed. ie: https://example.com:8080.
Defaults to 'undef'.

##### `$proxy_type`

Proxy server type (none|http|https|ftp). Defaults to 'undef'.

##### `$service_manage`

Manage the JIRA service, defaults to 'true'

##### `$service_ensure`

Manage the JIRA service, defaults to 'running'

##### `$service_enable`

Defaults to 'true'

##### `$service_subscribe`

Restart the jira service in response to this subscription

##### `$service_notify`

Notify other puppet resources to refresh after the jira service

##### `$stop_jira`

If the jira service is managed outside of puppet the stop_jira parameter can be
used to shut down jira for upgrades. Defaults to 'service jira stop && sleep 15'

##### `$proxy = {}`

Defaults to {}, See examples on how to use.

##### `$contextpath = ""`

Defaults to an empty string (""). Will add a path to the Tomcat Server Context.

##### `$script_check_java_manage`

Manages the 'check-java.sh' script provided by JIRA.

Defaults to 'false'.

##### `$script_check_java_template`

Alternate location to find the 'check-java.sh' script. Requires
`$script_check_java_manage = true`.

Defaults to 'jira/check-java.sh.erb'.

#### Tomcat parameters

##### `$tomcat_address`

IP address to listen on. Defaults to all addresses.

##### `$tomcat_port`

Port to listen on, defaults to '8080'

##### `$tomcat_max_threads`

Defaults to '150'

##### `$tomcat_accept_count`

Defaults to '100'

##### `$tomcat_native_ssl`

Enable https/ssl support. Defaults to 'false'. See <https://confluence.atlassian.com/display/JIRA/Running+JIRA+over+SSL+or+HTTPS>
for additional info. The java keystore can be managed with the puppetlabs-java\_ks
module or manually with
`keytool -genkey -alias jira -keyalg RSA -sigalg SHA256withRSA -keystore /home/jira/jira.ks`

##### `$tomcat_https_port`

https/ssl Port to listen on, defaults to 8443.

##### `$tomcat_redirect_https_port`

Specifiy Jira redirect https port when using port redirection 80->8080 and
443->8443 or proxy server in front, defaults to $tomcat_https_port. To be used
with tomcat_native_ssl.

##### `$tomcat_key_alias`

The alias name of the java keystore entry. Defaults to 'jira'.

##### `$tomcat_keystore_file`

Location of java keystore file. Defaults to '/home/jira/jira.jks'

##### `$tomcat_keystore_pass`

Password to access java keystore. Defaults to 'changeit'

##### `$tomcat_keystore_type`

Defaults to 'JKS'. Valid options are 'JKS', 'PKCS12', 'JCEKS'.

##### `$tomcat_additional_connectors`

Well-formed, complex Hash where each key represents a port number and the key's
value is a hash whose key/value pairs represent the attributes and their values
that define the connector's behaviour. Default is `{}`.

Use this parameter to specify arbitrary, additional connectors with arbitrary
attributes. There are no defaults here, so you must take care to specify all
attributes a connector requires to work in Jira. See below for examples.

This is useful if you need to access your Jira instance directly through an
additional HTTP port, e.g. one that is not configured for reverse proxy use.
Atlassian describes use cases for this in
https://confluence.atlassian.com/kb/how-to-create-an-unproxied-application-link-719095740.html
and
https://confluence.atlassian.com/kb/how-to-bypass-a-reverse-proxy-or-ssl-in-application-links-719095724.html

##### `$tomcat_accesslog_enable_xforwarded_for`

If a proxy operates before JIRA, the access logs will only contain the IP addresses of the proxy
instead of the address of the user. With `X-Forwarded-For` the proxy can forward the users IP
address to the JIRA application server so that it can be logged correctly.

Defaults to `false`.

#### Crowd single sign on parameters

#### `enable_sso`

Enable crowd single sign on configuration as described in <https://confluence.atlassian.com/display/CROWD/Integrating+Crowd+with+Atlassian+Confluence#IntegratingCrowdwithAtlassianConfluence-2.2EnableSSOintegrationwithCrowd(Optional)>

#### `application_name`

Set crowd application name

#### `application_password`

Set crowd application password

#### `application_login_url`

Set crowd application login url, where to login into crowd (e.g. `https://crowd.example.com/console/`)

#### `crowd_server_url`

Set crowd application services url, e.g. `https://crowd.example.com/services/`

#### `crowd_base_url`

Set crowd base url, e.g. `https://crowd.example.com/`

#### `session_isauthenticated`

Some more crowd.properties for SSO, see atlassian documentation for details

#### `session_tokenkey`

Some more crowd.properties for SSO, see atlassian documentation for details

#### `session_validationinterval`

Some more crowd.properties for SSO, see atlassian documentation for details

#### `session_lastvalidation`

Some more crowd.properties for SSO, see atlassian documentation for details

## Usage

### A more complex example

```puppet
    class { 'jira':
      version                      => '8.13.5',
      installdir                   => '/opt/atlassian-jira',
      homedir                      => '/opt/atlassian-jira/jira-home',
      user                         => 'jira',
      group                        => 'jira',
      dbpassword                   => 'secret',
      dbserver                     => 'localhost',
      java_package                 => 'java-11-openjdk-headless',
      javahome                     => '/usr/lib/jvm/jre-11-openjdk/',
      download_url                 => 'http://myserver/pub/development-tools/atlassian/',
      tomcat_additional_connectors => {
        # Define two additional connectors, listening on port 8081 and 8082
        8081 => {
          'relaxedPathChars'      => '[]|',
          'relaxedQueryChars'     => '[]|{}^&#x5c;&#x60;&quot;&lt;&gt;',
          'maxThreads'            => '150',
          'minSpareThreads'       => '25',
          'connectionTimeout'     => '20000',
          'enableLookups'         => 'false',
          'maxHttpHeaderSize'     => '8192',
          'protocol'              => 'HTTP/1.1',
          'useBodyEncodingForURI' => 'true',
          'redirectPort'          => '8443',
          'acceptCount'           => '100',
          'disableUploadTimeout'  => 'true',
          'bindOnInit'            => 'false',
        },
        # This additional connector is configured for access from a reverse proxy
        8082 => {
          'relaxedPathChars'      => '[]|',
          'relaxedQueryChars'     => '[]|{}^&#x5c;&#x60;&quot;&lt;&gt;',
          'maxThreads'            => '150',
          'minSpareThreads'       => '25',
          'connectionTimeout'     => '20000',
          'enableLookups'         => 'false',
          'maxHttpHeaderSize'     => '8192',
          'protocol'              => 'HTTP/1.1',
          'useBodyEncodingForURI' => 'true',
          'redirectPort'          => '8443',
          'acceptCount'           => '100',
          'disableUploadTimeout'  => 'true',
          'bindOnInit'            => 'false',
          'proxyName'             => 'jira2.example.com',
          'proxyPort'             => '443',
          'scheme'                => 'https',
          'secure'                => true,
        },
      }
    }
```

### Hiera examples

```yaml
jira::version:       '8.13.5'
# parent directories must exist
jira::installdir:    '/opt/atlassian/atlassian-jira'
jira::homedir:       '/opt/atlassian/application-data/jira-home'
jira::user:          'jira'
jira::group:         'jira'
jira::shell:         '/bin/bash'
jira::dbserver:      'dbvip.example.co.za'
jira::javahome:      '/opt/java'
jira::java_opts: >-
  -Dhttp.proxyHost=proxy.example.co.za
  -Dhttp.proxyPort=8080
  -Dhttps.proxyHost=proxy.example.co.za
  -Dhttps.proxyPort=8080
  -Dhttp.nonProxyHosts=localhost\|127.0.0.1\|172.*.*.*\|10.*.*.*
  -XX:+UseLargePages
jira::dbport:        '5439'
jira::dbuser:        'jira'
jira::jvm_xms:       '1G'
jira::jvm_xmx:       '3G'
jira::service_manage: false
jira::env:
  - 'http_proxy=proxy.example.co.za:8080'
  - 'https_proxy=proxy.example.co.za:8080'
jira::proxy:
  scheme:    'https'
  proxyName: 'jira.example.co.za'
  proxyPort: '443'
jira::contextpath: '/jira'
jira::tomcat_additional_connectors:
  8181:
    relaxedPathChars: '[]|'
    relaxedQueryChars: '[]|{}^&#x5c;&#x60;&quot;&lt;&gt;'
    maxThreads: '150'
    minSpareThreads: '25'
    connectionTimeout: '20000'
    enableLookups: 'false'
    maxHttpHeaderSize: '8192'
    protocol: 'HTTP/1.1'
    useBodyEncodingForURI: 'true'
    redirectPort: '8443'
    acceptCount: '100'
    disableUploadTimeout: 'true'
    bindOnInit: 'false'
```

These additional and substituted parameters are used in production in an
traditional enterprise environment with an Oracle 11g remote database and
Oracle 8 JDK. Your mileage may vary.

```yaml
jira::db:            'oracle'
jira::dbname:        '<dbname>'
jira::dbport:        '1526'
jira::dbdriver:      'oracle.jdbc.OracleDriver'
jira::dbtype:        'oracle10g'
jira::dburl:         'jdbc:oracle:thin:@//dbvip.example.co.za:1526/<dbname>'
jira::javahome:      '/usr/lib/jvm/jdk-8-oracle-x64'
```

Reverse proxy can be configured as a hash as part of the JIRA resource

```puppet
   proxy          => {
     scheme       => 'https',
     proxyName    => 'www.example.com',
     proxyPort    => '443',
   },
```

Enable external facts for puppet version. These facts are required to be
enabled in order to upgrade to new JIRA versions smoothly.

```puppet
  class { 'jira::facts': }
```

## Limitations

* Puppet 5.5.8+
* Puppet Enterprise

The puppetlabs repositories can be found at:
<http://yum.puppetlabs.com/> and <http://apt.puppetlabs.com/>

* RedHat 7
* CentOS 7
* Scientific 7
* Oracle Linux 7
* Ubuntu 18.04

* Jira 8.x

* PostgreSQL
* MySQL
* Oracle 11G with Oracle 11.2.x drivers
* Microsoft SQL Server 2005/2008/2012 with JTDS driver (included in non-WAR version)

We plan to support other Linux distributions and possibly Windows in the near future.

## Development

Please feel free to raise any issues here for bug fixes. We also welcome feature
requests. Feel free to make a pull request for anything and we make the effort to
review and merge. We prefer with tests if possible.

## Testing - How to test the JIRA module

Using [puppetlabs_spec_helper](https://github.com/puppetlabs/puppetlabs_spec_helper).
Simply run:

```
bundle install && bundle exec rake spec
```

to get results.

```
ruby-1.9.3-p484/bin/ruby -S rspec spec/classes/jira_install_spec.rb --color
.

Finished in 0.38159 seconds
1 example, 0 failures
```

Using [Beaker - Puppet Labs cloud enabled acceptance testing tool.](https://github.com/puppetlabs/beaker).

The beaker tests will install oracle Java to /opt/java. When running the beaker
tests you agree that you accept the [oracle java license](http://www.oracle.com/technetwork/java/javase/terms/license/index.html).

```
bundle install
BEAKER_set=ubuntu-server-12042-x64 bundle exec rake beaker
BEAKER_set=ubuntu-server-1404-x64 bundle exec rake beaker
BEAKER_set=debian-73-x64 bundle exec rake beaker
BEAKER_set=centos-64-x64 bundle exec rake beaker
BEAKER_set=centos-70-x64 bundle exec rake beaker
BEAKER_set=centos-64-x64-pe bundle exec rake beaker
```

To save build time it is useful to host the installation files locally on a web
server. You can use the download_url environment variable to overwrite the default.

```bash
export download_url="'http://my.local.server/'"
```

## Contributors

The list of contributors can be found [here](https://github.com/voxpupuli/puppet-jira/graphs/contributors)
