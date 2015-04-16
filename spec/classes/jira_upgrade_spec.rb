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
          }}
          let(:facts) {
            facts.merge({ :jira_version  => '6.3.4a'})
          }
          it { should contain_exec('service jira stop && sleep 15') }
        end
        context 'custom params' do
          let(:params) {{
            :javahome    => '/opt/java',
            :stop_jira   => 'stop service please'
          }}
          let(:facts) {
            facts.merge({ :jira_version  => '6.3.4a'})
          }
          it { should contain_exec('stop service please') }
        end
      end
    end
  end
end
end
