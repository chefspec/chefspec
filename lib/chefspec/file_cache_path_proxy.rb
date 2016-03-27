require 'fileutils'
require 'singleton'

module ChefSpec
  class FileCachePathProxy
    include Singleton

    attr_reader :file_cache_path

    def initialize
      @file_cache_path = Dir.mktmpdir(["chefspec", "file_cache_path"])
      at_exit { FileUtils.rm_rf(@file_cache_path) }
    end
  end
end
