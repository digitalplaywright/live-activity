module LiveActivity

  class Definition

    attr_reader :name, :actor, :act_object, :act_target, :grouped_actor, :bond_type, :reverses, :options,  :receivers

    # @param dsl [LiveActivity::DefinitionDSL] A DSL act_object
    def initialize(definition)
      @name             = definition[:name]
      @actor            = definition[:actor]         || nil
      @act_object       = definition[:act_object]    || nil
      @act_target       = definition[:act_target]    || nil
      @grouped_actor    = definition[:grouped_actor] || nil
      @bond_type        = definition[:bond_type]     || nil
      @options          = definition[:options]       || []
      @reverses         = definition[:reverses]      || nil
    end

    #
    # Registers a new definition
    #
    # @param definition [Definition] The definition to register
    # @return [Definition] Returns the registered definition
    def self.register(definition)
      return false unless definition.is_a? DefinitionDSL
      definition = new(definition)
      self.registered << definition
      return definition || false
    end

    # List of registered definitions
    # @return [Array<LiveActivity::Definition>]
    def self.registered
      @definitions ||= []
    end

    def self.find(name)
      unless definition = registered.find{|definition| definition.name == name.to_sym}
        raise LiveActivity::InvalidActivity, "Could not find a definition for `#{name}`"
      else
        definition
      end
    end



  end
  
end