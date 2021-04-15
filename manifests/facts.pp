# == Class: jira::facts
#
# Class to add some facts for JIRA. They have been added as an external fact
# because we do not want to distrubute these facts to all systems.
#
# === Parameters
#
# [*port*]
#   port that jira listens on.
# [*uri*]
#   ip that jira is listening on, defaults to localhost.
#
# === Examples
#
# class { 'jira::facts': }
#
class jira::facts (
  $ensure        = 'present',
  $port          = $jira::tomcat_port,
  $contextpath   = $jira::contextpath,
  $json_packages = $jira::params::json_packages,
  $uri           = pick($jira::tomcat_address, 'localhost')
) inherits jira::params {
  if $facts['aio_agent_version'] =~ String[1] {
    $ruby_bin = '/opt/puppetlabs/puppet/bin/ruby'
    $dir      = '/etc/puppetlabs/facter'
  } else {
    $ruby_bin = '/usr/bin/env ruby'
    $dir = '/etc/facter'

    ensure_packages ($json_packages, { ensure => present })
  }

  if !defined(File[$dir]) {
    file { $dir:
      ensure => directory,
    }
  }
  if !defined(File["${dir}/facts.d"]) {
    file { "${dir}/facts.d":
      ensure => directory,
    }
  }

  file { "${dir}/facts.d/jira_facts.rb":
    ensure  => $ensure,
    content => epp('jira/facts.rb.epp'),
    mode    => '0755',
  }
}
