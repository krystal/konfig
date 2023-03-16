# frozen_string_literal: true

require 'hashie'

module Konfig
  class ConfigHash < ::Hash

    include Hashie::Extensions::MethodAccess
    include Hashie::Extensions::DeepMerge
    include Hashie::Extensions::MergeInitializer
    include Hashie::Extensions::IndifferentAccess

  end
end
