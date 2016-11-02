require 'spec_helper.rb'
describe 'jira::facts' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os} #{facts}" do
        let(:facts) do
          facts
        end
        let(:pre_condition) { "class{'::jira': javahome => '/opt/java'}" }
        regexp_pe = %r{^#\!/opt/puppet/bin/ruby$}
        regexp_oss = %r{^#\!/usr/bin/env ruby$}
        regexp_url = %r{http://127.0.0.1\:8080/rest/api/2/serverInfo}
        pe_external_fact_file = '/etc/puppetlabs/facter/facts.d/jira_facts.rb'
        external_fact_file = '/etc/facter/facts.d/jira_facts.rb'

        it { is_expected.to contain_file(external_fact_file) }

        # Test puppet enterprise shebang generated correctly
        context 'with puppet enterprise' do
          let(:facts) do
            facts.merge(puppetversion: '3.4.3 (Puppet Enterprise 3.2.1)')
          end
          it do
            is_expected.to contain_file(pe_external_fact_file). \
              with_content(regexp_pe).
              with_content(regexp_url)
          end
        end
        # Test puppet oss shebang generated correctly
        context 'with puppet oss' do
          let(:facts) do
            facts.merge(puppetversion: 'all other versions')
          end
          it do
            is_expected.to contain_file(external_fact_file). \
              with_content(regexp_oss). \
              with_content(regexp_url)
          end
        end

        context 'tomcat context path' do
          let(:params) do
            { contextpath: '/jira' }
          end
          it do
            is_expected.to contain_file(external_fact_file). \
              with_content(%r{  url = 'http://127.0.0.1:8080/jira})
          end
        end
      end
    end
  end
end
