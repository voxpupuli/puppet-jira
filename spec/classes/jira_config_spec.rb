require 'spec_helper.rb'

describe 'jira' do
  describe 'jira::config' do
    context 'default params' do
      let(:params) {{
        :version  => '6.3.4a',
        :javahome => '/opt/java',
      }}
      it { should contain_file('/opt/jira/atlassian-jira-6.3.4a-standalone/bin/setenv.sh')}
      it { should contain_file('/opt/jira/atlassian-jira-6.3.4a-standalone/bin/user.sh')}
      it { should contain_file('/opt/jira/atlassian-jira-6.3.4a-standalone/conf/server.xml')}
      it { should contain_file('/home/jira/dbconfig.xml')}
    end
  end
end
