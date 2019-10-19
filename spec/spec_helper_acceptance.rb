require 'beaker-rspec'
require 'beaker-puppet'
require 'beaker/puppet_install_helper'
require 'beaker/module_install_helper'

run_puppet_install_helper unless ENV['BEAKER_provision'] == 'no'

RSpec.configure do |c|
  # Readable test descriptions
  c.formatter = :documentation
  #
  # Configure all nodes in nodeset
  c.before :suite do
    install_module
    install_module_dependencies

    install_module_from_forge('puppetlabs-apt', '>= 4.1.0 < 7.0.0')
    install_module_from_forge('puppetlabs-java', '>= 2.1.0 < 4.0.0')
    install_module_from_forge('puppetlabs-java_ks', '>= 1.6.0 < 3.0.0')
    install_module_from_forge('puppetlabs-mysql', '>= 4.0.1 < 7.0.0')
    install_module_from_forge('puppetlabs-postgresql', '>= 5.1.0 < 6.0.0')
  end
end
