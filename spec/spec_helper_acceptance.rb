# This file is completely managed via modulesync
require 'voxpupuli/acceptance/spec_helper_acceptance'

configure_beaker do |_host|
  install_module_from_forge('puppetlabs-apt', '>= 4.1.0 < 8.0.0') if fact('os.family') == 'Debian'
  install_module_from_forge('puppetlabs-java', '>= 2.1.0 < 7.0.0')
  install_module_from_forge('puppetlabs-java_ks', '>= 1.6.0 < 4.0.0')
  install_module_from_forge('puppetlabs-mysql', '>= 4.0.1 < 11.0.0')
  install_module_from_forge('puppetlabs-postgresql', '>= 5.1.0 < 7.0.0')
end

Dir['./spec/support/acceptance/**/*.rb'].sort.each { |f| require f }
