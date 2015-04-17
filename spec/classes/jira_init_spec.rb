require 'spec_helper.rb'

describe 'jira' do
describe 'jira::init' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os} #{facts}" do
        let(:facts) do
          facts
        end
        context 'ajp proxy' do
          context 'without port' do
            let(:params) {{
              :version => '6.3.4a',
              :javahome => '/opt/java',
              :ajp => {
                'protocol' => 'AJP/1.3',
              },
            }}
            it { should raise_error(Puppet::Error, /You need to specify a valid port for the AJP connector\./) } 
          end
          context 'with invalid port' do
            let(:params) {{
              :version => '6.3.4a',
              :javahome => '/opt/java',
              :ajp => {
                'port' => '80zeronine',
                'protocol' => 'AJP/1.3',
              },
            }}
            it { should raise_error(Puppet::Error, /validate_re\(\): "80zeronine" does not match/) } 
          end
          context 'without protocol' do
            let(:params) {{
              :version => '6.3.4a',
              :javahome => '/opt/java',
              :ajp => {
                'port' => '8009',
              },
            }}
            it { should raise_error(Puppet::Error, /You need to specify a valid protocol for the AJP connector\./) } 
          end
          context 'with invalid protocol' do
            let(:params) {{
              :version => '6.3.4a',
              :javahome => '/opt/java',
              :ajp => {
                'port' => '8009',
                'protocol' => 'AJP',
              },
            }}
            it { should raise_error(Puppet::Error, /validate_re\(\): "AJP" does not match/) } 
          end
        end
      end
    end
  end
end
end
