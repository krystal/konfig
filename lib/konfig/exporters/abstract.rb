# frozen_string_literal: true

module Konfig
  module Exporters
    class Abstract

      def initialize(schema, **options)
        @schema = schema
        @options = options
      end

      def export
        raise NotImplementedError
      end

      private

      attr_reader :options

    end
  end
end
