#JIRA Module

[![Build Status](https://travis-ci.org/brycejohnson/puppet-jira.svg?branch=master)](https://travis-ci.org/brycejohnson/puppet-jira)

####Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with JIRA](#setup)
    * [JIRA Prerequisites] (#JIRA-prerequisites)
    * [What JIRA affects](#what-JIRA-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with JIRA](#beginning-with-JIRA)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
6. [Limitations - OS compatibility, etc.](#limitations)
7. [Development - Guide for contributing to the module](#development)
8. [Testing the JIRA module](#testing)

##Overview

This module allows you to install, upgrade and manage Atlassian JIRA.

##Module Description

This module installs/upgrades Atlassian's Enterprise Issue Tracking and project management tool. The JIRA module also manages the JIRA configuration files with Puppet.

##Setup

###JIRA Prerequisites

* JIRA requires a Java Developers Kit (JDK) or Java Run-time Environment (JRE) platform to be installed on your server's operating system. Oracle JDK / JRE (formerly Sun JDK / JRE)	versions 7 and 8 are currently supported by Atlassian.

* JIRA requires a relational database to store its issue data. This module currently supports PostgreSQL 8.4 to 9.x and MySQL 5.x. We suggest using puppetlabs-postgres/puppetlabs-mysql modules to configure/manage the database. The module uses PostgreSQL as a default.

* Whilst not required, for production use we recommend using nginx/apache as a reverse proxy to JIRA. We suggest using the jfryman/nginx puppet module.

###What JIRA affects

If installing to an existing JIRA instance, it is your responsibility to backup your database. We also recommend that you backup your JIRA home directory and that you align your current JIRA version with the version you intend to use with puppet JIRA module.

You must have your database setup with the account user that JIRA will use. This can be done using the puppetlabs-postgresql and puppetlabs-mysql modules. 

When using this module to upgrade JIRA, please make sure you have a database/JIRA home backup.

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

#####More complex examples

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

A possible production example in Hiera

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
jira::dbport:        '5432'
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
```

Reverse proxy can be configured as a hash as part of the JIRA resource
```puppet
   proxy          => {
     scheme       => 'https',
     proxyName    => 'www.example.com',
     proxyPort    => '443',
   },
```

A complete example with postgres/nginx/JIRA is available [here](https://github.com/mkrakowitzer/vagrant-puppet-jira/blob/master/manifests/site.pp).

#####upgrades
mkrakowitzer-deploy has been replaced with nanlui-staging as the default module for deploying the JIRA binaries. You can still use mkrakowitzer-deploy with the *staging_or_deploy => 'deploy'*

```puppet
  class { 'jira':
    javahome    => '/opt/java',
    proxy       => {
      scheme    => 'http',
      proxyName => $::ipaddress_eth1,
      proxyPort => '80',
    },
    staging_or_deploy => 'deploy',
  }
```

##Reference

###Classes

####Public Classes

* `jira`: Main class, manages the installation and configuration of JIRA

####Private Classes

* `jira::install`: Installs JIRA binaries
* `jira::config`: Modifies jira/tomcat configuration files
* `jira::service`: Manage the JIRA service.

###Parameters

####JIRA parameters####

#####`$version`

Specifies the version of JIRA to install, defaults to latest available at time of module upload to the forge. It is recommended to pin the version number to avoid unnecessary upgrades of JIRA.

#####`$product`

Product name, defaults to JIRA

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

####database parameters####

#####`$db`

Which database to use for JIRA, defaults to 'postgresql'

#####`$dbuser`

The default database user for JIRA, defaults to 'jiraadm'

#####`$dbpassword`

The password for the database user, defaults to 'mypassword'

#####`$dbserver`

The hostname of the database server, defaults to 'localhost'

#####`$dbname`

The name of the database, defaults to 'jira'

#####`$dbport`

The port of the database, defaults to '5432'

#####`$dbdriver`

The database driver to use, defaults to 'org.postgresql.Driver'

#####`$dbtype`

Database type, defaults to 'postgres72'

#####`$poolsize`

The connection pool size to the database, defaults to 20

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

####JVM Java parameters####

#####`$javahome`

The JAVA_HOME directory, defaults to undef. This is a *required* parameter

#####`$jvm_xms`

defaults to '256m'

#####`$jvm_xmx`

defaults to '1024m'

#####`$jvm_optional`

defaults to '-XX:-HeapDumpOnOutOfMemoryError'

#####`$java_opts`

defaults to ''

####Miscellaneous  parameters####

#####`$downloadURL`

The URL used to download the JIRA installation file.
Defaults to 'http://www.atlassian.com/software/jira/downloads/binary/'

#####`$staging_or_deploy`

Choose whether to use nanlui-staging, or mkrakowitzer-deploy.
Defaults to 'staging' to use nanlui-staging as it is puppetlabs approved.
Alternative option is 'deploy' to use mkrakowitzer-deploy.

#####`$service_manage`

Manage the JIRA service, defaults to 'true'

#####`$service_ensure`

Manage the JIRA service, defaults to 'running'

#####`$service_enable`

Defaults to 'true'

#####`$proxy = {}`

Defaults to {}, See examples on how to use.

####Tomcat parameters####

#####`$tomcatPort`

Port to listen on, defaults to 8080,

#####`$tomcatMaxThreads`

Defaults to '150'

#####`$tomcatAcceptCount`

Defaults to '100'

##Usage

Put the classes, types, and resources for customizing, configuring, and doing the fancy stuff with your module here. 

##Reference

Here, list the classes, types, providers, facts, etc contained in your module. This section should include all of the under-the-hood workings of your module so people know what the module is touching on their system but don't need to mess with things. (We are working on automating this section!)

##Limitations

* Puppet 3.4+
* Puppet Enterprise

The puppetlabs repositories can be found at:
http://yum.puppetlabs.com/ and http://apt.puppetlabs.com/

* RedHat / CentOS 5/6
* Ubuntu 12.04

We plan to support other Linux distributions and possibly Windows in the near future.

##Development

Please feel free to raise any issues here for bug fixes. We also welcome feature requests.
Also feel free to make a pull request for anything and we can hopefully get it in. We prefer with tests if possible.

##Testing the JIRA module
Using [puppetlabs_spec_helper](https://github.com/puppetlabs/puppetlabs_spec_helper). Simply run:

```
bundle install && bundle exec rake spec
```

to get results.

```
ruby-1.9.3-p484/bin/ruby -S rspec spec/classes/stash_install_spec.rb --color
.

Finished in 0.38159 seconds
1 example, 0 failures
```

##Contributors

The list of contributors can be found [here](https://github.com/brycejohnson/puppet-jira/graphs/contributors)

