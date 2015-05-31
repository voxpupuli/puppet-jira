require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'

proxyurl = ENV['http_proxy'] if ENV['http_proxy']

unless ENV['RS_PROVISION'] == 'no' or ENV['BEAKER_provision'] == 'no'
  hosts.each do |host|
    foss_opts = { :default_action => 'gem_install' }
    install_puppet( foss_opts )
    on host, "mkdir -p #{host['distmoduledir']}"
    on host, "sed -i '/templatedir/d' #{host['puppetpath']}/puppet.conf"
  end
end

UNSUPPORTED_PLATFORMS = ['AIX','windows','Solaris']

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # Install module
    puppet_module_install(
      :source => proj_root,
      :module_name => 'jira',
      :ignore_list => [ 'spec/fixtures/*', '.git/*', '.vagrant/*' ],
    )
    hosts.each do |host|
      on host, "/bin/touch #{default['puppetpath']}/hiera.yaml"
      on host, 'chmod 755 /root'
      if fact('osfamily') == 'Debian'
        on host, "echo \"en_US ISO-8859-1\nen_NG.UTF-8 UTF-8\nen_US.UTF-8 UTF-8\n\" > /etc/locale.gen"
        on host, '/usr/sbin/locale-gen'
        on host, '/usr/sbin/update-locale'
      end
      on host, puppet('module','install','puppetlabs-stdlib'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module','install','puppetlabs-postgresql'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module','install','puppetlabs-mysql'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module','install','puppetlabs-java_ks'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module','install','mkrakowitzer-deploy'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module','install','nanliu-staging'), { :acceptable_exit_codes => [0,1] }
    end
  end
end
