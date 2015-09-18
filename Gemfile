source 'https://rubygems.org'

group :test do
  gem 'rake'
  gem 'puppet', ENV['PUPPET_VERSION'] || '~> 3.8.0'
  gem 'rspec-puppet', git: 'https://github.com/rodjek/rspec-puppet.git'
  gem 'puppetlabs_spec_helper'
  gem 'metadata-json-lint'
  gem 'rspec-puppet-facts'
  gem 'rspec'
  gem 'puppet-blacksmith'
  gem 'rubocop'
end

group :development do
  gem 'travis'
  gem 'travis-lint'
  gem 'guard-rake'
end

group :system_tests do
  gem 'beaker'
  gem 'beaker-rspec'
end
