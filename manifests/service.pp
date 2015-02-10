#-----------------------------------------------------------------------------
#   Copyright (c) 2012 Bryce Johnson
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#-----------------------------------------------------------------------------
class jira::service(

  $service_manage        = $jira::service_manage,
  $service_ensure        = $jira::service_ensure,
  $service_enable        = $jira::service_enable,
  $service_notify        = $jira::service_notify,
  $service_subscribe     = $jira::service_subscribe,
  $service_file_location = $jira::params::service_file_location,
  $service_file_template = $jira::params::service_file_template,
  $service_lockfile      = $jira::params::service_lockfile,

) inherits jira::params {
  
  validate_bool($service_manage)

  file { $service_file_location:
    content => template($service_file_template),
    mode    => '0755',
  }

  if $service_manage {

    validate_string($service_ensure)
    validate_bool($service_enable)

    if $::osfamily == 'RedHat' and $::operatingsystemmajrelease == '7' {
      exec { 'refresh_systemd':
        command     => 'systemctl daemon-reload',
        refreshonly => true,
        subscribe   => File[$service_file_location],
        before      => Service['jira'],
      }
    }

    service { 'jira':
      ensure    => $service_ensure,
      enable    => $service_enable,
      require   => File[$service_file_location],
      notify    => $service_notify,
      subscribe => $service_subscribe,
    }
  }
}
