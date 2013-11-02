lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'chefspec/version'
Gem::Specification.new do |s|
  s.name = 'chefspec'
  s.version = ChefSpec::VERSION
  s.description = 'Write RSpec examples for Opscode Chef recipes'
  s.summary = "chefspec-#{s.version}"
  s.authors = ['Andrew Crump', 'Seth Vargo']
  s.homepage = 'http://acrmp.github.com/chefspec'
  s.license = 'MIT'
  s.require_path = 'lib'
  s.required_ruby_version = '>= 1.9'
  s.files = Dir['lib/**/*.rb']

  s.add_dependency 'chef',    '~> 11.0'
  s.add_dependency 'fauxhai', '~> 1.1'
  s.add_dependency 'rspec',   '~> 2.14'

  # Development Dependencies
  s.add_development_dependency 'rake'
  s.add_development_dependency 'redcarpet', '~> 3.0'
  s.add_development_dependency 'yard',      '~> 0.8'

  # Testing Dependencies
  s.add_development_dependency 'aruba', '~> 0.5'
  s.add_development_dependency 'oj',    '~> 2.1'
end
