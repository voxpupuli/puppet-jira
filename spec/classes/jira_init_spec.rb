# frozen_string_literal: true

require 'spec_helper'

describe 'jira' do
  describe 'jira::init' do
    context 'supported operating systems' do
      on_supported_os.each do |os, facts|
        context "on #{os}" do
          let(:facts) do
            facts
          end

          let :params do
            {
              javahome: '/tmp/bla'
            }
          end

          it { is_expected.to compile.with_all_deps }
        end
      end
    end
  end
end
