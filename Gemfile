source 'https://rubygems.org'

# env var for travis
if ENV['CHEF_VERSION']
  if ENV['CHEF_VERSION'] == "master"
    gem 'chef', git: "https://github.com/chef/chef"
    gem 'ohai', git: "https://github.com/chef/ohai"
  else
    gem 'chef', ENV['CHEF_VERSION']
  end
end

gemspec

group :development do
  gem 'rake'
  gem 'redcarpet'
  gem 'yard'
end
