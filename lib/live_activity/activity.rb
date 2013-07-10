module LiveActivity
  module Activity
    extend ActiveSupport::Concern

    included do

      store :options

      belongs_to :actor,      :polymorphic => true
      belongs_to :act_object, :polymorphic => true
      belongs_to :act_target, :polymorphic => true

      validates_presence_of :actor_id, :actor_type, :verb
    end

    module ClassMethods

      # Defines a new Activity2 type and registers a definition
      #
      # @param [ String ] name The name of the activity
      #
      # @example Define a new activity
      #   activity(:enquiry) do
      #     actor :user, :cache => [:full_name]
      #     act_object :enquiry, :cache => [:subject]
      #     act_target :listing, :cache => [:title]
      #   end
      #
      # @return [Definition] Returns the registered definition
      def activity(name, &block)
        definition = LiveActivity::DefinitionDSL.new(name)
        definition.instance_eval(&block)
        LiveActivity::Definition.register(definition)
      end

      # Publishes an activity using an activity name and data
      #
      # @param [ String ] verb The verb of the activity
      # @param [ Hash ] data The data to initialize the activity with.
      #
      # @return [LiveActivity::Activity2] An Activity instance with data
      def publish(verb, data)
        new.publish({:verb => verb}.merge(data))
      end

    end



    # Publishes the activity to the receivers
    #
    # @param [ Hash ] options The options to publish with.
    #
    def publish(data = {})
      assign_properties(data)

      self
    end


    def refresh_data
      save(:validate => false)
    end

    protected

    def assign_properties(data = {})

      self.verb      = data.delete(:verb)

      cur_receivers  = data.delete(:receivers)



      [:actor, :act_object, :act_target].each do |type|

        cur_object = data[type]

        unless cur_object
          if definition.send(type.to_sym)
            raise verb.to_json
            #raise LiveActivity::InvalidData.new(type)
          else
            next

          end
        end

        class_sym = cur_object.class.name.to_sym

        raise LiveActivity::InvalidData.new(class_sym) unless definition.send(type) == class_sym

        case type
          when :actor
            self.actor = cur_object
          when :act_object
            self.act_object = cur_object
          when :act_target
            self.act_target = cur_object
          else
            raise "unknown type"
        end

        data.delete(type)

      end

      [:grouped_actor].each do |group|


        grp_object = data[group]

        if grp_object == nil
          if definition.send(group.to_sym)
            raise verb.to_json
            #raise LiveActivity::InvalidData.new(group)
          else
            next

          end
        end

        grp_object.each do |cur_obj|
          raise LiveActivity::InvalidData.new(class_sym) unless definition.send(group) == cur_obj.class.name.to_sym

          self.grouped_actors << cur_obj

        end

        data.delete(group)

      end

      cur_bond_type = definition.send(:bond_type)

      if cur_bond_type
        write_attribute( :bond_type, cur_bond_type.to_s )
      end

      def_options = definition.send(:options)
      def_options.each do |cur_option|
        cur_object = data[cur_option]

        if cur_object

          if cur_option == :description
            self.description = cur_object
          else
            options[cur_option] = cur_object
          end
          data.delete(cur_option)

        else
          #all options defined must be used
          raise Streama::InvalidData.new(cur_object[0])
        end
      end

      if data.size > 0
        raise "unexpected arguments: " + data.to_json
      end



      self.save


      if cur_receivers
        cur_receivers.each do |sp|
          send(sp.class.to_s.tableize) << sp
        end
      end


    end

    def definition
      @definition ||= LiveActivity::Definition.find(verb)
    end


  end
end
