Gem::Specification.new do |s|
  s.name = 'chefspec'
  s.version = '0.0.2'
  s.description = 'Write RSpec examples for Opscode Chef recipes'
  s.summary = "chefspec-#{s.version}"
  s.authors = ['Andrew Crump']
  s.homepage = 'http://acrmp.github.com/chefspec'
  s.license = 'MIT'
  s.require_path = 'lib'
  s.files = Dir['lib/**/*.rb']
  s.add_dependency('chef', '= 0.9.12')
  s.add_dependency('rspec', '>= 2.6.0')
end
