# frozen_string_literal: true

require 'konfig/exporters/abstract'
require 'konfig/sources/environment'

module Konfig
  module Exporters
    # This export will create a markdown document containing all configuration variables
    # as defined the schema shown as environment variables.
    class EnvVarsAsMarkdown < Abstract

      # rubocop:disable Metrics/AbcSize
      # rubocop:disable Metrics/MethodLength
      def export
        contents = []
        contents << "# #{options[:title] || 'Environment Variables'}"
        contents << ''
        contents << (options[:introduction] ||
            'This document contains all the environment variables which are available for this application.')
        contents << ''
        contents << '| Name | Type | Description | Default |'
        contents << '| ---- | ---- | ----------- | ------- |'
        path = []
        @schema.groups.each do |group_name, group|
          path << group_name
          group.attributes.each do |name, attr|
            env_var = Sources::Environment.path_to_env_var(path + [name])
            type = attr.array? ? "Array of #{attr.type}s" : attr.type.to_s.capitalize
            contents << "| `#{env_var}` | #{type} | #{attr.description} | #{attr.default} |"
          end
          path.pop
        end
        contents.join("\n") + "\n"
      end
      # rubocop:enable Metrics/AbcSize
      # rubocop:enable Metrics/MethodLength

    end
  end
end
