lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
require 'chefspec/version'

Gem::Specification.new do |s|
  s.name          = 'chefspec'
  s.version       = ChefSpec::VERSION
  s.authors       = ['Andrew Crump', 'Seth Vargo']
  s.email         = ['andrew.crump@ieee.org', 'sethvargo@gmail.com']
  s.summary       = 'Write RSpec examples and generate coverage reports for ' \
                    'Chef recipes!'
  s.description   = 'ChefSpec is a unit testing and resource coverage ' \
                    '(code coverage) framework for testing Chef cookbooks ' \
                    'ChefSpec makes it easy to write examples and get fast ' \
                    'feedback on cookbook changes without the need for ' \
                    'virtual machines or cloud servers.'
  s.homepage      = 'http://code.sethvargo.com/chefspec'
  s.license       = 'MIT'

  # Packaging
  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ['lib']

  # ChefSpec requires Ruby 1.9+
  s.required_ruby_version = '>= 1.9'

  s.add_dependency 'chef',    '~> 11.0'
  s.add_dependency 'fauxhai', '~> 2.0'
  s.add_dependency 'rspec',   '~> 2.14'
  s.add_dependency 'i18n',    '>= 0.6.9', '< 1.0.0'

  # Development Dependencies
  s.add_development_dependency 'chef-zero', '~> 1.7'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'redcarpet', '~> 3.0'
  s.add_development_dependency 'yard',      '~> 0.8'

  # Testing Dependencies
  s.add_development_dependency 'aruba', '~> 0.5'
end
