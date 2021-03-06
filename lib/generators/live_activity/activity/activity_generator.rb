require 'generators/live_activity'
require 'rails/generators/active_record'

module LiveActivity
  module Generators
    # Activity generator that creates activity model file from template
    class ActivityGenerator < ActiveRecord::Generators::Base
      extend Base

      argument :name, :type => :string, :default => 'activity'
      # Create model in project's folder
      def generate_files
        copy_file 'activity.rb', "app/models/#{name}.rb"
      end
    end
  end
end
