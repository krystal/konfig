# frozen_string_literal: true

require 'spec_helper'
require 'konfig/schema_group'
require 'konfig/schema_group_dsl'

module Konfig

  RSpec.describe Konfig::SchemaGroupDSL do
    let(:group) { SchemaGroup.new }
    subject(:dsl) { described_class.new(group) }

    SchemaAttribute::TYPES.each do |type|
      describe "##{type}" do
        it 'adds the attribute' do
          dsl.send(type, :hostname)
          expect(group.attribute?(:hostname)).to be true
        end

        it 'returns the attribute' do
          expect(dsl.send(type, :hostname)).to be_a Konfig::SchemaAttribute
        end

        it 'passs on the values' do
          transformer = proc {}
          dsl.send(type, :hostname, type: :integer, array: true, default: 'localhost', transformer: transformer)
          attribute = group.attribute(:hostname)
          expect(attribute.type).to eq :integer
          expect(attribute.array?).to eq true
          expect(attribute.default).to eq 'localhost'
          expect(attribute.transformer).to eq transformer
        end

        it 'passes the block to the schema attribute dsl if given' do
          block = proc do
            description 'The hostname'
          end
          dsl.send(type, :hostname, &block)
          attribute = group.attribute(:hostname)
          expect(attribute.description).to eq 'The hostname'
        end
      end
    end
  end

end
