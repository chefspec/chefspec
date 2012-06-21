chef_version = ENV.key?('CHEF_VERSION') ? "= #{ENV['CHEF_VERSION']}" : ['>= 0.9.12']
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
require 'chefspec/version'
Gem::Specification.new do |s|
  s.name = 'chefspec'
  s.version = ChefSpec::VERSION
  s.description = 'Write RSpec examples for Opscode Chef recipes'
  s.summary = "chefspec-#{s.version}"
  s.authors = ['Andrew Crump']
  s.homepage = 'http://acrmp.github.com/chefspec'
  s.license = 'MIT'
  s.require_path = 'lib'
  s.files = Dir['lib/**/*.rb']
  s.add_dependency('chef', chef_version)
  s.add_dependency('erubis', '>= 0')
  s.add_dependency('rspec', '~> 2.10.0')
end
