# frozen_string_literal: true

require 'spec_helper'
require 'konfig/sources/yaml'

module Konfig

  RSpec.describe Konfig::Sources::YAML do
    let(:yaml) do
      <<~YAML
        example:
          hostname: localhost
          port: 8080
          trusted_ips:
            - 127.0.0.1
            - 8.8.8.8
      YAML
    end

    let(:source) { described_class.new(yaml) }

    describe '#get' do
      it 'returns the value for the given path' do
        expect(source.get([:example, :hostname])).to eq('localhost')
        expect(source.get([:example, :port])).to eq(8080)
      end

      it 'raises an error if the value is not present' do
        expect { source.get([:example, :not_present]) }.to raise_error(ValueNotPresentError)
      end
    end
  end

end
