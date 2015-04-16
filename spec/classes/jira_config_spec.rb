require 'spec_helper.rb'

describe 'jira' do
describe 'jira::config' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os} #{facts}" do
        let(:facts) do
          facts
        end
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

        context 'sqlserver params' do
          let(:params) {{
            :version  => '6.3.4a',
            :javahome => '/opt/java',
            :db       => 'sqlserver',
            :dbport   => '1433',
          }}
          it { should contain_file('/opt/jira/atlassian-jira-6.3.4a-standalone/bin/setenv.sh')}
          it { should contain_file('/opt/jira/atlassian-jira-6.3.4a-standalone/bin/user.sh')}
          it { should contain_file('/opt/jira/atlassian-jira-6.3.4a-standalone/conf/server.xml')}
          it { should contain_file('/home/jira/dbconfig.xml')
            .with_content(/<url>jdbc:jtds:sqlserver:\/\/localhost:1433\/jira<\/url>/) }
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

        context 'tomcat port' do
          let(:params) {{
            :version => '6.3.4a',
            :javahome => '/opt/java',
            :tomcatPort => '8888',
          }}
          it { should contain_file('/opt/jira/atlassian-jira-6.3.4a-standalone/conf/server.xml')
            .with_content(/port="8888"/) }
        end

        context 'tomcat acceptCount' do
          let(:params) {{
            :version => '6.3.4a',
            :javahome => '/opt/java',
            :tomcatAcceptCount => '200',
          }}
          it { should contain_file('/opt/jira/atlassian-jira-6.3.4a-standalone/conf/server.xml')
            .with_content(/acceptCount="100"/) }
        end

        context 'tomcat acceptCount' do
          let(:params) {{
            :version => '6.3.4a',
            :javahome => '/opt/java',
            :tomcatMaxThreads => '300',
          }}
          it { should contain_file('/opt/jira/atlassian-jira-6.3.4a-standalone/conf/server.xml')
            .with_content(/maxThreads="300"/) }
        end

        context 'tomcat proxy path' do
          let(:params) {{
            :version => '6.3.4a',
            :javahome => '/opt/java',
            :proxy => {
              'scheme'    => 'https',
              'proxyName' => 'www.example.com',
              'proxyPort' => '9999',
            },
          }}
          it { should contain_file('/opt/jira/atlassian-jira-6.3.4a-standalone/conf/server.xml')
            .with_content(/proxyName = 'www\.example\.com'/)
            .with_content(/scheme = 'https'/)
            .with_content(/proxyPort = '9999'/)
          }
        end

      end
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
    context 'sqlserver params' do
      let(:params) {{
        :version  => '6.3.4a',
        :javahome => '/opt/java',
        :db       => 'sqlserver',
        :dbport   => '1433',
      }}
      it { should contain_file('/opt/jira/atlassian-jira-6.3.4a-standalone/bin/setenv.sh')}
      it { should contain_file('/opt/jira/atlassian-jira-6.3.4a-standalone/bin/user.sh')}
      it { should contain_file('/opt/jira/atlassian-jira-6.3.4a-standalone/conf/server.xml')}
      it { should contain_file('/home/jira/dbconfig.xml')
        .with_content(/<url>jdbc:jtds:sqlserver:\/\/localhost:1433\/jira<\/url>/) }
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
    context 'context resources' do
      let(:params) {{
        :version => '6.3.4a',
        :javahome => '/opt/java',
        :resources => { 'testdb' => { 'auth' => 'Container' } },
      }}
      it { should contain_file('/opt/jira/atlassian-jira-6.3.4a-standalone/conf/context.xml')
        .with_content(/<Resource name = "testdb"\n        auth = "Container"\n    \/>/) }
    end
  end
end
end
