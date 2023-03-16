# frozen_string_literal: true

require 'konfig/error'
require 'konfig/sources/abstract'
require 'yaml'

module Konfig
  module Sources
    class YAML < Abstract

      def initialize(source)
        super()
        @source = ::YAML.safe_load(source)
      end

      def get(path, _attribute: nil)
        source = @source
        path.each do |p|
          raise ValueNotPresentError unless source.key?(p.to_s)

          source = source[p.to_s]
        end
        source
      end

    end
  end
end
