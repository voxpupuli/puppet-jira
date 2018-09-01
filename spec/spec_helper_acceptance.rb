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

install_module_from_forge('puppetlabs-apt', '>= 4.1.0 < 7.0.0')
install_module_from_forge('puppetlabs-java', '>= 2.1.0 < 4.0.0')
install_module_from_forge('puppetlabs-java_ks', '>= 1.6.0 < 2.0.0')
install_module_from_forge('puppetlabs-mysql', '>= 4.0.1 < 6.0.0')
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
