require 'spec_helper.rb'
describe 'jira' do
  describe 'jira::facts' do
    let(:params) {{
      :javahome => '/opt/java',
    }}
    regexp_pe = /^#\!\/opt\/puppet\/bin\/ruby$/
    regexp_oss = /^#\!\/usr\/bin\/env ruby$/
    regexp_url = /http\:\/\/127\.0\.0\.1\:8080\/rest\/api\/2\/serverInfo/
    pe_external_fact_file = '/etc/puppetlabs/facter/facts.d/jira_facts.rb'
    external_fact_file = '/etc/facter/facts.d/jira_facts.rb'

    it { should contain_file(external_fact_file) }

    # Test puppet enterprise shebang generated correctly
    context 'with puppet enterprise' do
        let(:facts) { {:puppetversion => "3.4.3 (Puppet Enterprise 3.2.1)"} }
        it do
          should contain_file(pe_external_fact_file) \
            .with_content(regexp_pe) \
            .with_content(regexp_url)
        end
    end
    # Test puppet oss shebang generated correctly
    context 'with puppet oss' do
        let(:facts) { {:puppetversion => "all other versions"} }
        it do
          should contain_file(external_fact_file) \
            .with_content(regexp_oss) \
            .with_content(regexp_url)
        end
    end
  end
end
