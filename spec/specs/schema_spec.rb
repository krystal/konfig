# frozen_string_literal: true

require 'spec_helper'
require 'konfig/schema'

module Konfig

  RSpec.describe Konfig::Schema do
    subject(:schema) { described_class.new }

    describe '#add_group' do
      it 'returns a new group and adds it to the schema' do
        group = schema.add_group(:example)
        expect(schema.groups[:example]).to eq group
      end

      it 'yields the new group if a block is given' do
        called = false
        schema.add_group(:example) do |g|
          expect(g).to be_a Konfig::SchemaGroup
          called = true
        end
        expect(called).to be true
      end
    end

    describe '#group' do
      it 'returns the group with the given name' do
        schema.add_group(:example)
        expect(schema.group(:example)).to be_a Konfig::SchemaGroup
      end

      it 'raises an error if the group does not exist' do
        expect { schema.group(:example) }.to raise_error Konfig::GroupNotFoundError
      end
    end

    describe '#group?' do
      it 'returns true if the group exists' do
        schema.add_group(:example)
        expect(schema.group?(:example)).to be true
      end

      it 'returns false if the group does not exist' do
        expect(schema.group?(:example)).to be false
      end
    end

    describe '#create_hash' do
      it 'returns a hash with the groups' do
        schema.add_group(:example) do |g|
          g.add_attribute(:hostname)
        end
        schema.add_group(:another) do |g|
          g.add_attribute(:username)
        end
        source = double('source')
        allow(source).to receive(:get).with([:example, :hostname],
                                            attribute: kind_of(SchemaAttribute)).and_return('localhost')
        allow(source).to receive(:get).with([:another, :username],
                                            attribute: kind_of(SchemaAttribute)).and_return('root')
        hash = schema.create_hash(source)
        expect(hash).to eq example: { hostname: 'localhost' }, another: { username: 'root' }
      end
    end

    describe '.draw' do
      it 'returns a new schema' do
        schema = described_class.draw
        expect(schema).to be_a Konfig::Schema
      end

      it 'yields the schema DSL if a block is given' do
        called = false
        described_class.draw do
          called = true
        end
        expect(called).to be true
      end
    end
  end

end
