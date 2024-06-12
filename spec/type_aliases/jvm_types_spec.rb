# frozen_string_literal: true

require 'spec_helper'

describe 'Jira::Jvm_types' do
  describe 'valid attributes' do
    %w[openjdk-11 oracle-jdk-1.8].each do |value|
      describe value.inspect do
        it { is_expected.to allow_value(value) }
      end
    end
  end

  describe 'invalid attributes' do
    context 'with garbage inputs' do
      %w[openheydk-11 uracle-jdk-1.8].each do |value|
        describe value.inspect do
          it { is_expected.not_to allow_value(value) }
        end
      end
    end
  end
end
