require 'spec_helper.rb'

describe 'jira' do
  describe 'jira::config' do
    context 'default params' do
      let(:params) {{
        :javahome => '/opt/java',
      }}
      it { should contain_service('jira')}
    end
  end
end
