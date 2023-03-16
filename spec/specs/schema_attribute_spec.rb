# frozen_string_literal: true

require 'spec_helper'
require 'konfig/schema_group'

module Konfig

  RSpec.describe Konfig::SchemaAttribute do
    subject(:attribute) { described_class.new }

    describe '.new' do
      it 'raises an error if the type is not supported' do
        expect { described_class.new(:hostname, type: :invalid) }.to raise_error Konfig::InvalidAttributeTypeError
      end
    end

    describe '#cast' do
      context 'when type is string' do
        expectations = { 'string' => 'string', 1 => '1', 1.0 => '1.0', true => 'true', false => 'false', nil => nil,
                         '' => nil }
        expectations.each do |input, output|
          it "casts #{input.inspect} to #{output.inspect}" do
            attribute = described_class.new(:hostname, type: :string)
            expect(attribute.cast(input)).to eq output
          end
        end

        context 'when attribute is an array' do
          it 'casts each element to a string' do
            attribute = described_class.new(:names, type: :string, array: true)
            expect(attribute.cast([1, 2, 3])).to eq %w[1 2 3]
          end
        end
      end

      context 'when type is integer' do
        expectations = { '1' => 1, 1 => 1, 1.0 => 1, true => 1, false => 0, nil => nil, '' => nil }
        expectations.each do |input, output|
          it "casts #{input.inspect} to #{output.inspect}" do
            attribute = described_class.new(:hostname, type: :integer)
            expect(attribute.cast(input)).to eq output
          end
        end

        context 'when attribute is an array' do
          it 'casts each element to a string' do
            attribute = described_class.new(:names, type: :integer, array: true)
            expect(attribute.cast(%w[1 2 3])).to eq [1, 2, 3]
          end
        end
      end

      context 'when type is float' do
        expectations = { '1' => 1.0, 1 => 1.0, 1.0 => 1.0, true => 1.0, false => 0.0, nil => nil, '' => nil }
        expectations.each do |input, output|
          it "casts #{input.inspect} to #{output.inspect}" do
            attribute = described_class.new(:hostname, type: :float)
            expect(attribute.cast(input)).to eq output
          end
        end

        context 'when attribute is an array' do
          it 'casts each element to a string' do
            attribute = described_class.new(:names, type: :float, array: true)
            expect(attribute.cast(%w[1 2 3])).to eq [1.0, 2.0, 3.0]
          end
        end
      end

      context 'when type is boolean' do
        expectations = { '1' => true, 1 => true, 1.0 => true, true => true, false => false, nil => nil, '' => nil,
                         '0' => false, 0 => false }
        expectations.each do |input, output|
          it "casts #{input.inspect} to #{output.inspect}" do
            attribute = described_class.new(:hostname, type: :boolean)
            expect(attribute.cast(input)).to eq output
          end
        end

        context 'when attribute is an array' do
          it 'casts each element to a string' do
            attribute = described_class.new(:names, type: :boolean, array: true)
            expect(attribute.cast(%w[1 0 1])).to eq [true, false, true]
          end
        end
      end
    end

    describe '#transform' do
      it 'returns the casted value if no transformer is set' do
        attribute = described_class.new(:hostname, type: :integer)
        expect(attribute.transform('1234')).to eq 1234
      end

      it 'returns the result of the transformation if a transformer is set' do
        attribute = described_class.new(:hostname, transformer: -> (value) { value.upcase })
        expect(attribute.transform('hello')).to eq 'HELLO'
      end
    end
  end

end
