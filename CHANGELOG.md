##2014-11-18 - Release 1.1.4
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
