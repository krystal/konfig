# frozen_string_literal: true

require 'spec_helper'
require 'konfig/sources/environment'

module Konfig

  RSpec.describe Konfig::Sources::Environment do
    let(:env) do
      {
        'EXAMPLE_HOSTNAME' => 'localhost',
        'EXAMPLE_PORT' => '8080',
        'EXAMPLE_TRUSTED_IPS' => '127.0.0.1, 8.8.8.8'
      }
    end

    let(:source) { described_class.new(env) }

    describe '#get' do
      it 'returns the value for the given path' do
        expect(source.get([:example, :hostname])).to eq('localhost')
        expect(source.get([:example, :port])).to eq('8080')
      end

      it 'raises an error if the value is not present' do
        expect { source.get([:example, :not_present]) }.to raise_error(ValueNotPresentError)
      end

      it 'converts arrays into arrays' do
        source = described_class.new(env)
        attribute = double('attribute')
        allow(attribute).to receive(:array?).and_return(true)
        expect(source.get([:example, :trusted_ips], attribute: attribute)).to eq(['127.0.0.1', '8.8.8.8'])
      end
    end
  end

end
