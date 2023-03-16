# frozen_string_literal: true

require 'konfig/schema_group_dsl'

module Konfig
  class SchemaDSL

    def initialize(schema)
      @schema = schema
    end

    def group(name, &block)
      group = @schema.add_group(name)
      if block
        group_dsl = SchemaGroupDSL.new(group)
        group_dsl.instance_eval(&block)
      end
      group
    end

  end
end
