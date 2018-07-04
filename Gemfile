source 'https://rubygems.org'

gemspec

group :development do
  gem 'rake'
  gem 'redcarpet'
  gem 'yard'
  gem 'pry'
  gem 'pry-byebug'
end

if ENV["GEMFILE_MOD"]
  puts "GEMFILE_MOD: #{ENV['GEMFILE_MOD']}"
  instance_eval(ENV["GEMFILE_MOD"])
else
  gem 'chef', git: "https://github.com/chef/chef"
  gem 'ohai', git: "https://github.com/chef/ohai"
end

# If you want to load debugging tools into the bundle exec sandbox,
# add these additional dependencies into Gemfile.local
eval_gemfile(__FILE__ + ".local") if File.exist?(__FILE__ + ".local")
