# == Class: jira::params
#
# Defines default values for jira module
#
class jira::params {
  case "${::osfamily}${::operatingsystemmajrelease}" {
    /RedHat7/: {
      $json_packages         = 'rubygem-json'
      $service_file_location = '/usr/lib/systemd/system/jira.service'
      $service_file_template = 'jira/jira.service.erb'
    }
    default: {
      $json_packages         = [ 'rubygem-json', 'ruby-json' ]
      $service_file_location = '/etc/init.d/jira'
      $service_file_template = 'jira/jira.initscript.erb'
    }
  }
}
