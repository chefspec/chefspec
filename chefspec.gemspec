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
  s.homepage      = 'https://sethvargo.github.io/chefspec/'
  s.license       = 'MIT'

  # Packaging
  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ['lib']

  s.required_ruby_version = '>= 2.2'

  s.add_dependency 'chef',    '>= 12.14.89'
  s.add_dependency 'fauxhai', '>= 4', '< 6'
  s.add_dependency 'rspec',   '~> 3.0'
end
