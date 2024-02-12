# frozen_string_literal: true

require 'spec_helper'

describe 'jira' do
  describe 'jira::service' do
    context 'supported operating systems' do
      on_supported_os.each do |os, facts|
        context "on #{os}" do
          let(:facts) do
            facts
          end
          let(:params) do
            { javahome: '/opt/java' }
          end
          let(:pre_condition) do
            'package { "jdk": }'
          end

          context 'with defaults for all parameters' do
            it { is_expected.to compile.with_all_deps }

            it do
              is_expected.to contain_file('/etc/systemd/system/jira.service').
                with_content(%r{Atlassian Systemd Jira Service})
            end

            it { is_expected.to contain_service('jira') }
          end

          context 'with service_manage set to false' do
            let(:params) do
              super().merge(service_manage: false)
            end

            it { is_expected.not_to contain_service('jira') }
          end

          context 'with service_ensure set to stopped' do
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
        end
      end
    end
  end
end
