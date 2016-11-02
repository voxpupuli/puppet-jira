require 'spec_helper.rb'

describe 'jira' do
  describe 'jira::service' do
    context 'supported operating systems' do
      on_supported_os.each do |os, facts|
        context "on #{os} #{facts}" do
          let(:facts) do
            facts
          end

          if os == 'RedHat'
            context 'default params' do
              let(:params) do
                { javahome: '/opt/java' }
              end
              it { is_expected.to contain_service('jira') }
              it do
                is_expected.to contain_file('/etc/init.d/jira').
                  with_content(%r{Short-Description: Start up JIRA}).
                  with_content(%r{lockfile=/var/lock/subsys/jira})
              end
              it do
                is_expected.not_to contain_file('/usr/lib/systemd/system/jira.service').
                  with_content(%r{Atlassian Systemd Jira Service})
              end
              it { is_expected.not_to contain_exec('refresh_systemd') }
            end
          end
          if os == 'Debian'
            context 'lockfile on Debian' do
              let(:params) do
                { javahome: '/opt/java' }
              end
              let(:facts) do
                { osfamily: 'Debian' }
              end
              it do
                is_expected.to contain_file('/etc/init.d/jira').
                  with_content(%r{/var/lock/jira})
              end
            end
          end
          if os =~ %r{ubuntu}
            context 'default params' do
              let(:params) do
                { javahome: '/opt/java' }
              end
              it { is_expected.not_to contain_file('/lib/systemd/system/jira.service') }
            end
          end
          context 'overwriting service_manage param' do
            let(:params) do
              {
                service_manage: false,
                javahome: '/opt/java'
              }
            end
            it { is_expected.not_to contain_service('jira') }
          end
          context 'overwriting service_manage param with bad boolean' do
            let(:params) do
              {
                service_manage: 'false',
                javahome: '/opt/java'
              }
            end
            it { is_expected.to raise_error(Puppet::Error, %r{is not a boolean}) }
          end
          context 'overwriting service params' do
            let(:params) do
              {
                javahome: '/opt/java',
                service_ensure: 'stopped',
                service_enable: false,
                service_subscribe: 'Package[jdk]'
              }
            end
            it do
              is_expected.to contain_service('jira').with('ensure' => 'stopped',
                                                          'enable' => 'false',
                                                          'notify' => nil,
                                                          'subscribe' => 'Package[jdk]')
            end
          end
          context 'RedHat/CentOS 7 systemd init script' do
            let(:params) do
              { javahome: '/opt/java' }
            end
            let(:facts) do
              {
                osfamily: 'RedHat',
                operatingsystemmajrelease: '7'
              }
            end
            it do
              is_expected.to contain_file('/usr/lib/systemd/system/jira.service').
                with_content(%r{Atlassian Systemd Jira Service})
            end
            it { is_expected.to contain_exec('refresh_systemd') }
          end
        end
      end
    end
  end
end
