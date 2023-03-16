# frozen_string_literal: true

require 'spec_helper'
require 'konfig/schema_group'

module Konfig

  RSpec.describe Konfig::SchemaGroup do
    subject(:group) { described_class.new }

    describe '#add_attribute' do
      it 'adds the attribute' do
        group.add_attribute(:hostname)
        expect(group.attribute?(:hostname)).to be true
      end

      it 'returns the attribute' do
        expect(group.add_attribute(:hostname)).to be_a Konfig::SchemaAttribute
      end

      it 'passs on the values' do
        transformer = proc {}
        group.add_attribute(:hostname, type: :integer, array: true, default: 'localhost', transformer: transformer)
        attribute = group.attribute(:hostname)
        expect(attribute.type).to eq :integer
        expect(attribute.array?).to eq true
        expect(attribute.default).to eq 'localhost'
        expect(attribute.transformer).to eq transformer
      end

      it 'uses the block as the transformer if given' do
        block = proc {}
        group.add_attribute(:hostname, &block)
        attribute = group.attribute(:hostname)
        expect(attribute.transformer).to eq block
      end
    end

    describe '#attribute?' do
      it 'returns true if the attribute exists' do
        group.add_attribute(:hostname)
        expect(group.attribute?(:hostname)).to be true
      end

      it 'returns false if the attribute does not exist' do
        expect(group.attribute?(:hostname)).to be false
      end
    end

    describe '#attribute' do
      it 'returns the attribute' do
        group.add_attribute(:hostname)
        expect(group.attribute(:hostname)).to be_a Konfig::SchemaAttribute
      end

      it 'raises an error if the attribute does not exist' do
        expect { group.attribute(:hostname) }.to raise_error Konfig::AttributeNotFoundError
      end
    end

    describe '#create_hash' do
      context 'when given a source' do
        it 'returns a hash of the attributes' do
          group.add_attribute(:hostname)
          group.add_attribute(:port)
          source = double('source')
          allow(source).to receive(:get).with([:hostname], attribute: kind_of(SchemaAttribute)).and_return('localhost')
          allow(source).to receive(:get).with([:port], attribute: kind_of(SchemaAttribute)).and_return('8080')
          expect(group.create_hash([], source)).to eq(hostname: 'localhost', port: '8080')
        end

        it 'does not include attributes that are not in the source' do
          group.add_attribute(:hostname)
          group.add_attribute(:port)
          source = double('source')
          allow(source).to receive(:get).with([:hostname], attribute: kind_of(SchemaAttribute)).and_return('localhost')
          allow(source).to receive(:get).with([:port],
                                              attribute: kind_of(SchemaAttribute)).and_raise(ValueNotPresentError)
          expect(group.create_hash([], source)).to eq(hostname: 'localhost')
        end
      end

      context 'when not given a source' do
        it 'returns a hash with the default values only' do
          group.add_attribute(:hostname, default: 'localhost')
          group.add_attribute(:port, default: 8080)
          expect(group.create_hash([])).to eq(hostname: 'localhost', port: '8080')
        end

        it 'does include attributes that do not have a default value' do
          group.add_attribute(:hostname)
          group.add_attribute(:port)
          expect(group.create_hash([])).to eq(hostname: nil, port: nil)
        end
      end
    end
  end

end
