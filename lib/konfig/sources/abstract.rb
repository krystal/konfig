# frozen_string_literal: true

module Konfig
  module Sources
    class Abstract

      def initialize
      end

      # The get method will return the give value for the given path.
      # The path will contain the full path to the value, including the
      # groups which lead up to it.
      def get(path, attribute: nil)
        raise NotImplementedError
      end

    end
  end
end
