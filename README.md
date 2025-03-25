# JIRA module for Puppet

[![CI](https://github.com/voxpupuli/puppet-jira/actions/workflows/ci.yml/badge.svg)](https://github.com/voxpupuli/puppet-jira/actions/workflows/ci.yml)
[![Code Coverage](https://coveralls.io/repos/github/voxpupuli/puppet-jira/badge.svg?branch=master)](https://coveralls.io/github/voxpupuli/puppet-jira)
[![Puppet Forge](https://img.shields.io/puppetforge/v/puppet/jira.svg)](https://forge.puppetlabs.com/puppet/jira)
[![Puppet Forge - downloads](https://img.shields.io/puppetforge/dt/puppet/jira.svg)](https://forge.puppetlabs.com/puppet/jira)
[![Puppet Forge - endorsement](https://img.shields.io/puppetforge/e/puppet/jira.svg)](https://forge.puppetlabs.com/puppet/jira)
[![Puppet Forge - scores](https://img.shields.io/puppetforge/f/puppet/jira.svg)](https://forge.puppetlabs.com/puppet/jira)

## Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with JIRA](#setup)
    * [JIRA Prerequisites](#jira-prerequisites)
    * [What JIRA affects](#what-jira-affects)
    * [Beginning with JIRA](#beginning-with-jira)
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
  reverse proxy to JIRA. We suggest using the puppet/nginx puppet module.

* On RHEL 8 and variants, you may experience SELinux denials if you use a custom
  installation directory that is not under `/opt`. To fix this, add an fcontext
  equivalence between `/opt` and your desired directory:
  `semanage fcontext -a /apps/jira -e /opt`
  and run `restorecon`.

### What JIRA affects

If installing to an existing JIRA instance, it is your responsibility to backup
your database. We also recommend that you backup your JIRA home directory and
that you align your current JIRA version with the version you intend to use with
puppet JIRA module.

You must have your database setup with the account user that JIRA will use. This
can be done using the puppetlabs-postgresql and puppetlabs-mysql modules.

When using this module to upgrade JIRA, please make sure you have a database/JIRA
home backup.

When using MySQL, We call the `jira::mysql_connector` class to install the MySQL java
connector directory from mysql.com as per Atlassian's documented recommendations.

### Beginning with JIRA

This puppet module will automatically download the JIRA archive from Atlassian and
extracts it into /opt/jira/atlassian-jira-$version. The default JIRA home is
`/home/jira`, though you are encouraged to change this.

If you would prefer to use Hiera then see jira.yaml file for an example.

#### Basic example

```puppet
  # Java 11 is managed externally and installed in /opt/java
  class { 'jira':
    javahome     => '/opt/java',
  }
```

The module can install a package for you using your OS's package manager.
Note that there's no smarts here. You need to set javahome correctly.

*Pre JIRA 10*
```puppet
  # this example works on RHEL
  class { 'jira':
    java_package  => 'java-11-openjdk-headless'
    javahome      => '/usr/lib/jvm/jre-11-opendjk/',
  }
```

*Post JIRA 10*
```puppet
  # this example works on RHEL
  class { 'jira':
    java_package  => 'java-17-openjdk'
    javahome      => '/usr/lib/jvm/jre-17-opendjk/',
  }
```

#### Upgrades

##### Upgrades to JIRA

Jira can be upgraded by incrementing this version number. This will *STOP* the
running instance of Jira and attempt to upgrade. You should take caution when
doing large version upgrades. Always backup your database and your home directory.

```puppet
  class { 'jira':
    java_package  => 'java-11-openjdk-headless'
    javahome      => '/usr/lib/jvm/jre-11-opendjk/',
    version       => '8.16.0',
  }
```

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

### notes on secret encryption in dbconfig.xml
The JIRA process will read the dbconfig.xml on startup replace it with the string "{ATL_SECURED}". The password is moved
into `<shared_homedir>/keys/javax.crypto.spec.SecretKeySpec_<some random number>`. It is important that this directory
is not located inside of the installation dir as you would lose it in the case of an update.

## Reference

see [REFERENCE.md](REFERENCE.md)

## Limitations

* Puppet 6.1.0
* Puppet Enterprise

The puppetlabs repositories can be found at:
<http://yum.puppetlabs.com/> and <http://apt.puppetlabs.com/>

* RedHat 7, 8 or compatible (CentOS, Oracle Linux, etc)
* Ubuntu 18.04, 20.04

* Jira 8.x

* PostgreSQL
* MySQL

The databases below should work, but are not tested. YMMV.

* Oracle
* Microsoft SQL Server with JTDS driver (included in non-WAR version)

## Development

Please feel free to raise any issues here for bug fixes. We also welcome feature
requests. Feel free to make a pull request for anything and we make the effort to
review and merge. We prefer with tests if possible.

## Testing

### How to test the JIRA module

Using [puppetlabs_spec_helper](https://github.com/puppetlabs/puppetlabs_spec_helper).
Simply run:

```shell
bundle install && bundle exec rake spec
```

to get results.

```shell
ruby -S rspec spec/classes/jira_install_spec.rb --color
.

Finished in 0.38159 seconds
1 example, 0 failures
```

Using [Beaker - Puppet Labs cloud enabled acceptance testing tool.](https://github.com/puppetlabs/beaker).

The beaker tests will install oracle Java to /opt/java. When running the beaker
tests you agree that you accept the [oracle java license](http://www.oracle.com/technetwork/java/javase/terms/license/index.html).

```shell
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

```shell
export download_url="'http://my.local.server/'"
```

## Contributors

The list of contributors can be found [here](https://github.com/voxpupuli/puppet-jira/graphs/contributors)
