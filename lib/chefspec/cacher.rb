module ChefSpec
  #
  # The cacher module allows for ultra-fast tests by caching the results of a
  # CCR in memory across an example group. In testing, this can reduce the
  # total testing time by a factor of 10x. This strategy is _not_ the default
  # behavior, because it has implications surrounding stubbing and is _not_
  # threadsafe!
  #
  # The credit for this approach and code belongs to Juri Timošin (DracoAter).
  # Please see his original blog post below for an in-depth explanation of how
  # and why this approach is faster.
  #
  # @example Using the Cacher module
  #   First, require the Cacher module in your +spec_helper.rb+:
  #
  #     RSpec.configure do |config|
  #       config.extend(ChefSpec::Cacher)
  #     end
  #
  #   Next, change your +let+ blocks to +cached+ blocks:
  #
  #     let(:chef_run) { ... } #=> cached(:chef_run) { ... }
  #
  #   Finally, celebrate!
  #
  # @warn
  #   This strategy is only recommended for advanced users, as it makes
  #   stubbing slightly more difficult and indirect!
  #
  # @see http://dracoater.blogspot.com/2013/12/testing-chef-cookbooks-part-25-speeding.html
  #
  module Cacher
    @@cache = {}
    #
    # Drops a thread's cached results when that thread is garbage collected, so
    # the cache does not grow without bound in threaded runs.
    #
    FINALIZER = lambda { |id| @@cache.delete(id) }

    #
    # Define a memoized helper, like RSpec's +let+, whose value is cached across
    # every example in the group rather than rebuilt per example.
    #
    # The cache key is derived from the example group's source location, so two
    # groups declaring the same name do not collide.
    #
    # @example
    #   cached(:chef_run) { ChefSpec::SoloRunner.converge("example::default") }
    #
    # @param [Symbol, String] name
    #   the name of the helper method to define
    #
    # @yieldreturn [Object]
    #   the value to cache
    #
    # @return [void]
    #
    def cached(name, &block)
      location = ancestors.first.metadata[:location]
      unless location.nil?
        location += ancestors.first.metadata[:description] unless ancestors.first.metadata[:description].nil?
        location += ancestors.first.metadata[:scoped_id] unless ancestors.first.metadata[:scoped_id].nil?
      end
      location ||= ancestors.first.metadata[:parent_example_group][:location]

      define_method(name) do
        key = [location, name.to_s].join(".")
        unless @@cache.key?(Thread.current.object_id)
          ObjectSpace.define_finalizer(Thread.current, FINALIZER)
        end
        @@cache[Thread.current.object_id] ||= {}
        @@cache[Thread.current.object_id][key] ||= instance_eval(&block)
      end
    end

    #
    # Like {#cached}, but eagerly evaluates the block in a +before+ hook instead
    # of waiting for the first example to reference it.
    #
    # @param [Symbol, String] name
    #   the name of the helper method to define
    #
    # @yieldreturn [Object]
    #   the value to cache
    #
    # @return [void]
    #
    def cached!(name, &block)
      cached(name, &block)

      before { send(name) }
    end
  end
end

RSpec.configure do |config|
  config.extend(ChefSpec::Cacher)
end
