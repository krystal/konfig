# frozen_string_literal: true

require 'konfig/schema_attribute'

module Konfig
  class SchemaAttributeDSL

    def initialize(attribute)
      @attribute = attribute
    end

    def type(value)
      @attribute.type = value
    end

    def default(value)
      @attribute.default = value
    end

    def description(value)
      @attribute.description = value
    end
    alias desc description

    def array
      @attribute.array = true
    end

    def transform(value = nil, &block)
      @attribute.transformer = block || value
    end

  end
end
