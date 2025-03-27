# frozen_string_literal: true

# @summary Check if JIRA is already installed
Puppet::Functions.create_function(:'jira::is_installed') do
  dispatch :default_impl do
    # @param homedir The directory for JIRA's runtime data that persists between versions.
    # @return [Boolean] install status
    param 'String[1]', :homedir
    return_type 'Boolean'
  end

  def default_impl(homedir)
    File.exist? format('%s/dbconfig.xml', homedir)
  rescue StandardError
    false
  end
end
