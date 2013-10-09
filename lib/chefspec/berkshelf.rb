begin
  require 'berkshelf'
rescue LoadError
  raise RuntimeError, "Berkshelf not found! You must have the berkshelf" \
    " installed on your system before requiring chefspec/berkshelf. Install" \
    " berkshelf by running:\n\n  gem install berkshelf\n\nor add Berkshelf" \
    " to your Gemfile:\n\n  gem 'berkshelf'\n\n"
end

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

      ::Berkshelf.ui.mute do
        ::Berkshelf::Berksfile.from_file('Berksfile').install(path: tmpdir)
      end

      ::RSpec.configure do |config|
        config.cookbook_path = tmpdir
      end
    end
  end
end

ChefSpec::Berkshelf.setup!
