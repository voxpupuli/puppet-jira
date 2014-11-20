require 'rake'
require 'puppetlabs_spec_helper/rake_tasks'
require 'rspec/core/rake_task'
require 'puppet_blacksmith/rake_tasks'

LINT_IGNORES = ['rvm']

begin
  if Gem::Specification::find_by_name('puppet-lint')
    require 'puppet-lint/tasks/puppet-lint'
    PuppetLint.configuration.fail_on_warnings = true,
    PuppetLint.configuration.send('disable_80chars')
    PuppetLint.configuration.ignore_paths = ["spec/**/*.pp", "vendor/**/*.pp", "pkg/**/**/*.pp"]
    PuppetLint.configuration.log_format =
        '%{path}:%{linenumber}:%{check}:%{KIND}:%{message}'
    task :default => [:spec,:syntax,:validate,:lint]
  end
rescue Gem::LoadError
end
