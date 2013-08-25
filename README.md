# puppet-jira
Puppet module for Altassian JIRA  
authored by Bryce Johnson

## Introduction

puppet-jira is a module for Atlassian's Enterprise Issue Tracking and
project management tool.

This puppet module heavily uses hiera-puppet to decouple configuration 
information from the module itself.  An example is given in `jira.yaml`
that you can use to construct your own jira hieradata information.  Hiera
variables are then defined in the module's `params.pp`.

## Requirements

### Puppet

Tested on Puppet 3.0+ 
Puppet 2.7+ should work as Hiera is now optional.

The puppetlabs production yum repository can be found at:  
http://yum.puppetlabs.com/el/6/products/x86_64

### Operating Systems
* Linux:  RedHat / Centos 5/6 - tested.
* Linux:  Ubuntu 12.04 - tested.

### Databases
* Postgres
* MySQL (untested)

### Before you begin
It is your responsibility to backup your database.  Especially do so
if you are installing to an existing installation of jira as this module
is UNTESTED from with an existing install of jira  
  
You must have your database setup with the account user that the application
will use.  This information needs to be put in the hiera yaml, for example
jira.yaml, in your hieradata directory.  
  
I have my own postgres puppet module that installs pg, creates the JIRA
database, and the JIRA database user before the JIRA puppet module runs.  
  
Make sure you have a JAVA_HOME and appropriate java installed on your machine.
  
Did I mention if you are upgrading, BACKUP your database first? This module 
makes no warranty on your data, per its license.  

### Installation

This puppet module will automatically download the jira zip from Atlassian
and extract it into /opt/jira/atlassian-jira-$version

This module requires: https://github.com/mkrakowitzer/puppet-deploy.git
  
An example on how to use this module:

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

If you would prefer to use Hiera then see jira.yaml file for an example.

### Fixes and Future Work
Please feel free to raise any issues here for fixes.  I'm happy to fix them
up.  Also feel free to make a pull request for anything so I can hopefully
get it in.
