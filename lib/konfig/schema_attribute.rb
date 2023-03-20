# frozen_string_literal: true

module Konfig
  class SchemaAttribute

    TYPES = [:string, :integer, :float, :boolean].freeze

    attr_reader :name
    attr_reader :type
    attr_accessor :default
    attr_accessor :description
    attr_accessor :array
    attr_accessor :transformer

    def initialize(name, type: :string, array: nil, default: nil, description: nil, transformer: nil)
      @name = name
      @array = array unless array.nil?
      self.type = type
      @default = default
      @description = description
      @transformer = transformer
    end

    def type=(type)
      if type.is_a?(Array) && type.size == 1
        @array = true
        type = type.first
      end

      raise InvalidAttributeTypeError, "Invalid type #{type} for attribute #{@name}" unless TYPES.include?(type)

      @type = type
    end

    def array?
      @array == true
    end

    def cast(value, handle_arrays: true)
      return cast_array(value) if handle_arrays && array?

      return nil if value.nil?
      return nil if value.is_a?(String) && value.empty?

      send("cast_#{type}", value)
    end

    def transform(value)
      casted = cast(value)
      return casted if transformer.nil?

      if array?
        casted.map { |v| transformer.call(v) }
      else
        transformer.call(casted)
      end
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

    def cast_array(value)
      # If we have an array, and we're expecting an array, then we can just
      # cast all the values of that array
      return value.map { |v| cast(v, handle_arrays: false) } if value.is_a?(Array)

      # if we want an array but we don't have one, we will take the value
      # and put it in the array and try casting again
      [cast(value, handle_arrays: false)]
    end

  end
end
