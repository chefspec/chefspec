begin
  require 'berkshelf'
rescue LoadError
  raise RuntimeError, "Berkshelf not found! You must have the berkshelf" \
    " installed on your system before requiring chefspec/berkshelf. Install" \
    " berkshelf by running:\n\n  gem install berkshelf\n\nor add Berkshelf" \
    " to your Gemfile:\n\n  gem 'berkshelf'\n\n"
end

require 'fileutils'

module ChefSpec
  class Berkshelf
    class << self
      extend Forwardable
      def_delegators :instance, :setup!
    end

    include Singleton

    def initialize
      setup!
    end

    def setup!
      tmpdir = Dir.mktmpdir

      vendor_cookbooks(tmpdir)

      ::RSpec.configure do |config|
        config.cookbook_path = tmpdir
      end
    end

    private

    def vendor_cookbooks(path)
      ::Berkshelf.ui.mute do
        berksfile = ::Berkshelf::Berksfile.from_file('Berksfile')
        if berksfile.respond_to?(:vendor)
          FileUtils.rm_rf(path)
          berksfile.vendor(path)
        else
          berksfile.install(path: path)
        end
      end
    end
  end
end

ChefSpec::Berkshelf.setup!
