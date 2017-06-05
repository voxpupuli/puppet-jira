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
  $port          = $jira::tomcatPort,
  $uri           = $jira::tomcatAddress ? {
    undef   => '127.0.0.1',
    default => $jira::tomcatAddress,
  },
  $contextpath   = $jira::contextpath,
  $json_packages = $jira::params::json_packages,) inherits jira::params {
  # Puppet Enterprise supplies its own ruby version if your using it.
  # A modern ruby version is required to run the executable fact
  # Since PE 2015.2 the agents are All in One (AIO) wich also include it's own ruby version
  if $::puppetversion =~ /Puppet Enterprise/ {
    $ruby_bin = '/opt/puppet/bin/ruby'
    $dir = 'puppetlabs/'
  } elsif $::aio_agent_version =~ /1\.*[0-9]*\.*[0-9]*/ {
    $ruby_bin = '/opt/puppetlabs/puppet/bin/ruby'
    $dir = 'puppetlabs/'
  } else {
    $ruby_bin = '/usr/bin/env ruby'
    $dir = ''
  }

  if !defined(File["/etc/${dir}facter"]) {
    file { "/etc/${dir}facter": ensure => directory, }
  }

  if !defined(File["/etc/${dir}facter/facts.d"]) {
    file { "/etc/${dir}facter/facts.d": ensure => directory, }
  }

  # Install $json_packages only if osfamily is RedHat and agent is version PE 3.8 and less or not an AIO version 1.3.x
  if $::osfamily == 'RedHat' and (($::puppetversion !~ /Puppet Enterprise/) and ($::aio_agent_version !~ /1\.*[0-9]*\.*[0-9]*/)) {
    package { $json_packages: ensure => present, }
  }

  file { "/etc/${dir}facter/facts.d/jira_facts.rb":
    ensure  => $ensure,
    content => template('jira/facts.rb.erb'),
    mode    => '0500',
  }

}