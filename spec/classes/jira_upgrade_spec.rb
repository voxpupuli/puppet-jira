require 'spec_helper.rb'

describe 'jira' do
  describe 'jira::install' do
    context 'default params' do
      let(:params) {{
        :javahome    => '/opt/java',
      }}
      let(:facts) { {
        :jira_version  => "5.0.0",
      }}
      it { should contain_exec('service jira stop && sleep 15') }
    end
  end
end
