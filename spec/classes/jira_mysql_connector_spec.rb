# frozen_string_literal: true

require 'spec_helper'

# set some constants to keep it DRY
PATH_MYSQL_CONNECTOR = '/opt/MySQL-connector'
PATH_MYSQL_CONNECTOR_LIB = "#{PATH_INSTALLATION_BASE}/lib/mysql-connector-java.jar"

describe 'jira' do
  describe 'jira::mysql_connector' do
    let(:params) do
      {
        javahome: PATH_JAVA_HOME,
        version: DEFAULT_VERSION,
        db: 'mysql'
      }
    end

    context 'supported operating systems' do
      on_supported_os.each do |os, facts|
        context "on #{os}" do
          let(:facts) do
            facts
          end

          context 'mysql connector defaults' do
            let(:params) do
              super().merge(
                mysql_connector_version: '5.1.34'
              )
            end

            it { is_expected.to compile.with_all_deps }
            it { is_expected.to contain_file(PATH_MYSQL_CONNECTOR).with_ensure('directory') }

            it do
              is_expected.to contain_file(PATH_MYSQL_CONNECTOR_LIB).
                with(
                  'ensure' => 'link',
                  'target' => "#{PATH_MYSQL_CONNECTOR}/mysql-connector-java-5.1.34/mysql-connector-java-5.1.34-bin.jar"
                )
            end

            it 'deploys mysql connector 5.1.34 from tar.gz' do
              is_expected.to contain_archive("#{PATH_MYSQL_CONNECTOR}/mysql-connector-java-5.1.34.tar.gz").
                with('source' => 'https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.34.tar.gz',
                     'extract_path' => PATH_MYSQL_CONNECTOR,
                     'creates' => "#{PATH_MYSQL_CONNECTOR}/mysql-connector-java-5.1.34")
            end
          end

          context 'mysql connector defaults Connector Version >8' do
            let(:params) do
              super().merge(
                mysql_connector_version: '8.0.23'
              )
            end

            it { is_expected.to compile.with_all_deps }
            it { is_expected.to contain_file(PATH_MYSQL_CONNECTOR).with_ensure('directory') }

            it do
              is_expected.to contain_file(PATH_MYSQL_CONNECTOR_LIB).
                with(
                  'ensure' => 'link',
                  'target' => "#{PATH_MYSQL_CONNECTOR}/mysql-connector-java-8.0.23/mysql-connector-java-8.0.23.jar"
                )
            end

            it 'deploys mysql connector 8.0.23 from tar.gz' do
              is_expected.to contain_archive('/opt/MySQL-connector/mysql-connector-java-8.0.23.tar.gz').
                with('source' => 'https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-8.0.23.tar.gz',
                     'extract_path' => PATH_MYSQL_CONNECTOR,
                     'creates' => "#{PATH_MYSQL_CONNECTOR}/mysql-connector-java-8.0.23")
            end
          end

          context 'mysql connector overwrite params' do
            let(:params) do
              super().merge(
                mysql_connector_version: '5.1.15',
                mysql_connector_format: 'zip',
                mysql_connector_install: '/opt/foo',
                mysql_connector_url: 'http://example.co.za/foo'
              )
            end

            it { is_expected.to contain_file('/opt/foo').with_ensure('directory') }

            it do
              is_expected.to contain_file(PATH_MYSQL_CONNECTOR_LIB).
                with(
                  'ensure' => 'link',
                  'target' => '/opt/foo/mysql-connector-java-5.1.15/mysql-connector-java-5.1.15-bin.jar'
                )
            end

            it 'deploys mysql connector 5.1.15 from zip' do
              is_expected.to contain_archive('/opt/foo/mysql-connector-java-5.1.15.zip').
                with('source' => 'http://example.co.za/foo/mysql-connector-java-5.1.15.zip',
                     'extract_path' => '/opt/foo',
                     'creates' => '/opt/foo/mysql-connector-java-5.1.15')
            end
          end

          context 'mysql_connector_mangage equals false' do
            let(:params) do
              super().merge(
                mysql_connector_manage: false
              )
            end

            it { is_expected.not_to contain_class('jira::mysql_connector') }
          end
        end
      end
    end
  end
end
