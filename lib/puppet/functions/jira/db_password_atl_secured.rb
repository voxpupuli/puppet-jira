# frozen_string_literal: true

require_relative '../../../puppet_x/jira/jira'

# @summary Check if Jira has changed the db password to {ATL_SECURED}
Puppet::Functions.create_function(:'jira::db_password_atl_secured') do
  dispatch :default_impl do
    # @param homedir The directory for JIRA's runtime data that persists between versions.
    # @return [Boolean] true if ATL_SECURED is found in dbconfig.xml
    param 'String[1]', :homedir
    return_type 'Boolean'
  end

  def default_impl(homedir)
    PuppetX::Jira::Jira.db_password_atl_secured(homedir)
  end
end
