require 'spec_helper.rb'

describe 'jira' do
  describe 'jira::init' do
    context 'supported operating systems' do
      on_supported_os.each do |os, facts|
        context "on #{os} #{facts}" do
          let(:facts) do
            facts
          end
          context 'with javahome not set' do
            it('fails') do
              is_expected.to raise_error(Puppet::Error, %r{You need to specify a value for javahome})
            end
          end
          context 'ajp proxy' do
            context 'without port' do
              let(:params) do
                {
                  version: '6.3.4a',
                  javahome: '/opt/java',
                  ajp: {
                    'protocol' => 'AJP/1.3'
                  }
                }
              end
              it { is_expected.to raise_error(Puppet::Error, %r{You need to specify a valid port for the AJP connector\.}) }
            end
            context 'with invalid port' do
              let(:params) do
                {
                  version: '6.3.4a',
                  javahome: '/opt/java',
                  ajp: {
                    'port'     => '80zeronine',
                    'protocol' => 'AJP/1.3'
                  }
                }
              end
              it { is_expected.to raise_error(Puppet::Error, %r{validate_re\(\): "80zeronine" does not match}) }
            end
            context 'without protocol' do
              let(:params) do
                {
                  version: '6.3.4a',
                  javahome: '/opt/java',
                  ajp: {
                    'port' => '8009'
                  }
                }
              end
              it { is_expected.to raise_error(Puppet::Error, %r{You need to specify a valid protocol for the AJP connector\.}) }
            end
            context 'with invalid protocol' do
              let(:params) do
                {
                  version: '6.3.4a',
                  javahome: '/opt/java',
                  ajp: {
                    'port'     => '8009',
                    'protocol' => 'AJP'
                  }
                }
              end
              it { is_expected.to raise_error(Puppet::Error, %r{validate_re\(\): "AJP" does not match}) }
            end
          end
        end
      end
    end
  end
end
