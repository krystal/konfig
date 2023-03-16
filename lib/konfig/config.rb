# frozen_string_literal: true

module Konfig
  class Config

    class << self

      def build(schema, sources: [])
        @schema = schema
        @sources = sources

        values = Hashie::Mash.new(@schema.create_hash(nil))

        # Override all defaults with values from the sources
        # in the reverse order they are given.
        sources.reverse.each do |source|
          values.deep_merge!(@schema.create_hash(source))
        end

        values
      end

    end

  end
end
