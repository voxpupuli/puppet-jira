node default {
    class { 'jira::facts': }

    package {'jdk':
      ensure => absent,
    }
}
