# frozen_string_literal: true

# @summary Check if JIRA is already installed
Puppet::Functions.create_function(:'jira::is_installed') do
  dispatch :default_impl do
    # @param jira_user The user under which JIRA is being installed
    # @return [Boolean] install status
    param 'String[1]', :jira_user
    return_type 'Boolean'
  end

  def default_impl(jira_user)
    File.exist? format('%s/dbconfig.xml', Dir.home(jira_user))
  rescue StandardError
    false
  end
end
