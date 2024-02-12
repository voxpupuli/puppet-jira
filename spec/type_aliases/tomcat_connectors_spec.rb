# frozen_string_literal: true

require 'spec_helper'

describe 'Jira::Tomcat_connectors' do
  describe 'valid connector specifications' do
    [
      {
        8081 => {
          'URIEncoding' => 'UTF-8',
          'connectionTimeout' => '20000',
          'protocol' => 'HTTP/1.1',
          'proxyName' => 'foo.example.com',
          'proxyPort' => '80',
          'secure' => false,
          'scheme' => 'http'
        },
        8443 => {
          'URIEncoding' => 'UTF-8',
          'connectionTimeout' => '20000',
          'protocol' => 'HTTP/1.1',
          'proxyName' => 'foo.example.com',
          'proxyPort' => '443',
          'secure' => true,
          'scheme' => 'https'
        }
      }
    ].each do |value|
      describe value.inspect do
        it { is_expected.to allow_value(value) }
      end
    end
  end

  describe 'invalid connector specifications' do
    context 'with garbage inputs' do
      [
        {
          '8081' => {
            'URIEncoding' => 'UTF-8',
            'connectionTimeout' => '20000',
            'protocol' => 'HTTP/1.1',
            'proxyName' => 'foo.example.com',
            'proxyPort' => '80',
            'secure' => false,
            'scheme' => 'http'
          }
        },
        {
          1023 => {
            'URIEncoding' => 'UTF-8',
            'connectionTimeout' => '20000',
            'protocol' => 'HTTP/1.1',
            'proxyName' => 'foo.example.com',
            'proxyPort' => '80',
            'secure' => false,
            'scheme' => 'http'
          }
        },
        { %w[foo blah] => 'bar' },
        { true => 'false' },
        { 'proxyPort' => %w[8443 1234] },
        { 'schema' => { 'https' => 'false' } },
        true,
        false,
        :keyword,
        nil,
        %w[yes no],
        '',
        'ネット',
        '55555',
        '0x123',
        'yess',
        'nooo'
      ].each do |value|
        describe value.inspect do
          it { is_expected.not_to allow_value(value) }
        end
      end
    end
  end
end
