# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('.')
require 'lib/cluda/version'

Gem::Specification.new do |s|
  s.name           = 'cluda'
  s.version        = Cluda::VERSION
  s.date           = Time.now.strftime('%Y-%m-%d').to_s
  s.summary        = 'CLuDA'
  s.license        = 'MIT'
  s.description    = 'CLustering Data Analysis gem'
  s.authors        = ['Enrique M Figuerola Gomez']
  s.email          = 'me@emfigo.com'
  s.files          = Dir.glob('lib/**/*')
  s.require_paths  = ['lib']
  s.homepage       = 'https://github.com/emfigo/cluda'

  s.required_ruby_version = '>= 2.3'

  s.add_development_dependency 'rake', '~> 12.3'
  s.add_development_dependency 'rspec', '~> 3.8'
  s.add_development_dependency 'rubocop', '~> 0.70'
end
