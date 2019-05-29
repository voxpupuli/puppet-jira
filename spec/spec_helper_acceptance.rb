require 'beaker-rspec'
require 'beaker-puppet'
require 'beaker/puppet_install_helper'
require 'beaker/module_install_helper'

run_puppet_install_helper unless ENV['BEAKER_provision'] == 'no'
install_ca_certs unless ENV['PUPPET_INSTALL_TYPE'] =~ %r{pe}i
install_module_on(hosts)
install_module_dependencies_on(hosts)

RSpec.configure do |c|
  # Readable test descriptions
  c.formatter = :documentation
  hosts.each do |host|
    if host[:platform] =~ %r{el-7-x86_64} && host[:hypervisor] =~ %r{docker}
      on(host, "sed -i '/nodocs/d' /etc/yum.conf")
    end
  end
end

install_module_from_forge('puppetlabs-apt', '>= 4.1.0 < 8.0.0')
install_module_from_forge('puppetlabs-java', '>= 2.1.0 < 5.0.0')
install_module_from_forge('puppetlabs-java_ks', '>= 1.6.0 < 3.0.0')
install_module_from_forge('puppetlabs-mysql', '>= 4.0.1 < 10.0.0')
install_module_from_forge('puppetlabs-postgresql', '>= 5.1.0 < 6.0.0')

UNSUPPORTED_PLATFORMS = %w[AIX windows Solaris].freeze

RSpec.configure do |c|
  # Readable test descriptions
  c.formatter = :documentation
end
