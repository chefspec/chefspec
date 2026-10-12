require "bundler/gem_tasks"
require "rspec/core"
require "rspec/core/rake_task"
require "yard/rake/yardoc_task"
require "tmpdir"
require "rspec"
require "chefspec"
require "cookstyle/chefstyle"
require "chef/version"

YARD::Rake::YardocTask.new

namespace :yard do
  desc "Verify that every public object in lib/ has YARD documentation."
  task :coverage do
    ruby File.join(__dir__, "tasks", "yard_coverage.rb")
  end
end

RSpec::Core::RakeTask.new(:unit) do |t|
  t.rspec_opts = [].tap do |a|
    a.push("--color")
    a.push("--format progress")
  end.join(" ")
end

failed = []
start_time = nil

namespace :acceptance do |ns|

  Dir.foreach("examples") do |dir|
    next if %w{. .. .DS_Store}.include?(dir)

    desc "#{dir} acceptance tests"
    task dir.to_sym do
      start_time ||= Time.now
      Dir.mktmpdir do |tmp|
        FileUtils.cp_r("examples/#{dir}", tmp)

        pwd = Dir.pwd

        Dir.chdir "#{tmp}/#{dir}" do
          puts "rspec examples/#{dir}"

          #
          # This bit of mildly awful magic below is to load each file into an in-memory
          # RSpec runner. RSpec.reset drops the configuration between example
          # directories, which takes ChefSpec's own hooks with it, so the hooks
          # below re-register them for every directory and have to mirror the set
          # in lib/chefspec/zero_server.rb.
          #
          load "#{pwd}/lib/chefspec/rspec.rb"

          RSpec.configure do |config|
            config.full_backtrace = true
            config.color = true
            config.run_all_when_everything_filtered = true
            config.filter_run(:focus)
            # No before(:suite) hook: the server starts on demand, so a directory
            # that only uses the SoloRunner never starts one.
            config.after(:each) do
              ChefSpec::ZeroServer.reset!
            end
            config.after(:suite) do
              ChefSpec::ZeroServer.teardown!
            end
          end

          RSpec.clear_examples
          exitstatus = RSpec::Core::Runner.run(["spec"])
          RSpec.reset
          failed << dir unless exitstatus == 0
        end
      end
    end
  end
rescue Errno::ENOENT # examples dir is probably missing
  puts "The rake acceptance tests require a full git checkout of chefspec including all examples files!"

end

task acceptance: Rake.application.tasks.select { |t| t.name.start_with?("acceptance:") } do
  puts "Acceptance tests took #{Time.now - start_time} seconds"
  raise "some tests failed: #{failed.join(", ")}" unless failed.empty?
end

desc "Run all tests"
task test: %i{unit acceptance}

task default: [:test]

desc "Check Linting and code style."
task :style do
  require "rubocop/rake_task"
  require "cookstyle/chefstyle"

  if RbConfig::CONFIG["host_os"] =~ /mswin|mingw|cygwin/
    # Windows-specific command, rubocop erroneously reports the CRLF in each file which is removed when your PR is uploaded to GitHub.
    # This is a workaround to ignore the CRLF from the files before running cookstyle.
    sh "cookstyle --chefstyle -c .rubocop.yml --except Layout/EndOfLine"
  else
    sh "cookstyle --chefstyle -c .rubocop.yml"
  end
rescue LoadError
  puts "Rubocop or Cookstyle gems are not installed. bundle install first to make sure all dependencies are installed."
end
