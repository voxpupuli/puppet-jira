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
      it { should contain_file('/home/jira/dbconfig.xml')
        .with_content(/<url>jdbc:postgresql:\/\/localhost:5432\/jira<\/url>/) }
    end
    context 'mysql params' do
      let(:params) {{
        :version  => '6.3.4a',
        :javahome => '/opt/java',
        :db       => 'mysql',
      }}
      it { should contain_file('/opt/jira/atlassian-jira-6.3.4a-standalone/bin/setenv.sh')}
      it { should contain_file('/opt/jira/atlassian-jira-6.3.4a-standalone/bin/user.sh')}
      it { should contain_file('/opt/jira/atlassian-jira-6.3.4a-standalone/conf/server.xml')}
      it { should contain_file('/home/jira/dbconfig.xml')
        .with_content(/<url>jdbc:mysql:\/\/localhost:5432\/jira\?useUnicode=true&amp;characterEncoding=UTF8&amp;sessionVariables=storage_engine=InnoDB<\/url>/) }
    end
    context 'custom dburl' do
      let(:params) {{
        :version  => '6.3.4a',
        :javahome => '/opt/java',
        :dburl    => 'my custom dburl',
      }}
      it { should contain_file('/home/jira/dbconfig.xml')
        .with_content(/<url>my custom dburl<\/url>/) }
    end
  end
end
