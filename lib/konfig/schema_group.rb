# frozen_string_literal: true

require 'konfig/config_hash'
require 'konfig/schema_attribute'

module Konfig
  class SchemaGroup

    def initialize
      @attributes = {}
    end

    def attribute(name)
      @attributes[name] || raise(AttributeNotFoundError, "Attribute '#{name}' not found in schema")
    end

    def attribute?(name)
      @attributes.key?(name)
    end

    def add_attribute(name, **kwargs, &block)
      kwargs[:transformer] = block if block && !kwargs.key?(:transformer)
      @attributes[name] = SchemaAttribute.new(name, **kwargs)
    end

    # Create a hash of the all the values for this group from the given source.
    def create_hash(path, source = nil)
      @attributes.each_with_object({}) do |(name, attribute), hash|
        attribute_path = path + [name]
        if source.nil?
          hash[name] = attribute.cast(attribute.default)
        else
          begin
            source_value = source.get(attribute_path, attribute: attribute)
            hash[name] = attribute.transform(source_value)
          rescue ValueNotPresentError
            # This is OK
          end
        end
      end
    end

  end
end
