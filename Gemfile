source "https://rubygems.org"

gemspec

group :development do
  gem "rake"
  gem "redcarpet"
  gem "yard"
  gem "pry"
  gem "pry-byebug"
  gem "chefstyle"
end

if ENV["GEMFILE_MOD"]
  puts "GEMFILE_MOD: #{ENV["GEMFILE_MOD"]}"
  instance_eval(ENV["GEMFILE_MOD"])
else
  gem "chef", git: "https://github.com/chef/chef"
  gem "ohai", git: "https://github.com/chef/ohai"
end

# TODO: remove when we drop ruby 2.5
if Gem.ruby_version < Gem::Version.new("2.6")
  # 16.7.23 required ruby 2.6+
  gem "chef-utils", "< 16.7.23"
end

# If you want to load debugging tools into the bundle exec sandbox,
# add these additional dependencies into Gemfile.local
eval_gemfile(__FILE__ + ".local") if File.exist?(__FILE__ + ".local")
