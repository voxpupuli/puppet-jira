require 'spec_helper.rb'

describe 'jira' do
  describe 'jira::service' do
    context 'default params' do
      let(:params) {{
        :javahome => '/opt/java',
      }}
      it { should contain_service('jira')}
      it { should contain_file('/etc/init.d/jira')
        .with_content(/Short-Description: Start up JIRA/)
        .with_content(/lockfile=\/var\/lock\/subsys\/jira/)
      }  
      it { should_not contain_file('/usr/lib/systemd/system/jira.service')
        .with_content(/Atlassian Systemd Jira Service/) }
      it { should_not contain_exec('refresh_systemd') }
    end
    context 'lockfile on Debian' do
      let(:params) {{
        :javahome => '/opt/java',
      }}
      let(:facts) {{
        :osfamily => 'Debian',
      }}
      it { should contain_file('/etc/init.d/jira')
        .with_content(/\/var\/lock\/jira/) }
    end
    context 'overwriting service_manage param' do
      let(:params) {{
        :service_manage => false,
        :javahome       => '/opt/java',
      }}
      it { should_not contain_service('jira')}
    end
    context 'overwriting service_manage param with bad boolean' do
      let(:params) {{
        :service_manage => 'false',
        :javahome       => '/opt/java',
      }}
      it do
        expect {
          should compile
        }.to raise_error(Puppet::Error, /is not a boolean/)
      end
    end
    context 'overwriting service params' do
      let(:params) {{
        :javahome       => '/opt/java',
        :service_ensure => 'stopped',
        :service_enable => false,
        :service_subscribe => 'Package[jdk]',
      }}
      it { should contain_service('jira').with({
        'ensure' => 'stopped',
        'enable' => 'false',
        'notify' => nil,
        'subscribe' => 'Package[jdk]',
      })}
    end
    context 'it notifies properly' do
      let(:params) {{
        :javahome       => '/opt/java',
        :service_notify => 'Package[jdk]',
      }}
      it { should contain_service('jira').that_notifies('Package[jdk]') }
    end
    context 'it subscribes properly' do
      let(:params) {{
        :javahome          => '/opt/java',
        :service_subscribe => 'Package[jdk]',
      }}
      it { should contain_service('jira').that_subscribes_to('Package[jdk]') }
    end
    context 'RedHat/CentOS 7 systemd init script' do
      let(:params) {{
        :javahome => '/opt/java',
      }}
      let(:facts) {{
        :osfamily                  => 'RedHat',
        :operatingsystemmajrelease => '7',
      }}
      it { should contain_file('/usr/lib/systemd/system/jira.service')
        .with_content(/Atlassian Systemd Jira Service/) }
      it { should contain_exec('refresh_systemd') }
    end

  end
end
