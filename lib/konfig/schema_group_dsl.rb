# frozen_string_literal: true

require 'konfig/schema_attribute'
require 'konfig/schema_attribute_dsl'
module Konfig
  class SchemaGroupDSL

    def initialize(group)
      @group = group
    end

    SchemaAttribute::TYPES.each do |type|
      define_method type do |name, **kwargs, &block|
        attribute = @group.add_attribute(name, type: type, **kwargs)

        if block
          dsl = SchemaAttributeDSL.new(attribute)
          dsl.instance_eval(&block)
        end

        attribute
      end
    end

  end
end
