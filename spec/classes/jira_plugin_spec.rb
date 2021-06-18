require 'spec_helper.rb'

describe 'jira' do
  describe 'jira::plugin' do
    context 'supported operating systems' do
      on_supported_os.each do |os, facts|
        context "on #{os}" do
          let(:facts) do
            facts
          end

          context 'simple plugin download' do
            let :params do
              {
                'javahome': '/opt/java',
                'use_jndi_ds': true,
                'jndi_ds_name': 'TestJndiDSName',
                'plugins': {
                  'test.jar': {
                    source: 'https://www.example.com/fine-jira-plugin.tgz',
                    username: 'TheUser',
                    password: 'ThePassword',
                    checksum: '123abc',
                    checksum_type: 'sha512',
                  }
                }
              }
            end

            it { is_expected.to compile.with_all_deps }

            it do
              is_expected.to contain_archive('/opt/jira/atlassian-jira-software-8.13.5-standalone/atlassian-jira/WEB-INF/lib/test.jar')
                               .with({
                                       'source' => 'https://www.example.com/fine-jira-plugin.tgz',
                                       'ensure' => 'present',
                                       'username' => 'TheUser',
                                       'password' => 'ThePassword',
                                       'checksum' => '123abc',
                                       'checksum_type' => 'sha512',
                                     })
            end

            it do
              is_expected.to contain_file('/opt/jira/atlassian-jira-software-8.13.5-standalone/conf/server.xml')
                               .with_content(%r{Resource name="jdbc/TestJndiDSName"})
            end

            context 'ensure absent marked plugin isn\'t downloaded' do
              let :params do
                {
                  'javahome': '/opt/java',
                  'plugins': {
                    'test.jar': { 'ensure': 'absent' }
                  }
                }
              end

              it do
                is_expected.to contain_archive('/opt/jira/atlassian-jira-software-8.13.5-standalone/atlassian-jira/WEB-INF/lib/test.jar')
                                 .with({ 'ensure' => 'absent' })
              end
            end

            context 'ensure DS is correctly created' do
              let :params do
                {
                  'javahome': '/opt/java',
                  'use_jndi_ds': true,
                  'jndi_ds_name': 'TestJndiDSName'
                }
              end

              it do
                is_expected.to contain_file('/opt/jira/atlassian-jira-software-8.13.5-standalone/conf/server.xml')
                                 .with_content(%r{Resource name="jdbc/TestJndiDSName"})
              end

            end
          end
        end
      end
    end
  end
end
