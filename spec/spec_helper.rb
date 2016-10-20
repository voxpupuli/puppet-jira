require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec-puppet-facts'
include RspecPuppetFacts

unless RUBY_VERSION =~ %r{^1.9}
  require 'coveralls'
  Coveralls.wear!
end

RSpec.configure do |c|
  c.before do
    # avoid "Only root can execute commands as other users"
    Puppet.features.stubs(root?: true)
  end
end

RSpec.configure do |c|
  c.default_facts = {
    jira_version: '6.4',
    staging_http_get: 'curl',
    #:os_maj_version   => '6',

    operatingsystemmajrelease: '6',
    puppetversion: '3.7.4'
  }
end
