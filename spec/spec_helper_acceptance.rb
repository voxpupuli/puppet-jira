# frozen_string_literal: true

# This file is completely managed via modulesync
require 'voxpupuli/acceptance/spec_helper_acceptance'

configure_beaker do |host|
  install_puppet_module_via_pmt_on(host, 'puppetlabs-apt') if fact_on(host, 'os.family') == 'Debian'
  install_puppet_module_via_pmt_on(host, 'puppetlabs-java')
  install_puppet_module_via_pmt_on(host, 'puppetlabs-java_ks')
  install_puppet_module_via_pmt_on(host, 'puppetlabs-mysql')
  install_puppet_module_via_pmt_on(host, 'puppetlabs-postgresql')
end

Dir['./spec/support/acceptance/**/*.rb'].sort.each { |f| require f }
