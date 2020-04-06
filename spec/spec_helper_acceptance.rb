require 'voxpupuli/acceptance/spec_helper_acceptance'

configure_beaker do |host|
  if fact_on(host, 'os.name') == 'CentOS'
    install_module_from_forge_on(host, 'puppetlabs-apt', '>= 4.1.0 < 7.0.0')
    install_module_from_forge_on(host, 'puppetlabs-java', '>= 2.1.0 < 4.0.0')
    install_module_from_forge_on(host, 'puppetlabs-java_ks', '>= 1.6.0 < 3.0.0')
    install_module_from_forge_on(host, 'puppetlabs-mysql', '>= 4.0.1 < 7.0.0')
    install_module_from_forge_on(host, 'puppetlabs-postgresql', '>= 5.1.0 < 6.0.0')
  end
end
