# frozen_string_literal: true

require 'konfig/error'
require 'konfig/schema_group'
require 'konfig/schema_dsl'
require 'konfig/config_hash'

module Konfig
  class Schema

    attr_reader :groups

    def initialize
      @groups = {}
    end

    def group(name)
      @groups[name] || raise(GroupNotFoundError, "Group '#{name}' not found in schema")
    end

    def group?(name)
      @groups.key?(name)
    end

    def add_group(name)
      group = SchemaGroup.new
      @groups[name] = group
      yield group if block_given?
      group
    end

    def create_hash(source)
      @groups.each_with_object({}) do |(name, group), hash|
        hash[name] = group.create_hash([name], source)
      end
    end

    class << self

      def draw(&block)
        schema = new
        if block
          dsl = SchemaDSL.new(schema)
          dsl.instance_eval(&block)
        end
        schema
      end

    end

  end
end
