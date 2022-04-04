# frozen_string_literal: true

# This file is completely managed via modulesync
require 'voxpupuli/acceptance/spec_helper_acceptance'

configure_beaker do |host|
  install_module_from_forge_on(host, 'puppetlabs-apt', '>= 4.1.0 < 9.0.0') if fact_on(host, 'os.family') == 'Debian'
  install_module_from_forge_on(host, 'puppetlabs-java', '>= 2.1.0 < 8.0.0')
  install_module_from_forge_on(host, 'puppetlabs-java_ks', '>= 1.6.0 < 4.0.0')
  install_module_from_forge_on(host, 'puppetlabs-mysql', '>= 4.0.1 < 13.0.0')
  install_module_from_forge_on(host, 'puppetlabs-postgresql', '>= 5.1.0 < 8.0.0')
end

Dir['./spec/support/acceptance/**/*.rb'].sort.each { |f| require f }
