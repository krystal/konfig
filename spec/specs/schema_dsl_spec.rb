# frozen_string_literal: true

require 'spec_helper'
require 'konfig/schema'
require 'konfig/schema_dsl'

module Konfig

  RSpec.describe Konfig::SchemaDSL do
    let(:schema) { Schema.new }
    subject(:dsl) { described_class.new(schema) }

    describe '#group' do
      it 'adds a group and returns it' do
        group = dsl.group(:example)
        expect(group).to be_a Konfig::SchemaGroup
        expect(schema.group?(:example)).to be true
      end

      it 'yields the block to the group dsl' do
        called = false
        group = dsl.group(:example) do
          called = true
          string :hostname
        end
        expect(called).to be true
        expect(group.attribute?(:hostname)).to be true
      end
    end
  end

end
