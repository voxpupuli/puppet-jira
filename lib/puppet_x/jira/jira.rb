# frozen_string_literal: true

require 'puppet'

module PuppetX
  module Jira
    class Jira
      def self.db_password_atl_secured(homedir)
        File.open(format('%s/dbconfig.xml', homedir)) do |file|
          !file.find { |line| line =~ %r{ATL_SECURED} }.nil?
        end
      rescue StandardError
        false
      end
    end
  end
end
