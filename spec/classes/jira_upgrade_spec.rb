# frozen_string_literal: true

require 'spec_helper'

describe 'jira' do
  describe 'jira::install' do
    context 'supported operating systems' do
      on_supported_os.each do |os, facts|
        context "on #{os}" do
          let(:facts) do
            facts
          end

          context 'default params' do
            let(:params) do
              { javahome: '/opt/java' }
            end
            let(:facts) do
              facts.merge(jira_version: '8.0.0')
            end

            it { is_expected.to compile.with_all_deps }

            it do
              is_expected.to contain_exec('stop-jira-for-version-change').
                with_command('systemctl stop jira.service && sleep 15')
            end
          end

          context 'custom params' do
            let(:params) do
              {
                javahome: '/opt/java',
                stop_jira: 'stop service please'
              }
            end
            let(:facts) do
              facts.merge(jira_version: '8.0.0')
            end

            it do
              is_expected.to contain_exec('stop-jira-for-version-change').
                with_command('stop service please')
            end
          end
        end
      end
    end
  end
end
