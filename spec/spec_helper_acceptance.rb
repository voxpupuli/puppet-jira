require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'

proxyurl = ENV['http_proxy'] if ENV['http_proxy']

unless ENV['RS_PROVISION'] == 'no' or ENV['BEAKER_provision'] == 'no'
  hosts.each do |host|
    if proxyurl
      # Set proxy for everything
      on host, "echo 'proxy = #{proxyurl}' >> /root/.curlrc; exit 0"
      on host, "echo \"---\nhttp-proxy: #{proxyurl}\" >> /root/.gemrc"
      on host, "echo 'export http_proxy=#{proxyurl}' >> /root/.bashrc"
      on host, "echo 'export https_proxy=#{proxyurl}' >> /root/.bashrc"
      on host, 'echo "use_proxy = off" >> /etc/wgetrc'
      # Allow proxy to cache better
      on host, 'rm -f /etc/yum/pluginconf.d/fastestmirror.conf; exit 0'
      on host, "sed -i 's/^mirrorlist=/#mirrorlist=/g'  /etc/yum.repos.d/*; exit 0"
      on host, "sed -i 's/#baseurl=/baseurl=/g' /etc/yum.repos.d/*; exit 0"
    end
    # This will install the latest available package on el and deb based
    # systems fail on windows and osx, and install via gem on other *nixes
    foss_opts = { :default_action => 'gem_install' }
    if default.is_pe?; then
      # TODO: fetch_http_dir hangs
      # fetch_http_dir('http://10.43.230.24/el-6-x86_64','/opt/enterprise/dists/LATEST')
      # TODO: install_pe doesnt work nativy, needs some work on my part
      on host, 'wget -nv -P /opt/enterprise/dists/LATEST --reject "index.html*","*.gif" --cut-dirs=1 -np -nH --no-check-certificate -r http://10.43.230.24/el-6-x86_64/'
      on host, ' yum localinstall -y /opt/enterprise/dists/LATEST/*.rpm'
    else
      install_puppet( foss_opts )
    end
    on host, "mkdir -p #{host['distmoduledir']}"
    # Set puppet proxy, TODO: This is still hard coded
    if proxyurl
      on host, "echo \"[user]\nhttp_proxy_host = 10.203.72.21\" >> #{host['puppetpath']}/puppet.conf"
      on host, "echo \"http_proxy_port = 7070\" >> #{host['puppetpath']}/puppet.conf"
      on host, "sed -i '/templatedir/d' #{host['puppetpath']}/puppet.conf"
    end
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
#        if proxyurl
#          on host, "apt-key adv --keyserver-options http-proxy=#{proxyurl} --keyserver keyserver.ubuntu.com --recv-key 'ACCC5CF8'"
#        end
      end
      on host, puppet('module','install','puppetlabs-stdlib'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module','install','puppetlabs-postgresql'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module','install','yguenane-repoforge'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module','install','mkrakowitzer-deploy'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module','install','puppetlabs-java'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module','install','nanliu-staging'), { :acceptable_exit_codes => [0,1] }
    end
  end
end
