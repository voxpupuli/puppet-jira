require 'spec_helper.rb'

describe 'jira' do
  describe 'jira::sso' do
    context 'supported operating systems' do
      on_supported_os.each do |os, facts|
        context "on #{os} #{facts}" do
          let(:facts) do
            facts
          end
          context 'default params' do
            let(:params) {{
              :javahome   => '/opt/java',
              :version    => '6.3.4a',
              :enable_sso => true,
            }}
            it { should contain_file('/opt/jira/atlassian-jira-6.3.4a-standalone/atlassian-jira/WEB-INF/classes/seraph-config.xml') }
            it { should contain_file('/opt/jira/atlassian-jira-6.3.4a-standalone/atlassian-jira/WEB-INF/classes/crowd.properties') }
          end
          context 'with param application_name set to appname' do
            let(:params) {{
              :javahome         => '/opt/java',
              :version          => '6.3.4a',
              :enable_sso       => true,
              :application_name => 'appname',
            }}
            it { should contain_file('/opt/jira/atlassian-jira-6.3.4a-standalone/atlassian-jira/WEB-INF/classes/crowd.properties')
              .with_content(/application.name                        appname/)
            }
          end
          context 'with param application_login_url set to ERROR' do
            let(:params) {{
              :javahome              => '/opt/java',
              :version               => '6.3.4a',
              :enable_sso            => true,
              :application_login_url => 'ERROR',
            }}
            it('should fail') {
              should raise_error(Puppet::Error, /does not match/)
            }
          end
          context 'with non default params' do
            let(:params) {{
              :javahome              => '/opt/java',
              :version               => '6.3.4a',
              :enable_sso            => true,
              :application_name      => 'app',
              :application_password  => 'password',
              :application_login_url => 'https://login.url/',
              :crowd_server_url      => 'https://crowd.url/',
              :crowd_base_url        => 'http://crowdbase.url',
            }}
            it { should contain_file('/opt/jira/atlassian-jira-6.3.4a-standalone/atlassian-jira/WEB-INF/classes/seraph-config.xml') }
            it { should contain_file('/opt/jira/atlassian-jira-6.3.4a-standalone/atlassian-jira/WEB-INF/classes/crowd.properties')
              .with_content(/application.name                        app/)
              .with_content(/application.password                    password/)
              .with_content(%r{application.login.url                   https://login.url/})
              .with_content(%r{crowd.server.url                        https://crowd.url/})
              .with_content(%r{crowd.base.url                          http://crowdbase.url})
            }
          end
        end
      end
    end
  end
end
