require 'beaker-rspec'
require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'
require 'beaker/puppet_install_helper'
install_puppet_agent_on hosts, {} unless ENV['BEAKER_provision'] == 'no'

UNSUPPORTED_PLATFORMS = %w(AIX windows Solaris).freeze

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    puppet_module_install(source: proj_root, module_name: 'jira')
    hosts.each do |host|
      if fact('osfamily') == 'Debian'
        on host, 'apt-get install -y locales'
        on host, "echo \"en_US ISO-8859-1\nen_NG.UTF-8 UTF-8\nen_US.UTF-8 UTF-8\n\" > /etc/locale.gen"
        on host, '/usr/sbin/locale-gen'
        on host, '/usr/sbin/update-locale'
      end
      on host, puppet('module', 'install', 'puppet-archive'), acceptable_exit_codes: [0, 1]
      on host, puppet('module', 'install', 'puppetlabs-java_ks'), acceptable_exit_codes: [0, 1]
      on host, puppet('module', 'install', 'puppetlabs-mysql'), acceptable_exit_codes: [0, 1]
      on host, puppet('module', 'install', 'puppetlabs-postgresql'), acceptable_exit_codes: [0, 1]
      on host, puppet('module', 'install', 'puppet-staging'), acceptable_exit_codes: [0, 1]
      on host, puppet('module', 'install', 'puppetlabs-stdlib'), acceptable_exit_codes: [0, 1]
    end
  end
end
