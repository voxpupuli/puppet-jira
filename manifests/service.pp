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

# @api private
class jira::service {
  assert_private()

  systemd::unit_file { 'jira.service':
    ensure  => 'present',
    content => epp('jira/jira.service.epp'),
  }

  if $jira::service_manage {
    Systemd::Unit_file['jira.service'] ~> Service['jira']

    service { 'jira':
      ensure    => $jira::service_ensure,
      enable    => $jira::service_enable,
      notify    => $jira::service_notify,
      subscribe => $jira::service_subscribe,
    }
  }
}
