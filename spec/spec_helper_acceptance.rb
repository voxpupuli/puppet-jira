require 'beaker-rspec'
require 'beaker/puppet_install_helper'
require 'beaker/module_install_helper'

run_puppet_install_helper
install_module
install_module_dependencies

# Install soft deps
install_module_from_forge('puppetlabs-apt', '>= 4.1.0 < 5.0.0')
install_module_from_forge('puppetlabs-java', '>= 2.1.0 < 3.0.0')
install_module_from_forge('puppetlabs-java_ks', '>= 1.6.0 < 2.0.0')
install_module_from_forge('puppetlabs-mysql', '>= 4.0.1 < 5.0.0')
install_module_from_forge('puppetlabs-postgresql', '>= 5.1.0 < 6.0.0')

UNSUPPORTED_PLATFORMS = %w[AIX windows Solaris].freeze

RSpec.configure do |c|
  # Readable test descriptions
  c.formatter = :documentation

  c.before :suite do
    hosts.each do |host|
      # Not sure if this should move into the spec itself; leaving here for now
      next unless fact('osfamily') == 'Debian'
      on host, 'apt-get install -y locales apt-transport-https'
      on host, "echo \"en_US ISO-8859-1\nen_NG.UTF-8 UTF-8\nen_US.UTF-8 UTF-8\n\" > /etc/locale.gen"
      on host, '/usr/sbin/locale-gen'
      on host, '/usr/sbin/update-locale'
    end
  end
end
