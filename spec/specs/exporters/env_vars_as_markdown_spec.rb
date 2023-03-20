# frozen_string_literal: true

require 'spec_helper'
require 'konfig/exporters/env_vars_as_markdown'

module Konfig

  RSpec.describe Konfig::Exporters::EnvVarsAsMarkdown do
    # rubocop:disable Security/Eval
    let(:schema) { eval(File.read(File.expand_path('../../resource/schema.rb', __dir__))) }
    # rubocop:enable Security/Eval
    subject(:exporter) { described_class.new(schema) }

    it 'generates a markdown document' do
      output = exporter.export
      expect(output).to eq <<~MARKDOWN
        # Environment Variables

        This document contains all the environment variables which are available for this application.

        | Name | Type | Description | Default |
        | ---- | ---- | ----------- | ------- |
        | `RAILS_ENV` | String | The environment to run the app in | development |
        | `RAILS_LOG_TO_STDOUT` | Boolean | Whether to log to STDOUT | true |
        | `MYSQL_HOST` | String | The MySQL host | localhost |
        | `MYSQL_PORT` | Integer |  | 3306 |
        | `MYSQL_USERNAME` | String |  | root |
        | `MYSQL_PASSWORD` | String |  |  |
        | `MYSQL_DATABASE` | String |  | super_app |
        | `MYSQL_ROLES` | Array of strings |  | ["read", "write"] |
      MARKDOWN
    end
  end

end
