# frozen_string_literal: true

require 'spec_helper'
require 'konfig/sources/directory'

module Konfig

  RSpec.describe Konfig::Sources::Directory do
    before do
      allow(File).to receive(:exist?).with('path/to/config/example.hostname').and_return(true)
      allow(File).to receive(:exist?).with('path/to/config/example.port').and_return(true)
      allow(File).to receive(:exist?).with('path/to/config/example.trusted_ips').and_return(true)
      allow(File).to receive(:exist?).with('path/to/config/example.not_present').and_return(false)

      allow(File).to receive(:read).with('path/to/config/example.hostname').and_return('localhost')
      allow(File).to receive(:read).with('path/to/config/example.port').and_return('8080')
      allow(File).to receive(:read).with('path/to/config/example.trusted_ips').and_return("1.2.3.4\n5.5.5.5\n4.4.4.4")
    end
    let(:source) { described_class.new('path/to/config') }

    describe '#get' do
      it 'returns the value for the given path' do
        expect(source.get([:example, :hostname])).to eq('localhost')
        expect(source.get([:example, :port])).to eq('8080')
      end

      it 'raises an error if the value is not present' do
        expect { source.get([:example, :not_present]) }.to raise_error(ValueNotPresentError)
      end

      it 'converts arrays into arrays' do
        attribute = double('attribute')
        allow(attribute).to receive(:array?).and_return(true)
        expect(source.get([:example, :trusted_ips], attribute: attribute)).to eq(['1.2.3.4', '5.5.5.5', '4.4.4.4'])
      end
    end
  end

end
