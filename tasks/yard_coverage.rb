#!/usr/bin/env ruby
#
# Fails if any public object in lib/ is missing YARD documentation.
#
# The check drives YARD's own statistics class rather than reimplementing its
# rules, so it always agrees with what `yard stats --list-undoc` reports. Those
# rules are subtler than they look: only public objects count, aliases and
# constructors are skipped, and a docstring holding nothing but an invisible
# tag (`@api private`) still counts as undocumented.
#
# Kept free of ChefSpec's own requires so it can run with nothing but the yard
# gem installed, rather than needing the whole bundle resolved.
#
# Usage: bundle exec rake yard:coverage
#        ruby tasks/yard_coverage.rb
#

require "stringio"
require "yard"

ROOT = File.expand_path("..", __dir__)

# YARD logs its statistics table, plus parser warnings about Chef's anonymous
# `prepend(Module.new do ... end)` patches that it cannot index. Capture all of
# it so this script controls what reaches the terminal.
captured = StringIO.new
log.io = captured
log.level = YARD::Logger::ERROR

stats = YARD::CLI::Stats.new
stats.run("--list-undoc", "--no-output", File.join(ROOT, "lib", "**", "*.rb"))

unless stats.instance_variable_defined?(:@undoc_list)
  abort "Could not read the undocumented object list from YARD::CLI::Stats. " \
        "This check needs updating for yard #{YARD::VERSION}."
end

undocumented = Array(stats.instance_variable_get(:@undoc_list))
percentage = captured.string[/[\d.]+% documented/] || "unknown coverage"

if undocumented.empty?
  puts "YARD documentation coverage: #{percentage}"
  exit 0
end

warn "YARD documentation coverage: #{percentage}"
warn ""
warn "#{undocumented.size} public object(s) are missing YARD documentation:"
warn ""
undocumented.sort_by { |o| [o.file.to_s, o.path] }.each do |object|
  location = [object.file&.sub("#{ROOT}/", "") || "-unknown-", object.line].compact.join(":")
  warn "  #{object.path}  (#{location})"
end
warn ""
warn "Every public class, module, constant, attribute, and method in lib/ needs"
warn "a YARD comment. See the Documentation section of CONTRIBUTING.md."
exit 1
