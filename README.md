#JIRA Module

[![Puppet Forge](http://img.shields.io/puppetforge/v/puppet/jira.svg)](https://forge.puppetlabs.com/puppet/jira)
[![Build Status](https://travis-ci.org/puppet-community/puppet-jira.svg?branch=master)](https://travis-ci.org/puppet-community/puppet-jira)

####Table of Contents

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

##Overview

This module allows you to install, upgrade and manage Atlassian JIRA.

##Module Description

This module installs/upgrades Atlassian's Enterprise Issue Tracking and project management tool. The JIRA module also manages the JIRA configuration files with Puppet.

##Setup

<a name="JIRA-prerequisites">
###JIRA Prerequisites

* JIRA requires a Java Developers Kit (JDK) or Java Run-time Environment (JRE) platform to be installed on your server's operating system. Oracle JDK / JRE (formerly Sun JDK / JRE) versions 7 and 8 are currently supported by Atlassian.

* JIRA requires a relational database to store its issue data. This module currently supports PostgreSQL 8.4 to 9.x and MySQL 5.x and Oracle 11g and Microsoft SQL Server 2008 & 2012. We suggest using puppetlabs-postgresql/puppetlabs-mysql modules to configure/manage the database. The module uses PostgreSQL as a default.

* Whilst not required, for production use we recommend using nginx/apache as a reverse proxy to JIRA. We suggest using the jfryman/nginx puppet module.

<a name="what-JIRA-affects">
###What JIRA affects

If installing to an existing JIRA instance, it is your responsibility to backup your database. We also recommend that you backup your JIRA home directory and that you align your current JIRA version with the version you intend to use with puppet JIRA module.

You must have your database setup with the account user that JIRA will use. This can be done using the puppetlabs-postgresql and puppetlabs-mysql modules.

When using this module to upgrade JIRA, please make sure you have a database/JIRA home backup.

When using MySQL, We call the jira::mysql_connector class to install the MySQL java connector directory from mysql.com as per Atlassian's documented recommendations.

<a name="beginning-with-JIRA">
###Beginning with JIRA

This puppet module will automatically download the JIRA zip from Atlassian
and extracts it into /opt/jira/atlassian-jira-$version. The default JIRA home is /home/jira.

If you would prefer to use Hiera then see jira.yaml file for available options.

#####Basic example
```puppet
  class { 'jira':
    javahome    => '/opt/java',
  }
```

<a name="upgrades">
#####Upgrades

######Upgrades to JIRA

Jira can be upgraded by incrementing this version number. This will *STOP* the running instance of Jira and attempt to upgrade. You should take caution when doing large version upgrades. Always backup your database and your home directory. The jira::facts class is required for upgrades.

```puppet
  class { 'jira':
    javahome    => '/opt/java',
    version     => '6.3.7',
  }
  class { 'jira::facts': }
```

######Upgrades to the JIRA puppet Module
mkrakowitzer-deploy has been replaced with nanliu-staging as the default module for deploying the JIRA binaries. You can still use mkrakowitzer-deploy with the *staging_or_deploy => 'deploy'*

```puppet
  class { 'jira':
    javahome    => '/opt/java',
    staging_or_deploy => 'deploy',
  }
```

##Reference

###Classes

####Public Classes

* `jira`: Main class, manages the installation and configuration of JIRA
* `jira::facts`: Enable external facts for running instance of JIRA. This class is required to handle upgrades of jira. As it is an external fact, we chose not to enable it by default.

####Private Classes

* `jira::install`: Installs JIRA binaries
* `jira::config`: Modifies jira/tomcat configuration files
* `jira::service`: Manage the JIRA service.
* `jira::mysql_connector`: Install/Manage the MySQL Java connector

###Parameters

####JIRA parameters####

#####`$version`

Specifies the version of JIRA to install, defaults to latest available at time of module upload to the forge. It is recommended to pin the version number to avoid unnecessary upgrades of JIRA.

#####`$product`

Product name, defaults to jira

#####`$format`

The default file format of the JIRA install file, defaults to tar.gz

#####`$installdir`

The directory to install to, defaults to '/opt/jira'

#####`$homedir`

The default home directory of JIRA, defaults to '/home/jira'

#####`$user`

The user to run/install JIRA as, defaults to 'jira'

#####`$group`

The group to run/install JIRA as, defaults to 'jira'

#####`$uid`

The uid of the JIRA user, defaults to next available (undef)

#####`$gid`

The gid of the JIRA user, defaults to next available (undef)

#####`$shell`

The shell of the JIRA user, defaults to '/bin/true'

####database parameters####

#####`$db`

Which database to use for JIRA, defaults to 'postgresql'. Can be 'postgresql', 'mysql', 'oracle' or 'sqlserver'.

#####`$dbuser`

The default database user for JIRA, defaults to 'jiraadm'

#####`$dbpassword`

The password for the database user, defaults to 'mypassword'

#####`$dbserver`

The hostname of the database server, defaults to 'localhost'

#####`$dbname`

The name of the database, defaults to 'jira'. If using oracle this should be the SID.

#####`$dbport`

The port of the database, defaults to '5432'. MySQL runs on '3306'. Oracle runs on '1521'. SQL Server runs on '1433'.

#####`$dbdriver`

The database driver to use, defaults to 'org.postgresql.Driver'. Can be 'org.postgresql.Driver', 'com.mysql.jdbc.Driver', 'oracle.jdbc.OracleDriver' or 'net.sourceforge.jtds.jdbc.Driver'.

#####`$dbtype`

Database type, defaults to 'postgres72'. Can be 'postgres72', 'mysql', 'oracle10g', or 'mssql'. Atlassian only supports Oracle 11g, even so this value should be as documented here.

#####`$poolsize`

The connection pool size to the database, defaults to 20

#####`$dburl`
This parameter is not required nor do we recommend setting it. However it can be used to customize the database connection string.

#####`$enable_connection_pooling`

Configure database settings if you are pooling connections, defaults to 'false'

#####`$poolMinSize`

defaults to 20

#####`$poolMaxSize`

defaults to 20

#####`$poolMaxWait`

defaults to 30000

#####`$validationQuery`

defaults to undef

#####`$minEvictableIdleTime`

defaults to 60000

#####`$timeBetweenEvictionRuns`

defaults to undef

#####`$poolMaxIdle`

defaults to 20

#####`$poolRemoveAbandoned`

defaults to true

#####`$poolRemoveAbandonedTimout`

defaults to 300

#####`$poolTestWhileIdle`

defaults to true

#####`$poolTestOnBorrow`

defaults to true

####MySQL Java Connector parameters####

#####`mysql_connector_manage`
Manage the MySQL Java Connector with the JIRA module, defaults to 'true'

#####`mysql_connector_version`
Specifies the version of  MySQL Java Connector you would like installed. Defaults to '5.1.34',

#####`$mysql_connector_product`
Product name, defaults to 'mysql-connector-java'

#####`$mysql_connector_format`
The default file format of the MySQL Java Connector install file, defaults to tar.gz

#####`$mysql_connector_install`
Installation directory of the MySQL connector. Defaults to '/opt/MySQL-connector'

#####`$mysql_connector_URL`
The URL used to download the MySQL Java Connector installation file.
Defaults to 'http://cdn.mysql.com/Downloads/Connector-J'

####JVM Java parameters####

#####`$javahome`

The JAVA_HOME directory, defaults to undef. This is a *required* parameter

#####`$jvm_xms`

The initial memory allocation pool for a Java Virtual Machine.
defaults to '256m'

#####`$jvm_xmx`

Maximum memory allocation pool for a Java Virtual Machine.
defaults to '1024m'

#####`$jvm_permgen`

Increase max permgen size for a Java Virtual Machine.
defaults to '256m'

#####`$jvm_optional`

defaults to '-XX:-HeapDumpOnOutOfMemoryError'

#####`$java_opts`

defaults to ''

####Miscellaneous  parameters####

#####`$downloadURL`

The URL used to download the JIRA installation file.
Defaults to 'http://www.atlassian.com/software/jira/downloads/binary/'

#####`$staging_or_deploy`

Choose whether to use nanliu-staging, or mkrakowitzer-deploy.
Defaults to 'staging' to use nanliu-staging as it is puppetlabs approved.
Alternative option is 'deploy' to use mkrakowitzer-deploy.

#####`$service_manage`

Manage the JIRA service, defaults to 'true'

#####`$service_ensure`

Manage the JIRA service, defaults to 'running'

#####`$service_enable`

Defaults to 'true'

#####`$service_subscribe`

Restart the jira service in response to this subscription

#####`$service_notify`

Notify other puppet resources to refresh after the jira service

#####`$stop_jira`
If the jira service is managed outside of puppet the stop_jira parameter can be used to shut down jira for upgrades. Defaults to 'service jira stop && sleep 15'

#####`$proxy = {}`

Defaults to {}, See examples on how to use.

#####`$contextpath = ""`

Defaults to an empty string (""). Will add a path to the Tomcat Server Context.

####Tomcat parameters####

#####`$tomcatAddress`

IP address to listen on. Defaults to all addresses.

#####`$tomcatPort`

Port to listen on, defaults to '8080'

#####`$tomcatMaxThreads`

Defaults to '150'

#####`$tomcatAcceptCount`

Defaults to '100'

#####`$tomcatNativeSsl`

Enable https/ssl support. Defaults to 'false'. See https://confluence.atlassian.com/display/JIRA/Running+JIRA+over+SSL+or+HTTPS for additional info. The java keystore can be managed with the puppetlabs-java\_ks module or manually with `keytool -genkey -alias jira -keyalg RSA -sigalg SHA256withRSA -keystore /home/jira/jira.ks`

#####`$tomcatHttpsPort`

https/ssl Port to listen on, defaults to 8443.

#####`$tomcatKeyAlias`

The alias name of the java keystore entry. Defaults to 'jira'.

#####`$tomcatKeystoreFile`

Location of java keystore file. Defaults to '/home/jira/jira.jks'

#####`$tomcatKeystorePass`

Password to access java keystore. Defaults to 'changeit'

#####`$tomcatKeystoreType`

Defaults to 'JKS'. Valid options are 'JKS', 'PKCS12', 'JCEKS'.

##Usage

####A more complex example
```puppet
    class { 'jira':
      version     => '6.0.1',
      installdir  => '/opt/atlassian-jira',
      homedir     => '/opt/atlassian-jira/jira-home',
      user        => 'jira',
      group       => 'jira',
      dbpassword  => 'secret',
      dbserver    => 'localhost',
      javahome    => '/opt/java/jdk1.7.0_21/',
      downloadURL  => 'http://myserver/pub/development-tools/atlassian/',
    }
```

### Hiera examples 

This example is used in production for 2000 users in an traditional enterprise environment. Your mileage may vary. The dbpassword can be stored using eyaml hiera extension.

```yaml
jira::version:       '6.2.7'
jira::installdir:    '/opt/atlassian/atlassian-jira'
jira::homedir:       '/opt/atlassian/application-data/jira-home'
jira::user:          'jira'
jira::group:         'jira'
jira::shell:         '/bin/bash'
jira::dbserver:      'dbvip.example.co.za'
jira::javahome:      '/opt/java'
jira::java_opts: >
  -Dhttp.proxyHost=proxy.example.co.za
  -Dhttp.proxyPort=8080
  -Dhttps.proxyHost=proxy.example.co.za
  -Dhttps.proxyPort=8080
  -Dhttp.nonProxyHosts=localhost\|127.0.0.1\|172.*.*.*\|10.*.*.*
  -XX:+UseLargePages'
jira::dbport:        '5439'
jira::dbuser:        'jira'
jira::jvm_xms:       '1G'
jira::jvm_xmx:       '3G'
jira::jvm_permgen:   '384m'
jira::service_manage: false
jira::enable_connection_pooling: 'true'
jira::env:
  - 'http_proxy=proxy.example.co.za:8080'
  - 'https_proxy=proxy.example.co.za:8080'
jira::proxy:
  scheme:    'https'
  proxyName: 'jira.example.co.za'
  proxyPort: '443'
jira::contextpath: '/jira'
```

These additional and substituted parameters are used in production in an traditional enterprise environment with an Oracle 11g remote database and Oracle 8 JDK. Your mileage may vary.

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

Enable external facts for puppet version. These facts are required to be enabled in order to upgrade to new JIRA versions smoothly.
```puppet
  class { 'jira::facts': }
```

##Limitations

* Puppet 3.7+
* Puppet Enterprise

The puppetlabs repositories can be found at:
http://yum.puppetlabs.com/ and http://apt.puppetlabs.com/

* RedHat 6/7
* CentOS 6/7
* Scientific 6/7
* Oracle Linux 6/7
* Ubuntu 12.04/14.04
* Debian 7

* PostgreSQL
* MySQL 5.x
* Oracle 11G with Oracle 11.2.x drivers
* Microsoft SQL Server 2005/2008/2012 with JTDS driver (included in non-WAR version)

We plan to support other Linux distributions and possibly Windows in the near future.

##Development

Please feel free to raise any issues here for bug fixes. We also welcome feature requests. Feel free to make a pull request for anything and we make the effort to review and merge. We prefer with tests if possible.

##Testing - How to test the JIRA module
Using [puppetlabs_spec_helper](https://github.com/puppetlabs/puppetlabs_spec_helper). Simply run:

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

The beaker tests will install oracle Java to /opt/java. When running the beaker tests you agree that you accept the [oracle java license](http://www.oracle.com/technetwork/java/javase/terms/license/index.html).

```
bundle install
BEAKER_set=ubuntu-server-12042-x64 bundle exec rake beaker
BEAKER_set=ubuntu-server-1404-x64 bundle exec rake beaker
BEAKER_set=debian-73-x64 bundle exec rake beaker
BEAKER_set=centos-64-x64 bundle exec rake beaker
BEAKER_set=centos-70-x64 bundle exec rake beaker
BEAKER_set=centos-64-x64-pe bundle exec rake beaker
```

To save build time it is useful to host the installation files locally on a web server. You can use the download_url environment variable to overwrite the default.

```bash
export download_url="'http://my.local.server/'"
```


##Contributors

The list of contributors can be found [here](https://github.com/brycejohnson/puppet-jira/graphs/contributors)

