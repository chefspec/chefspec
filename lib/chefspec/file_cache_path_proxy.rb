require "fileutils" unless defined?(FileUtils)
require "singleton" unless defined?(Singleton)

module ChefSpec
  #
  # Supplies a single temporary +file_cache_path+ for the whole suite.
  #
  # {ChefSpec::ServerRunner} needs the path to stay constant across runs, or
  # Chef reloads the same cookbook repeatedly. The directory is removed at
  # process exit.
  #
  class FileCachePathProxy
    include Singleton

    attr_reader :file_cache_path

    def initialize
      @file_cache_path = Dir.mktmpdir(%w{chefspec file_cache_path})
      at_exit { FileUtils.rm_rf(@file_cache_path) }
    end
  end
end
