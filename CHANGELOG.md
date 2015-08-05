:warning: mkrakowitzer-deploy support will be dropped next major release. It will be replaced by puppet-archive.

:warning: The jira::facts class will be included by default in next major release. You may get a Error: Duplicate declaration: Class[jira::facts] is already declared 

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
