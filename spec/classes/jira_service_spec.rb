require 'spec_helper.rb'

describe 'jira' do
  describe 'jira::service' do
    context 'supported operating systems' do
      on_supported_os.each do |os, facts|
        context "on #{os}" do
          let(:facts) do
            facts.merge(os: { family: facts['osfamily'] })
          end
          let(:params) do
            { javahome: '/opt/java' }
          end
          let(:pre_condition) do
            'package { "jdk": }'
          end

          if os == 'RedHat'
            context 'default params' do
              it { is_expected.to contain_service('jira') }
              it { is_expected.to compile.with_all_deps }
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
              it { is_expected.to compile.with_all_deps }
              it do
                is_expected.to contain_file('/etc/init.d/jira').
                  with_content(%r{/var/lock/jira})
              end
            end
          end
          if os =~ %r{ubuntu}
            context 'default params' do
              it { is_expected.to compile.with_all_deps }
            end
          end
          if os =~ %r{ubuntu-12}
            context 'default params' do
              let(:facts) do
                facts.merge( operatingsystem: 'Ubuntu', operatingsystemmajrelease: '12.04')
              end

              it { is_expected.not_to contain_file('/lib/systemd/system/jira.service') }
            end
          end
          if os =~ %r{ubuntu-14}
            context 'default params' do
              let(:facts) do
                facts.merge( operatingsystem: 'Ubuntu', operatingsystemmajrelease: '14.04')
              end

              it { is_expected.not_to contain_file('/lib/systemd/system/jira.service') }
            end
          end
          if os =~ %r{ubuntu-16}
            context 'default params' do
              let(:facts) do
                facts.merge( operatingsystem: 'Ubuntu', operatingsystemmajrelease: '16.04')
              end
              
              it { is_expected.to contain_file('/lib/systemd/system/jira.service') }
            end
          end
          context 'overwriting service_manage param' do
            let(:params) do
              super().merge(service_manage: false)
            end

            it { is_expected.not_to contain_service('jira') }
          end
          context 'overwriting service params' do
            let(:params) do
              super().merge(
                service_ensure: 'stopped',
                service_enable: false,
                service_subscribe: 'Package[jdk]'
              )
            end

            it do
              is_expected.to contain_service('jira').with('ensure' => 'stopped',
                                                          'enable' => 'false',
                                                          'notify' => nil,
                                                          'subscribe' => 'Package[jdk]')
            end
          end
          context 'RedHat/CentOS 7 systemd init script' do
            let(:facts) do
              {
                osfamily: 'RedHat',
                operatingsystemmajrelease: '7',
                os: { family: 'RedHat' }
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
