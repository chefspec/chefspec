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
  s.add_dependency('fauxhai', '~> 0.1')
  s.add_dependency('minitest-chef-handler', '~> 0.6.0')
  s.add_dependency('rspec', '~> 2.12.0')

  # Development Dependencies
  s.add_development_dependency('rake', '~> 0.9.2.2')
  s.add_development_dependency('yard', '~> 0.8.1')

  # Testing Dependencies
  s.add_development_dependency('aruba', '~> 0.4.11')
  s.add_development_dependency('cucumber', '~> 1.2.0')
  s.add_development_dependency('i18n', '~> 0.6.0')
  s.add_development_dependency('simplecov', '~> 0.6.4')
end
