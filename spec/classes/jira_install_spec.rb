require 'spec_helper.rb'

describe 'jira' do
  describe 'jira::install' do
    context 'supported operating systems' do
      on_supported_os.each do |os, facts|
        context "on #{os} #{facts}" do
          let(:facts) do
            facts
          end

          context 'default params' do
            let(:params) do
              {
                javahome: '/opt/java',
                user: 'jira',
                group: 'jira',
                installdir: '/opt/jira',
                homedir: '/home/jira',
                format: 'tar.gz',
                product: 'jira',
                version: '6.3.4a',
                download_url: 'https://downloads.atlassian.com/software/jira/downloads'
              }
            end
            it { is_expected.to contain_group('jira') }
            it { is_expected.to contain_user('jira').with_shell('/bin/true') }
            it 'deploys jira 6.3.4a from tar.gz' do
              is_expected.to contain_archive('/tmp/atlassian-jira-6.3.4a.tar.gz').
                with('extract_path' => '/opt/jira/atlassian-jira-6.3.4a-standalone',
                     'source'        => 'https://downloads.atlassian.com/software/jira/downloads/atlassian-jira-6.3.4a.tar.gz',
                     'creates'       => '/opt/jira/atlassian-jira-6.3.4a-standalone/conf',
                     'user'          => 'jira',
                     'group'         => 'jira',
                     'checksum_type' => 'md5')
            end

            it 'manages the jira home directory' do
              is_expected.to contain_file('/home/jira').with('ensure' => 'directory',
                                                             'owner' => 'jira',
                                                             'group' => 'jira')
            end
          end

          context 'jira 7' do
            context 'default product' do
              let(:params) do
                {
                  javahome: '/opt/java',
                  installdir: '/opt/jira',
                  product: 'jira',
                  version: '7.0.4',
                  download_url: 'http://www.atlassian.com/software/jira/downloads/binary'
                }
              end
              it 'deploys jira 7.0.4 from tar.gz' do
                is_expected.to contain_archive('/tmp/atlassian-jira-software-7.0.4-jira-7.0.4.tar.gz').
                  with('extract_path' => '/opt/jira/atlassian-jira-software-7.0.4-standalone',
                       'source'        => 'http://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-software-7.0.4-jira-7.0.4.tar.gz',
                       'creates'       => '/opt/jira/atlassian-jira-software-7.0.4-standalone/conf',
                       'user'          => 'jira',
                       'group'         => 'jira',
                       'checksum_type' => 'md5')
              end
            end
            context 'core product' do
              let(:params) do
                {
                  javahome: '/opt/java',
                  installdir: '/opt/jira',
                  product: 'jira-core',
                  version: '7.0.4',
                  download_url: 'http://www.atlassian.com/software/jira/downloads/binary'
                }
              end
              it 'deploys jira 7.0.4 from tar.gz' do
                is_expected.to contain_archive('/tmp/atlassian-jira-core-7.0.4.tar.gz').
                  with('extract_path' => '/opt/jira/atlassian-jira-core-7.0.4-standalone',
                       'source'        => 'http://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-core-7.0.4.tar.gz',
                       'creates'       => '/opt/jira/atlassian-jira-core-7.0.4-standalone/conf',
                       'user'          => 'jira',
                       'group'         => 'jira',
                       'checksum_type' => 'md5')
              end
            end
          end

          context 'overwriting params' do
            let(:params) do
              {
                javahome: '/opt/java',
                version: '6.1',
                format: 'tar.gz',
                installdir: '/opt/jira',
                homedir: '/random/homedir',
                user: 'foo',
                group: 'bar',
                uid: 333,
                gid: 444,
                shell: '/bin/bash',
                download_url: 'https://www.atlassian.com/software/jira/downloads/binary'
              }
            end

            it do
              is_expected.to contain_user('foo').with('home' => '/random/homedir',
                                                      'shell' => '/bin/bash',
                                                      'uid'   => 333,
                                                      'gid'   => 444)
            end
            it { is_expected.to contain_group('bar') }

            it 'deploys jira 6.1 from tar.gz' do
              is_expected.to contain_archive('/tmp/atlassian-jira-6.1.tar.gz').
                with('extract_path' => '/opt/jira/atlassian-jira-6.1-standalone',
                     'source'        => 'https://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-6.1.tar.gz',
                     'creates'       => '/opt/jira/atlassian-jira-6.1-standalone/conf',
                     'user'          => 'foo',
                     'group'         => 'bar',
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
