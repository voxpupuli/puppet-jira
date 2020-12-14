# == Class: jira::params
#
# Defines default values for jira module
#
class jira::params {
  Exec { path => ['/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/'] }

  case $facts['os']['family'] {
    /RedHat/: {
      if $facts['os']['name'] == 'Amazon' and $facts['os']['release']['major'] =='2018' {
        $json_packages         = ['rubygem-json']
        $service_file_location = '/etc/init.d/jira'
        $service_file_template = 'jira/jira.initscript.erb'
        $service_file_mode     = '0755'
        $service_lockfile      = '/var/lock/subsys/jira'
        $service_provider      = undef
      } elsif versioncmp($facts['os']['release']['major'], '7') >= 0 {
        $json_packages         = ['rubygem-json']
        $service_file_location = '/usr/lib/systemd/system/jira.service'
        $service_file_template = 'jira/jira.service.erb'
        $service_file_mode     = '0644'
        $service_lockfile      = '/var/lock/subsys/jira'
        $service_provider      = 'systemd'
      } else {
      fail("\"${module_name}\" provides no service parameters
            for \"${facts['os']['family']}\" - \"${$facts['os']['release']['major']}\"")
      }
    }
    /Debian/: {
      $json_packages         = ['ruby-json']
      $service_file_location = '/lib/systemd/system/jira.service'
      $service_file_template = 'jira/jira.service.erb'
      $service_file_mode     = '0644'
      $service_lockfile      = '/var/lock/subsys/jira'
      $service_provider      = 'systemd'
    }
    default: {
      $json_packages         = ['rubygem-json', 'ruby-json']
      $service_file_location = '/etc/init.d/jira'
      $service_file_template = 'jira/jira.initscript.erb'
      $service_file_mode     = '0755'
      $service_lockfile      = '/var/lock/subsys/jira'
      $service_provider      = undef
    }
  }
}
