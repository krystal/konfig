# frozen_string_literal: true

require 'konfig/error'
require 'konfig/sources/abstract'

module Konfig
  module Sources
    class Directory < Abstract

      def initialize(root, strip_contents: true, array_separator: /\n/)
        super()
        @root = root
        @strip_contents = strip_contents
        @array_separator = array_separator
      end

      def get(path, attribute: nil)
        file_path = File.join(@root, path.join('.'))
        raise ValueNotPresentError unless File.exist?(file_path)

        result = File.read(file_path)
        result = result.strip if @strip_contents
        result = handle_array(result) if attribute&.array?
        result
      end

      private

      def handle_array(value)
        value.split(@array_separator).map(&:strip)
      end

    end
  end
end
