# == Class: jira::params
#
# Defines default values for jira module
#
class jira::params {

  Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ] }

  case $::osfamily {
    /RedHat/: {
      if versioncmp($::operatingsystemmajrelease, '7') >= 0 {
        $json_packages           = 'rubygem-json'
        $service_file_location   = '/usr/lib/systemd/system/jira.service'
        $service_file_template   = 'jira/jira.service.erb'
        $service_lockfile        = '/var/lock/subsys/jira'
        $service_provider        = 'systemd'
      } elsif versioncmp($::operatingsystemmajrelease, '6') >= 0 or $::operatingsystem == 'Amazon'{
        $json_packages           = [ 'rubygem-json', 'ruby-json' ]
        $service_file_location   = '/etc/init.d/jira'
        $service_file_template   = 'jira/jira.initscript.erb'
        $service_lockfile        = '/var/lock/subsys/jira'
        $service_provider        = undef
      } else {
        fail("\"${module_name}\" provides no service parameters
            for \"${::osfamily}\" - \"${::operatingsystemmajrelease}\"")
      }
    } /Debian/: {
      case $::operatingsystem {
        'Ubuntu': {
          $json_packages           = [ 'rubygem-json', 'ruby-json' ]
          $service_file_location   = '/etc/init.d/jira'
          $service_file_template   = 'jira/jira.initscript.erb'
          $service_lockfile        = '/var/lock/jira'
          $service_provider        = 'debian'
        } default: {
          if versioncmp($::operatingsystemmajrelease, '8') >= 0 {
            $json_packages           = 'ruby-json'
            $service_file_location   = '/lib/systemd/system/jira.service'
            $service_file_template   = 'jira/jira.service.erb'
            $service_lockfile        = '/var/lock/subsys/jira'
            $service_provider        = 'systemd'
          } else {
            $json_packages           = [ 'rubygem-json', 'ruby-json' ]
            $service_file_location   = '/etc/init.d/jira'
            $service_file_template   = 'jira/jira.initscript.erb'
            $service_lockfile        = '/var/lock/jira'
            $service_provider        = 'debian'
          }
        }
      }
    } default: {
        $json_packages           = [ 'rubygem-json', 'ruby-json' ]
        $service_file_location   = '/etc/init.d/jira'
        $service_file_template   = 'jira/jira.initscript.erb'
        $service_lockfile        = '/var/lock/subsys/jira'
        $service_provider        = undef
    }
  }
}
