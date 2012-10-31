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

Puppet 3.0+ is required as this module leverages hiera  

Puppet itself requires:  

*  ruby
*  rubygems
*  Ruby Augeas     http://pkgs.repoforge.org/ruby-augeas/
*  Ruby Shadow     http://pkgs.repoforge.org/ruby-shadow/
*  Ruby JSON       http://pkgs.repoforge.org/ruby-json/
  
Hiera requires that you build a `hiera.yaml` configuration file in `/etc/puppet`  

The puppetlabs production yum repository can be found at:  
http://yum.puppetlabs.com/el/6/products/x86_64

### Operating Systems
* MacOS: UNSUPPORTED
* Linux:  RedHat (Debian untested)
* Windows:  UNSUPPORTED

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
Recommended is JDK 1.6u33+ and not JDK 1.7+  
  
Did I mention if you are upgrading, BACKUP your database first? This module 
makes no warranty on your data, per its license.  

### Installation

This puppet module will automatically download the jira zip from Atlassian
and extract it into /opt/jira/atlassian-jira-$version
  
You will also need to enter in the directory to your jira-home, which should
also be kept in the hiera yaml, for example {{jira.yaml}}.  
  
Once you have installed the yaml information, then run puppet apply with 
this module included in the modulepath.  
  
### Fixes and Future Work
Please feel free to raise any issues here for fixes.  I'm happy to fix them
up.  Also feel free to make a pull request for anything so I can hopefully
get it in.

