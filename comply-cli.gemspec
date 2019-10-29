# encoding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'English'
require 'comply/cli/version'

Gem::Specification.new do |spec|
  spec.name          = 'comply-cli'
  spec.version       = Comply::CLI::VERSION
  spec.authors       = ['Frank Macreery']
  spec.email         = ['frank@macreery.com']
  spec.description   = 'Comply CLI'
  spec.summary       = 'Command-line interface for Aptible Comply'
  spec.homepage      = 'https://github.com/aptible/comply-cli'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($RS)
  spec.executables   = spec.files.grep(%r{bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{spec/})
  spec.require_paths = ['lib']

  spec.add_dependency 'aptible-resource', '~> 1.1'
  spec.add_dependency 'aptible-auth', '~> 1.0'
  spec.add_dependency 'thor', '~> 0.20.0'
  spec.add_dependency 'chronic_duration', '~> 0.10.6'
  spec.add_development_dependency 'rspec', '~> 3.2'
  spec.add_development_dependency 'climate_control', '= 0.0.3'
  spec.add_development_dependency 'aptible-tasks', '~> 0.5.8'
  spec.add_development_dependency 'pry'
end
