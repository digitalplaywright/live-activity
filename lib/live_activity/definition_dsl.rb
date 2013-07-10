require 'active_support'

module LiveActivity

  class DefinitionDSL

    attr_reader :attributes

    def initialize(name)
      @attributes = {
          :name             => name.to_sym,
          :actor            => nil,
          :act_object       => nil,
          :act_target       => nil,
          :grouped_actor    => nil,
          :reverses         => nil,
          :bond_type        => nil,
          :options          => nil
      }
    end

    def add_option(option)
      @attributes[:options] ||= []

      @attributes[:options] << option
    end

    def option(text)
      add_option( text )
    end

    delegate :[], :to => :@attributes

    def self.data_methods(*args)
      args.each do |method|
        define_method method do |*args|

          @attributes[method] = args[0]

        end
      end
    end

    data_methods :actor, :act_object, :act_target, :grouped_actor, :reverses, :bond_type

  end
  
end