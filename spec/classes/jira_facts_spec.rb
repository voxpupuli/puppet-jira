require 'spec_helper.rb'
describe 'jira::facts' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end
        let(:pre_condition) { "class{'::jira': javahome => '/opt/java'}" }

        it { is_expected.to compile.with_all_deps }

        context 'with puppet AIO' do
          let(:facts) do
            facts.merge(aio_agent_version: 'something')
          end

          it do
            is_expected.to contain_file('/etc/puppetlabs/facter/facts.d/jira_facts.rb'). \
              with_content(%r{#!/opt/puppetlabs/puppet/bin/ruby}).
              with_content(%r{http://127\.0\.0\.1:8080/rest/api/2/serverInfo})
          end

          it { is_expected.not_to contain_file('/etc/facter/facts.d/jira_facts.rb') }
          it { is_expected.not_to contain_package('rubygem-json') }
          it { is_expected.not_to contain_package('ruby-json') }
        end

        context 'with puppet oss' do
          let(:facts) do
            facts.merge(aio_agent_version: nil)
          end

          it { is_expected.not_to contain_file('/etc/puppetlabs/facter/facts.d/jira_facts.rb') }

          it do
            is_expected.to contain_file('/etc/facter/facts.d/jira_facts.rb'). \
              with_content(%r{#!/usr/bin/env ruby}).
              with_content(%r{http://127\.0\.0\.1:8080/rest/api/2/serverInfo})
          end

          case facts[:osfamily]
          when 'RedHat'
            it { is_expected.to contain_package('rubygem-json') }
          when 'Debian'
            it { is_expected.to contain_package('ruby-json') }
          end
        end

        context 'tomcat context path' do
          let(:params) do
            { contextpath: '/jira' }
          end

          it do
            is_expected.to contain_file('/etc/puppetlabs/facter/facts.d/jira_facts.rb'). \
              with_content(%r{  url = 'http://127.0.0.1:8080/jira})
          end
        end
      end
    end
  end
end
