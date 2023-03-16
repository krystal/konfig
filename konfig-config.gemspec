# frozen_string_literal: true

require File.expand_path('lib/konfig/version', __dir__)

# rubocop:disable Gemspec/RequireMFA
Gem::Specification.new do |s|
  s.name          = 'konfig-config'
  s.description   = 'A config schema generator'
  s.summary       = s.description
  s.required_ruby_version = '>= 2.6'
  s.homepage      = 'https://github.com/krystal/konfig'
  s.version       = Konfig::VERSION
  s.files         = Dir.glob('{lib}/**/*')
  s.require_paths = ['lib']
  s.authors       = ['Adam Cooke']
  s.email         = ['adam@krystal.uk']
  s.licenses      = ['MIT']
  s.add_runtime_dependency 'hashie'
end
# rubocop:enable Gemspec/RequireMFA
