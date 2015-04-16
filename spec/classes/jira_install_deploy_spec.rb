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
            :downloadURL => 'http://www.atlassian.com/software/jira/downloads/binary/',
            :staging_or_deploy => 'deploy',
          }}
          it { should contain_group('jira') }
          it { should contain_user('jira').with_shell('/bin/true') }
          it 'should deploy jira 6.4.3a from tar.gz' do
            should contain_deploy__file("atlassian-jira-6.4.3a.tar.gz")
          end
          it 'should manage the jira home directory' do
            should contain_file('/home/jira').with({
              'ensure' => 'directory',
              'owner' => 'jira',
              'group' => 'jira'
              })
          end
          it { should_not contain_class('jira::mysql_connector')}
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
            :downloadURL => 'http://downloads.atlassian.com/',
            :staging_or_deploy => 'deploy',
          }}
      
          it { should contain_user('foo').with({
              'home'  => '/random/homedir',
              'shell' => '/bin/bash',
              'uid'   => 333,
              'gid'   => 444,
            }) }
          it { should contain_group('bar') }
      
          it 'should deploy jira 6.0.0 from tar.gz' do
            should contain_deploy__file("atlassian-jira-6.0.0.tar.gz").with({
              'url' => 'http://downloads.atlassian.com/',
              'owner' => 'foo',
              'group' => 'bar'
              })
          end
      
          it 'should manage the jira home directory' do
            should contain_file('/random/homedir').with({
              'ensure' => 'directory',
              'owner' => 'foo',
              'group' => 'bar'
              })
          end
    
          it { should_not contain_class('jira::mysql_connector')}
        end
      end
    end
  end
end
end
