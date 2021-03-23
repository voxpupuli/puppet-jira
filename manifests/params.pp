# == Class: jira::params
#
# Defines default values for jira module
#
class jira::params {
  Exec { path => ['/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/'] }

  $service_file_location = '/lib/systemd/system/jira.service'
  $service_file_template = 'jira/jira.service.erb'
  $service_file_mode     = '0644'

  $json_packages = $facts['os']['family'] ? {
    'RedHat' => ['rubygem-json'],
    'Debian' => ['ruby-json'],
    default  => [],
  }
}
