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
          it { should contain_file('/opt/jira/atlassian-jira-6.3.4a-standalone/bin/setenv.sh')
            .with_content(/#DISABLE_NOTIFICATIONS=/) }
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

        context 'customise tomcat connector' do
          let(:params) {{
            :version  => '6.3.4a',
            :javahome => '/opt/java',
            :tomcatPort => '9229',
          }}
          it { should contain_file('/opt/jira/atlassian-jira-6.3.4a-standalone/conf/server.xml')
            .with_content(/<Connector port=\"9229\"\s+maxThreads=/m) }
        end

        context 'customise tomcat connector with a binding address' do
          let(:params) {{
            :version  => '6.3.4a',
            :javahome => '/opt/java',
            :tomcatPort => '9229',
            :tomcatAddress => '127.0.0.1'
          }}
          it { should contain_file('/opt/jira/atlassian-jira-6.3.4a-standalone/conf/server.xml')
            .with_content(/<Connector port=\"9229\"\s+address=\"127\.0\.0\.1\"\s+maxThreads=/m) }
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
            .with_content(/acceptCount="200"/) }
        end

        context 'tomcat MaxHttpHeaderSize' do
          let(:params) {{
            :version => '6.3.4a',
            :javahome => '/opt/java',
            :tomcatMaxHttpHeaderSize => '4096',
          }}
          it { should contain_file('/opt/jira/atlassian-jira-6.3.4a-standalone/conf/server.xml')
            .with_content(/maxHttpHeaderSize="4096"/) }
        end

        context 'tomcat MinSpareThreads' do
          let(:params) {{
            :version => '6.3.4a',
            :javahome => '/opt/java',
            :tomcatMinSpareThreads => '50',
          }}
          it { should contain_file('/opt/jira/atlassian-jira-6.3.4a-standalone/conf/server.xml')
            .with_content(/minSpareThreads="50"/) }
        end

        context 'tomcat ConnectionTimeout' do
          let(:params) {{
            :version => '6.3.4a',
            :javahome => '/opt/java',
            :tomcatConnectionTimeout => '25000',
          }}
          it { should contain_file('/opt/jira/atlassian-jira-6.3.4a-standalone/conf/server.xml')
            .with_content(/connectionTimeout="25000"/) }
        end

        context 'tomcat EnableLookups' do
          let(:params) {{
            :version => '6.3.4a',
            :javahome => '/opt/java',
            :tomcatEnableLookups => 'true',
          }}
          it { should contain_file('/opt/jira/atlassian-jira-6.3.4a-standalone/conf/server.xml')
            .with_content(/enableLookups="true"/) }
        end

        context 'tomcat Protocol' do
          let(:params) {{
            :version => '6.3.4a',
            :javahome => '/opt/java',
            :tomcatProtocol => 'HTTP/1.1',
          }}
          it { should contain_file('/opt/jira/atlassian-jira-6.3.4a-standalone/conf/server.xml')
            .with_content(/protocol="HTTP\/1.1"/) }
        end

        context 'tomcat UseBodyEncodingForURI' do
          let(:params) {{
            :version => '6.3.4a',
            :javahome => '/opt/java',
            :tomcatUseBodyEncodingForURI => 'false',
          }}
          it { should contain_file('/opt/jira/atlassian-jira-6.3.4a-standalone/conf/server.xml')
            .with_content(/useBodyEncodingForURI="false"/) }
        end

        context 'tomcat DisableUploadTimeout' do
          let(:params) {{
            :version => '6.3.4a',
            :javahome => '/opt/java',
            :tomcatDisableUploadTimeout => 'false',
          }}
          it { should contain_file('/opt/jira/atlassian-jira-6.3.4a-standalone/conf/server.xml')
            .with_content(/disableUploadTimeout="false"/) }
        end

        context 'tomcat EnableLookups' do
          let(:params) {{
            :version => '6.3.4a',
            :javahome => '/opt/java',
            :tomcatEnableLookups => 'true',
          }}
          it { should contain_file('/opt/jira/atlassian-jira-6.3.4a-standalone/conf/server.xml')
            .with_content(/enableLookups="true"/) }
        end

        context 'tomcat maxThreads' do
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

        context 'ajp proxy' do
          context 'with valid config including protocol AJP/1.3' do
            let(:params) {{
              :version => '6.3.4a',
              :javahome => '/opt/java',
              :ajp => {
                'port' => '8009',
                'protocol' => 'AJP/1.3',
              },
            }}
            it { should contain_file('/opt/jira/atlassian-jira-6.3.4a-standalone/conf/server.xml')
              .with_content(/<Connector enableLookups="false" URIEncoding="UTF-8"\s+port = "8009"\s+protocol = "AJP\/1\.3"\s+\/>/) }
          end
          context 'with valid config including protocol org.apache.coyote.ajp.AjpNioProtocol' do
            let(:params) {{
              :version => '6.3.4a',
              :javahome => '/opt/java',
              :ajp => {
                'port' => '8009',
                'protocol' => 'org.apache.coyote.ajp.AjpNioProtocol',
              },
            }}
            it { should contain_file('/opt/jira/atlassian-jira-6.3.4a-standalone/conf/server.xml')
              .with_content(/<Connector enableLookups="false" URIEncoding="UTF-8"\s+port = "8009"\s+protocol = "org\.apache\.coyote\.ajp\.AjpNioProtocol"\s+\/>/) }
          end
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

        context 'disable notifications' do
          let(:params) {{
            :version  => '6.3.4a',
            :javahome => '/opt/java',
            :disable_notifications => true,
          }}
          it { should contain_file('/opt/jira/atlassian-jira-6.3.4a-standalone/bin/setenv.sh')
            .with_content(/^DISABLE_NOTIFICATIONS=/) }
        end

        context 'native ssl support default params' do
          let(:params) {{
            :version => '6.3.4a',
            :javahome => '/opt/java',
            :tomcatNativeSsl => true,
          }}
          it { should contain_file('/opt/jira/atlassian-jira-6.3.4a-standalone/conf/server.xml')
            .with_content(/redirectPort="8443"/)
            .with_content(/port="8443"/)
            .with_content(/keyAlias="jira"/)
            .with_content(/keystoreFile="\/home\/jira\/jira\.jks"/)
            .with_content(/keystorePass="changeit"/)
            .with_content(/keystoreType="JKS"/)
            .with_content(/port="8443".*acceptCount="100"/m)
            .with_content(/port="8443".*maxThreads="150"/m)
          }
        end

        context 'native ssl support custom params' do
          let(:params) {{
            :version => '6.3.4a',
            :javahome => '/opt/java',
            :tomcatNativeSsl => true,
            :tomcatHttpsPort => '9443',
            :tomcatAddress => '127.0.0.1',
            :tomcatMaxThreads => '600',
            :tomcatAcceptCount => '600',
            :tomcatKeyAlias => 'keystorealias',
            :tomcatKeystoreFile => '/tmp/keyfile.ks',
            :tomcatKeystorePass => 'keystorepass',
            :tomcatKeystoreType => 'PKCS12',
          }}
          it { should contain_file('/opt/jira/atlassian-jira-6.3.4a-standalone/conf/server.xml')
            .with_content(/redirectPort="9443"/)
            .with_content(/port="9443"/)
            .with_content(/keyAlias="keystorealias"/)
            .with_content(/keystoreFile="\/tmp\/keyfile\.ks\"/)
            .with_content(/keystorePass="keystorepass"/)
            .with_content(/keystoreType="PKCS12"/)
            .with_content(/port="9443".*acceptCount="600"/m)
            .with_content(/port="9443".*maxThreads="600"/m)
            .with_content(/port="9443".*address="127\.0\.0\.1"/m)
          }
        end

      end
    end
  end
end
end
