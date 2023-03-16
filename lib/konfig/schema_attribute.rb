# frozen_string_literal: true

module Konfig
  class SchemaAttribute

    TYPES = [:string, :integer, :float, :boolean].freeze

    attr_reader :name
    attr_reader :type
    attr_reader :default
    attr_reader :transformer

    def initialize(name, type: :string, array: false, default: nil, transformer: nil)
      @name = name
      @type = type
      @array = array
      @default = default
      @transformer = transformer

      raise InvalidAttributeTypeError, "Invalid type #{type} for attribute #{name}" unless TYPES.include?(type)
    end

    def array?
      @array == true
    end

    def cast(value)
      return value.map { |v| cast(v) } if value.is_a?(Array)

      return nil if value.nil?
      return nil if value.is_a?(String) && value.empty?

      send("cast_#{type}", value)
    end

    def transform(value)
      casted = cast(value)
      return casted if transformer.nil?

      transformer.call(casted)
    end

    private

    def cast_string(input)
      input.to_s
    end

    def cast_integer(input)
      return 1 if input == true
      return 0 if input == false

      input.to_i
    end

    def cast_float(input)
      return 1.0 if input == true
      return 0.0 if input == false

      input.to_f
    end

    def cast_boolean(input)
      return true if input == true
      return false if input == false

      %w[true 1 1.0].include?(input.to_s)
    end

  end
end
