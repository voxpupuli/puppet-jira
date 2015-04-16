:warning: Next Major release
- mkrakowitzer-deploy support will be dropped. It will be replaced by nanlui-archive.
- :warning: The jira::facts class will be included by default. If you are calling the jira::facts class, you will recieve a Class[jira::facts] is already declared error.

##2014-03-25 - Release 1.2.0

- Issue #51 Make the jira users shell configurable
- Add a notify and subscribe options to the jira service
- Added oracle to db input validator
- Turn on the AJP connector based on a hiera or puppet-variable lookup
- Added Microsoft SQL Server support
- Include jira::facts class by default.

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
