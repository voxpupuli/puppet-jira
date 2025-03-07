# frozen_string_literal: true
#
Puppet::Functions.create_function(:'jira::is_installed') do
  dispatch :default_impl do
    param 'String[1]', :jira_user
    return_type 'Boolean'
  end
  def default_impl(jira_user)
    begin
      File.exist? format('%s/dbconfig.xml', Dir.home(jira_user))
    rescue
      false
    end
  end
end
