# frozen_string_literal: true

module Konfig

  class Error < StandardError
  end

  class GroupNotFoundError < Error
  end

  class AttributeNotFoundError < Error
  end

  class InvalidAttributeTypeError < Error
  end

  class ValueNotPresentError < Error
  end

end
