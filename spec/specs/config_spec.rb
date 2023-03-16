# frozen_string_literal: true

require 'spec_helper'
require 'konfig/config'
require 'konfig/schema'

module Konfig

  RSpec.describe Konfig::Config do
    context 'with a single source with no defaults' do
      let(:schema) do
        schema = Schema.new
        schema.add_group(:example) do |g|
          g.add_attribute(:hostname)
          g.add_attribute(:port)
          g.add_attribute(:names, array: true)
        end
        schema
      end

      let(:source1) do
        source = double('source')
        allow(source).to receive(:get).with([:example, :hostname],
                                            attribute: kind_of(SchemaAttribute)).and_return('localhost')
        allow(source).to receive(:get).with([:example, :port],
                                            attribute: kind_of(SchemaAttribute)).and_return('8080')
        allow(source).to receive(:get).with([:example, :names],
                                            attribute: kind_of(SchemaAttribute)).and_return(%w[adam bob charlie])
        source
      end

      describe '.build' do
        it 'returns a hash with the values from the source' do
          hash = described_class.build(schema, sources: [source1])
          expect(hash).to eq({ 'example' => { 'hostname' => 'localhost', 'port' => '8080',
                                              'names' => %w[adam bob charlie] } })
        end

        it 'allow values to accessed using dot notation' do
          hash = described_class.build(schema, sources: [source1])
          expect(hash.example.hostname).to eq('localhost')
          expect(hash.example.port).to eq('8080')
        end
      end
    end

    context 'with a single source with some defaults' do
      let(:schema) do
        schema = Schema.new
        schema.add_group(:example) do |g|
          g.add_attribute(:hostname, default: '127.0.0.1')
          g.add_attribute(:port)
        end
        schema
      end

      let(:source1) do
        source = double('source')
        allow(source).to receive(:get).with([:example, :hostname],
                                            attribute: kind_of(SchemaAttribute)).and_raise(ValueNotPresentError)
        allow(source).to receive(:get).with([:example, :port],
                                            attribute: kind_of(SchemaAttribute)).and_return('8080')
        source
      end

      describe '.build' do
        it 'returns a hash with the default values' do
          hash = described_class.build(schema, sources: [source1])
          expect(hash).to eq({ 'example' => { 'hostname' => '127.0.0.1', 'port' => '8080' } })
        end
      end
    end

    context 'with multiple sources with some defaults' do
      let(:schema) do
        schema = Schema.new
        schema.add_group(:example) do |g|
          g.add_attribute(:hostname, default: '127.0.0.1')
          g.add_attribute(:port, default: '3306')
          g.add_attribute(:username)
          g.add_attribute(:password)
        end
        schema
      end

      let(:source1) do
        source = double('source')
        allow(source).to receive(:get).with([:example, :hostname],
                                            attribute: kind_of(SchemaAttribute)).and_raise(ValueNotPresentError)
        allow(source).to receive(:get).with([:example, :port],
                                            attribute: kind_of(SchemaAttribute)).and_raise(ValueNotPresentError)
        allow(source).to receive(:get).with([:example, :username],
                                            attribute: kind_of(SchemaAttribute)).and_return('root')
        allow(source).to receive(:get).with([:example, :password],
                                            attribute: kind_of(SchemaAttribute)).and_return('llamafarm')
        source
      end

      let(:source2) do
        source = double('source')
        allow(source).to receive(:get).with([:example, :hostname],
                                            attribute: kind_of(SchemaAttribute)).and_raise(ValueNotPresentError)
        allow(source).to receive(:get).with([:example, :port],
                                            attribute: kind_of(SchemaAttribute)).and_raise(ValueNotPresentError)
        allow(source).to receive(:get).with([:example, :username],
                                            attribute: kind_of(SchemaAttribute)).and_return('steve')
        allow(source).to receive(:get).with([:example, :password],
                                            attribute: kind_of(SchemaAttribute)).and_raise(ValueNotPresentError)
        source
      end

      it 'returns a hash with the values from source2 preferred over source1 and then defaults' do
        hash = described_class.build(schema, sources: [source2, source1])
        expect(hash).to eq({ 'example' => { 'hostname' => '127.0.0.1', 'port' => '3306', 'username' => 'steve',
                                            'password' => 'llamafarm' } })
      end
    end
  end

end
