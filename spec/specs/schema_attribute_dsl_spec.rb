# frozen_string_literal: true

require 'spec_helper'
require 'konfig/schema_attribute'
require 'konfig/schema_attribute_dsl'

module Konfig

  RSpec.describe Konfig::SchemaAttributeDSL do
    let(:attribute) { SchemaAttribute.new(:example) }
    subject(:dsl) { described_class.new(attribute) }

    describe '#type' do
      it 'sets the type' do
        dsl.type :integer
        expect(attribute.type).to eq :integer
      end

      it 'raises an error if the type is invalid' do
        expect { dsl.type(:invalid) }.to raise_error(InvalidAttributeTypeError)
      end
    end

    describe '#default' do
      it 'sets the default' do
        dsl.default 'example'
        expect(attribute.default).to eq 'example'
      end
    end

    describe '#description' do
      it 'sets the description' do
        dsl.description 'example'
        expect(attribute.description).to eq 'example'
      end
    end

    describe '#array' do
      it 'sets the array' do
        dsl.array
        expect(attribute.array?).to eq true
      end
    end

    describe '#transform' do
      it 'sets the transformer' do
        dsl.transform -> (value) { value }
        expect(attribute.transformer).to be_a(Proc)
      end

      it 'sets the transformer with a block' do
        proc = -> (value) { value }
        dsl.transform(&proc)
        expect(attribute.transformer).to be_a(Proc)
      end
    end
  end

end
