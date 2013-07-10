module LiveActivity
  
  class LiveActivityError < StandardError
  end
  
  class InvalidActivity < LiveActivityError
  end
  
  # This error is raised when an act_object isn't defined
  # as an actor, act_object or act_target
  #
  # Example:
  #
  # <tt>InvalidField.new('field_name')</tt>
  class InvalidData < LiveActivityError
    attr_reader :message

    def initialize message
      @message = "Invalid Data: #{message}"
    end

  end
  
  # This error is raised when trying to store a field that doesn't exist
  #
  # Example:
  #
  # <tt>InvalidField.new('field_name')</tt>
  class InvalidField < LiveActivityError
    attr_reader :message

    def initialize message
      @message = "Invalid Field: #{message}"
    end

  end
  
  class ActivityNotSaved < LiveActivityError
  end
  
  class NoFollowersDefined < LiveActivityError
  end
  
end