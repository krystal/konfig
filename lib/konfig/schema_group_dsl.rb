# frozen_string_literal: true

require 'konfig/schema_attribute'

module Konfig
  class SchemaGroupDSL

    def initialize(group)
      @group = group
    end

    SchemaAttribute::TYPES.each do |type|
      define_method type do |name, **kwargs, &block|
        @group.add_attribute(name, type: type, **kwargs, &block)
      end
    end

  end
end
