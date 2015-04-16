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
          let(:params) {{
            :javahome    => '/opt/java',
            :user        => 'jira',
            :group       => 'jira',
            :installdir  => '/opt/jira',
            :homedir     => '/home/jira',
            :format      => 'tar.gz',
            :product     => 'jira',
            :version     => '6.4.3a',
            :downloadURL => 'http://www.atlassian.com/software/jira/downloads/binary',
          }}
          it { should contain_group('jira') }
          it { should contain_user('jira').with_shell('/bin/true') }
          it 'should deploy jira 6.4.3a from tar.gz' do
            should contain_staging__file("atlassian-jira-6.4.3a.tar.gz").with({
              'source' => 'http://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-6.4.3a.tar.gz',
              })
            should contain_staging__extract("atlassian-jira-6.4.3a.tar.gz").with({
              'target' => '/opt/jira/atlassian-jira-6.4.3a-standalone',
              'creates' => '/opt/jira/atlassian-jira-6.4.3a-standalone/conf',
              'strip'   => '1',
              'user'    => 'jira',
              'group'   => 'jira',
              })
          end
          it 'should manage the jira home directory' do
            should contain_file('/home/jira').with({
              'ensure' => 'directory',
              'owner' => 'jira',
              'group' => 'jira'
            })
          end
        end
    
        context 'overwriting params' do
          let(:params) {{
            :javahome    => '/opt/java',
            :version     => '6.0.0',
            :format      => 'tar.gz',
            :installdir  => '/opt/jira',
            :homedir     => '/random/homedir',
            :user        => 'foo',
            :group       => 'bar',
            :uid         => 333,
            :gid         => 444,
            :shell       => '/bin/bash',
            :downloadURL => 'http://downloads.atlassian.com',
          }}
      
          it { should contain_user('foo').with({
              'home'  => '/random/homedir',
              'shell' => '/bin/bash',
              'uid'   => 333,
              'gid'   => 444
            }) }
          it { should contain_group('bar') }
      
          it 'should deploy jira 6.0.0 from tar.gz' do
            should contain_staging__file("atlassian-jira-6.0.0.tar.gz").with({
              'source' => 'http://downloads.atlassian.com/atlassian-jira-6.0.0.tar.gz',
            })
            should contain_staging__extract("atlassian-jira-6.0.0.tar.gz").with({
              'target' => '/opt/jira/atlassian-jira-6.0.0-standalone',
              'creates' => '/opt/jira/atlassian-jira-6.0.0-standalone/conf',
              'strip'   => '1',
              'user'    => 'foo',
              'group'   => 'bar',
            })
          end
      
          it 'should manage the jira home directory' do
            should contain_file('/random/homedir').with({
              'ensure' => 'directory',
              'owner' => 'foo',
              'group' => 'bar'
              })
          end
        end
      end
    end
  end
end
end
