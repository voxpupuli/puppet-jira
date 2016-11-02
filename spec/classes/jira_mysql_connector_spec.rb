require 'spec_helper.rb'

describe 'jira' do
  describe 'jira::mysql_connector' do
    context 'supported operating systems' do
      on_supported_os.each do |os, facts|
        context "on #{os} #{facts}" do
          let(:facts) do
            facts
          end
          context 'mysql connector defaults' do
            let(:params) do
              {
                version: '6.3.4a',
                javahome: '/opt/java',
                db: 'mysql',
                mysql_connector_version: '5.1.34'
              }
            end
            it { is_expected.to contain_file('/opt/MySQL-connector').with_ensure('directory') }
            it do
              is_expected.to contain_file('/opt/jira/atlassian-jira-6.3.4a-standalone/lib/mysql-connector-java.jar').
                with(
                  'ensure' => 'link',
                  'target' => '/opt/MySQL-connector/mysql-connector-java-5.1.34/mysql-connector-java-5.1.34-bin.jar'
                )
            end
            it 'deploys mysql connector 5.1.34 from tar.gz' do
              is_expected.to contain_staging__file('mysql-connector-java-5.1.34.tar.gz').with('source' => 'https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.34.tar.gz')
              is_expected.to contain_staging__extract('mysql-connector-java-5.1.34.tar.gz').with('target' => '/opt/MySQL-connector',
                                                                                                 'creates' => '/opt/MySQL-connector/mysql-connector-java-5.1.34')
            end
          end
          context 'mysql connector overwrite params' do
            let(:params) do
              {
                version: '6.3.4a',
                javahome: '/opt/java',
                db: 'mysql',
                mysql_connector_version: '5.1.15',
                mysql_connector_format: 'zip',
                mysql_connector_install: '/opt/foo',
                mysql_connector_url: 'http://example.co.za/foo'
              }
            end
            it { is_expected.to contain_file('/opt/foo').with_ensure('directory') }
            it do
              is_expected.to contain_file('/opt/jira/atlassian-jira-6.3.4a-standalone/lib/mysql-connector-java.jar').
                with(
                  'ensure' => 'link',
                  'target' => '/opt/foo/mysql-connector-java-5.1.15/mysql-connector-java-5.1.15-bin.jar'
                )
            end
            it 'deploys mysql connector 5.1.15 from zip' do
              is_expected.to contain_staging__file('mysql-connector-java-5.1.15.zip').with('source' => 'http://example.co.za/foo/mysql-connector-java-5.1.15.zip')
              is_expected.to contain_staging__extract('mysql-connector-java-5.1.15.zip').with('target' => '/opt/foo',
                                                                                              'creates' => '/opt/foo/mysql-connector-java-5.1.15')
            end
          end
          context 'mysql_connector_mangage equals false' do
            let(:params) do
              {
                version: '6.3.4a',
                javahome: '/opt/java',
                db: 'mysql',
                mysql_connector_manage: false
              }
            end
            it { is_expected.not_to contain_class('jira::mysql_connector') }
          end
        end
      end
    end
  end
end
