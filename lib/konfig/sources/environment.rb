# frozen_string_literal: true

require 'konfig/error'
require 'konfig/sources/abstract'

module Konfig
  module Sources
    class Environment < Abstract

      def initialize(env, array_separator: /\s*,\s*/)
        super()
        @env = env
        @array_separator = array_separator
      end

      def get(path, attribute: nil)
        key = path.map { |p| p.to_s.upcase }.join('_')
        raise ValueNotPresentError unless @env.key?(key)

        value = @env[key]

        value = handle_array(value) if attribute&.array?
        value
      end

      private

      def handle_array(value)
        value.split(@array_separator).map(&:strip)
      end

    end
  end
end
