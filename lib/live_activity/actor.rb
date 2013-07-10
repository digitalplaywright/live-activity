module LiveActivity
  
  module Actor
    extend ActiveSupport::Concern

    included do
      cattr_accessor :activity_klass

      has_many :created_activities,     :class_name => "Activity", :as => :actor
      has_many :act_object_activities,  :class_name => "Activity", :as => :act_object
      has_many :act_target_activities,  :class_name => "Activity", :as => :act_target


    end

    module ClassMethods

      def activity_class(klass)
        self.activity_klass = klass.to_s
      end

    end


    # Publishes the activity to the receivers
    #
    # @param [ Hash ] options The options to publish with.
    #
    # @example publish an activity with a act_object and act_target
    #   current_user.publish_activity(:enquiry, :act_object => @enquiry, :act_target => @listing)
    #
    def publish_activity(name, options={})
      options[:receivers] = self.send(options[:receivers]) if options[:receivers].is_a?(Symbol)
      activity = activity_class.publish(name, {:actor => self}.merge(options))
    end

    def activity_class
      @activity_klass ||= activity_klass ? activity_klass.classify.constantize : ::Activity
    end

    def activity_stream(options = {})

      if options.empty?
        activities
      else
        activities.where(options)
      end

    end

  end
  
end