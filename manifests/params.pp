# == Class: jira::params
#
# Defines default values for jira module
#
class jira::params {
  Exec { path => ['/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/'] }

  $json_packages = $facts['os']['family'] ? {
    'RedHat' => ['rubygem-json'],
    'Debian' => ['ruby-json'],
    default  => [],
  }
}
