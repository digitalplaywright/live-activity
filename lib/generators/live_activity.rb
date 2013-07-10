require 'rails/generators/named_base'

module LiveActivity
  # A generator module with Activity table schema.
  module Generators
    # A base module 
    module Base
      # Get path for migration template
      def source_root
        @_live_activity_source_root ||= File.expand_path(File.join('../live_activity', generator_name, 'templates'), __FILE__)
      end
    end
  end
end
