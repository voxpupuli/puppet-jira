# frozen_string_literal: true

require 'spec_helper'

# set some constants to keep it DRY
DOWNLOAD_URL = 'https://product-downloads.atlassian.com/software/jira/downloads'

describe 'jira' do
  describe 'jira::install' do
    let(:params) do
      {
        javahome: PATH_JAVA_HOME,
        installdir: PATH_JIRA_DIR,
        version: DEFAULT_VERSION,
        product: 'jira'
      }
    end

    context 'supported operating systems' do
      on_supported_os.each do |os, facts|
        context "on #{os}" do
          let(:facts) do
            facts
          end

          context 'default params' do
            let(:params) do
              super().merge(
                user: 'jira',
                group: 'jira',
                homedir: '/home/jira',
                download_url: DOWNLOAD_URL
              )
            end

            it { is_expected.to compile.with_all_deps }
            it { is_expected.to contain_group('jira') }
            it { is_expected.to contain_user('jira').with_shell('/bin/true') }

            it "deploys jira #{DEFAULT_VERSION} from tar.gz" do
              is_expected.to contain_archive("/tmp/#{PRODUCT_VERSION_STRING}.tar.gz").
                with('extract_path' => "/opt/jira/#{PRODUCT_VERSION_STRING}-standalone",
                     'source' => "#{DOWNLOAD_URL}/#{PRODUCT_VERSION_STRING}.tar.gz",
                     'creates' => "/opt/jira/#{PRODUCT_VERSION_STRING}-standalone/conf",
                     'user' => 'jira',
                     'group' => 'jira',
                     'checksum_type' => 'md5')
            end

            it 'manages the jira home directory' do
              is_expected.to contain_file('/home/jira').with('ensure' => 'directory',
                                                             'owner' => 'jira',
                                                             'group' => 'jira')
            end
          end

          context "jira version #{DEFAULT_VERSION}" do
            context 'default product' do
              let(:params) do
                super().merge(
                  download_url: DOWNLOAD_URL
                )
              end

              it "deploys jira #{DEFAULT_VERSION} from tar.gz" do
                is_expected.to contain_archive("/tmp/#{PRODUCT_VERSION_STRING}.tar.gz").
                  with('extract_path' => "/opt/jira/#{PRODUCT_VERSION_STRING}-standalone",
                       'source' => "#{DOWNLOAD_URL}/#{PRODUCT_VERSION_STRING}.tar.gz",
                       'creates' => "/opt/jira/#{PRODUCT_VERSION_STRING}-standalone/conf",
                       'user' => 'jira',
                       'group' => 'jira',
                       'checksum_type' => 'md5')
              end
            end

            context 'core product' do
              let(:params) do
                super().merge(
                  product: 'jira-core',
                  download_url: DOWNLOAD_URL
                )
              end

              it "deploys jira #{DEFAULT_VERSION} from tar.gz" do
                is_expected.to contain_archive("/tmp/#{PRODUCT_VERSION_STRING_CORE}.tar.gz").
                  with('extract_path' => "/opt/jira/#{PRODUCT_VERSION_STRING_CORE}-standalone",
                       'source' => "#{DOWNLOAD_URL}/#{PRODUCT_VERSION_STRING_CORE}.tar.gz",
                       'creates' => "/opt/jira/#{PRODUCT_VERSION_STRING_CORE}-standalone/conf",
                       'user' => 'jira',
                       'group' => 'jira',
                       'checksum_type' => 'md5')
              end
            end
          end

          context 'manage_users => false' do
            let(:params) do
              super().merge(
                manage_user: false
              )
            end
            let(:pre_condition) do
              <<~PRE
                user {'jira':
                  comment => 'My Personal Managed Account',
                }
                group {'jira':}
              PRE
            end

            it { is_expected.to compile }
            it { is_expected.to contain_user('jira').with_comment('My Personal Managed Account') }
          end

          context 'overwriting params' do
            let(:params) do
              super().merge(
                homedir: '/random/homedir',
                user: 'foo',
                group: 'bar',
                uid: 333,
                gid: 444,
                shell: '/bin/bash',
                download_url: DOWNLOAD_URL
              )
            end

            it do
              is_expected.to contain_user('foo').with('home' => '/random/homedir',
                                                      'shell' => '/bin/bash',
                                                      'uid' => 333,
                                                      'gid' => 444)
            end

            it { is_expected.to contain_group('bar') }

            it "deploys jira #{DEFAULT_VERSION} from tar.gz" do
              is_expected.to contain_archive("/tmp/#{PRODUCT_VERSION_STRING}.tar.gz").
                with('extract_path' => "/opt/jira/#{PRODUCT_VERSION_STRING}-standalone",
                     'source' => "#{DOWNLOAD_URL}/#{PRODUCT_VERSION_STRING}.tar.gz",
                     'creates' => "/opt/jira/#{PRODUCT_VERSION_STRING}-standalone/conf",
                     'user' => 'foo',
                     'group' => 'bar',
                     'checksum_type' => 'md5')
            end

            it 'manages the jira home directory' do
              is_expected.to contain_file('/random/homedir').with('ensure' => 'directory',
                                                                  'owner' => 'foo',
                                                                  'group' => 'bar')
            end
          end
        end
      end
    end
  end
end
