# Changelog

## 2017-01-13 - Release 3.1.0

This is the last release with Puppet 3 support!
- modulesync with latest Vox Pupuli defaults
- Exposes checksum_verify in init.pp w/ conditional
- Allow JIRA to run in OpenJDK
- Make 'check-java.sh' Management Optional
- Bump puppet minimum version_requirement to 3.8.7
- Move 'check-java.sh' to Templates
- Fix rubocop issue in config_spec test.
- Bump minimum version dependencies (for Puppet 4)
- Remove OpenJDK Comments, use vanilla check-java.sh
- Remove extraneous comma in config.pp.
- Add Docker acceptance tests for travis

## 2016-11-23 - Release 3.0.1
### Summary
- Atlassian doesn't provide checksums, add checksum_verify false.
- Update README

### Fixes
- Fix checksum verification as Atlassian doesn't provide checksums
- Fix Atlassian End of Support for versions < 6.1 , amend jira_install_spec.rb to reflect that

### Improvements
- Amend README to clarify default deploy module
- modulesync with latest Vox Pupuli defaults

## 2016-10-04 - Release 3.0.0
### Summary
- Change pool_test_on_borrow default to false in init class :: As this alters init class, requires MAJOR release
- Add access log format variable to init :: as this also hits init class, MAJOR release
- Update README

### Fixes
- Fix Download - version 7.1.9 and up
- Incompatible listeners server.xml > version 7
- Fix missing pool_test_on_borrow in dbconfig.mysql.xml.erb

### Improvements
- modulesync with latest Vox Pupuli defaults

## 2016-09-08 - Release 2.1.0
### Summary
- modulesync with latest Vox Pupuli defaults

## Improvements
- Add hiera support for catalina_opts

### Fixes
- Service status is not working when using init scripts
- Fix JIRA 7.1.x download URL

## 2016-05-26 - Release 2.0.0
### Summary
- We dropped ruby1.8 support!
- mkrakowitzer-deploy got replaced by puppet-archive.
- The jira::facts class is included by default. You may get a Error: Duplicate declaration: Class[jira::facts] is already declared
- We added JIRA 7 Support

### Improvements
- Use defined function to test for the existence of the fact ::jira_ver
- Added hieradata examples for Oracle DB backend
- Added containment for mysql_connector class
- Support STRICT_VARIABLES=yes
- Paramaterizing more tomcat settings
- Added schema parameter for dbconfig
- Added configuration option to enable or disable websudo.
- Added tests and updated README.md
- Support configuration of all properties in jira-config.properties
- Added crowd single sign-on functions as described by atlassian wiki
- Added ability to change tomcatShutdownPort

### Fixes
- Fix to address Amazon Ami configuration
- Avoid duplicate scheme declaration when using proxy with SSL
- Fix jira::mysql_connector_url


##2015-08-05 - Release 1.3.0
###Summary
- Add SSL Support #76
- Resolve issue where rake lint tasks always exited with 0 status
- added new parameter disable_notifications in relation to setenv.sh
- Add examples


##2015-04-25 - Release 1.2.1
###Summary
- Update metadata, README, CHANGELOG to point to new namespace.
- Update .travis.yml to auto deploy tagged versions


##2015-04-16 - Release 1.2.0
- Issue #51 Make the jira users shell configurable
- Add a notify and subscribe options to the jira service
- Added oracle to db input validator
- Turn on the AJP connector based on a hiera or puppet-variable lookup
- Added Microsoft SQL Server support
- Include jira::facts class by default.
- Adding new feature generating a content.xml configuration
- Add a notify and subscribe options to the jira service
- Provide ability to set the bind address of Tomcat via the jira::tomcatAddress parameter
- Bump jira version to 6.4.1

Thanks to Scott Searcy, Oliver Bertuch, Paul Geringer, Eric Shamow, William Lieurance, Doug Neal for their contributions.


##2014-01-21 - Release 1.1.5
- Add beaker tests for MySQL
- Added support for Oracle and Scientific Linux
- Bump jira version to 6.3.13
- Add support for parameter 'contextpath'
- Add class to install MySQL Java connector from mysql.com
- Add support for oracle database

Thanks to  Oliver Bertuch  for his contributions.


##2014-01-17 - Release 1.1.4
- Parameterize the lockfile variable in the init script
- Autoinstall MySql Connector/J Driver
- Add parameter stop_jira
- Fix bug on RHEL7 where updating the systemd script does not take effect without refreshing systemd

Thanks to MasonM for his contributions


##2014-11-17 - Release 1.1.3
- Refactor beaker tests to that they are portable and other people can run them
- Remove unnecessary comments from init.pp
- Dont cleanup jira tar.gz file when using staging module.
- Add/Remove beaker nodesets
  - Add CentOS 7 nodeset
  - Remove ubuntu 1004 and Debian 6 nodeset
- Add support for systemd style init script on RedHat/CentOS 7


##2014-10-19 - Release 1.1.2
- Add new parameter: jvm_permgen, defaults to 256m.
- Updates to readme


##2014-10-11 - Release 1.1.1
- Fix typo of in module nanliu-staging, preving module from being installed


##2014-10-09 - Release 1.1.0
- Add beaker tests for Ubuntu/Centos/Debian
- Issue #3 Handle updating of Jira

###Summary
Resolve Issue #29
- Add external fact for running version of JIRA.
- Replace mkrakowitzer-deploy with nanliu-staging as the default module to deploy jira files


##2014-10-01 - Release 1.0.1

###Summary
Update the README file to comply with puppetlabs standards
- https://docs.puppetlabs.com/puppet/latest/reference/modules_documentation.html
- https://docs.puppetlabs.com/puppet/latest/reference/READMEtemplate.markdown

####Bugfixes
- None
