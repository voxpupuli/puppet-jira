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
      it { should contain_package('mysql-connector-java').with_ensure('installed')}
      it { should contain_file('/opt/jira/atlassian-jira-6.3.4a-standalone/lib/mysql-connector-java.jar')
        .with(
          'ensure' => 'link',
          'target' => '/usr/share/java/mysql-connector-java.jar',
         )
      }
    end
    context 'mysql params on Debian' do
      let(:facts) { {
        :osfamily  => 'Debian',
      }}
      let(:params) {{
        :version  => '6.3.4a',
        :javahome => '/opt/java',
        :db       => 'mysql',
      }}
      it { should contain_package('libmysql-java').with_ensure('installed')}
      it { should contain_file('/opt/jira/atlassian-jira-6.3.4a-standalone/lib/mysql-connector-java.jar')
        .with(
          'ensure' => 'link',
          'target' => '/usr/share/java/mysql.jar',
         )
      }
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
    context 'tomcat context path' do
      let(:params) {{
        :version => '6.3.4a',
        :javahome => '/opt/java',
        :contextpath => '/jira',
      }}
      it { should contain_file('/opt/jira/atlassian-jira-6.3.4a-standalone/conf/server.xml')
        .with_content(/<Context path=\"\/jira\" docBase=\"\${catalina.home}\/atlassian-jira\" reloadable=\"false\" useHttpOnly=\"true\">/) }
    end

  end
end
