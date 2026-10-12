source "https://rubygems.org"

gemspec

group :development do
  gem "rake"
  gem "redcarpet"
  gem "yard"
  gem "pry"
  gem "pry-byebug"
end

if ENV["GEMFILE_MOD"]
  puts "GEMFILE_MOD: #{ENV["GEMFILE_MOD"]}"
  instance_eval(ENV["GEMFILE_MOD"])
else
  # chef's repo also ships chef-universal-mingw-ucrt.gemspec, which declares
  # itself as "chef" for the mingw platform and adds the Windows only
  # dependencies. Bundler loads every gemspec it finds in a git source, so
  # without this glob those Windows gems end up in the resolution on every
  # platform and the bundle cannot be installed on Linux or macOS.
  gem "chef", git: "https://github.com/chef/chef.git", glob: "{chef,chef-*/chef-*}.gemspec"
  gem "ohai", git: "https://github.com/chef/ohai.git"
end

gem "syslog"

# If you want to load debugging tools into the bundle exec sandbox,
# add these additional dependencies into Gemfile.local
eval_gemfile(__FILE__ + ".local") if File.exist?(__FILE__ + ".local")
