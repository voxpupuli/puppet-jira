# == Class: jira::params
#
# Defines default values for jira module
#
class jira::params {

  Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ] }

  case "${::osfamily}${::operatingsystemmajrelease}" {
    /RedHat7/: {
      $json_packages           = 'rubygem-json'
      $service_file_location   = '/usr/lib/systemd/system/jira.service'
      $service_file_template   = 'jira/jira.service.erb'
      $service_lockfile        = '/var/lock/subsys/jira'
    }
    /Debian/: {
      $json_packages           = [ 'rubygem-json', 'ruby-json' ]
      $service_file_location   = '/etc/init.d/jira'
      $service_file_template   = 'jira/jira.initscript.erb'
      $service_lockfile        = '/var/lock/jira'
    }
    default: {
      $json_packages           = [ 'rubygem-json', 'ruby-json' ]
      $service_file_location   = '/etc/init.d/jira'
      $service_file_template   = 'jira/jira.initscript.erb'
      $service_lockfile        = '/var/lock/subsys/jira'
    }
  }
}
