source 'https://rubygems.org'
if ENV.key?('PUPPET_VERSION')
  puppetversion = "= #{ENV['PUPPET_VERSION']}"
else
  puppetversion = ['>= 3.4.2']
end
rspecversion = ENV.key?('RSPEC_VERSION') ? "= #{ENV['RSPEC_VERSION']}" : ['>= 2.14 ', '< 3.0.0']
gem 'rake'
gem 'puppet-lint'
gem 'rspec', rspecversion
gem 'rspec-puppet'
gem 'puppetlabs_spec_helper'
gem 'puppet', puppetversion
gem 'puppet-blacksmith'
