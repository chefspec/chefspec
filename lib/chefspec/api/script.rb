module ChefSpec::API
  # @since 1.0.0
  module ScriptMatchers
    #
    # Assert that a +ksh+ resource exists in the Chef run with the
    # action +:run+. Given a Chef Recipe that runs "command" using
    # +ksh+:
    #
    #     ksh 'command' do
    #       action :run
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +ksh+ resource with ChefSpec.
    #
    # @example Assert that a +ksh+ was run
    #   expect(chef_run).to run_ksh('command')
    #
    # @example Assert that a +ksh+ was run with predicate matchers
    #   expect(chef_run).to run_ksh('command').with_cwd('/home')
    #
    # @example Assert that a +ksh+ was run with attributes
    #   expect(chef_run).to run_ksh('command').with(cwd: '/home')
    #
    # @example Assert that a +ksh+ was run using a regex
    #   expect(chef_run).to run_ksh('command').with(cwd: /\/(.+)/)
    #
    # @example Assert that a +ksh+ was _not_ run
    #   expect(chef_run).to_not run_ksh('command')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def run_ksh(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:ksh, :run, resource_name)
    end

    ChefSpec.define_matcher :ksh

    #
    # Assert that a +bash+ resource exists in the Chef run with the
    # action +:run+. Given a Chef Recipe that runs "command" using
    # +bash+:
    #
    #     bash 'command' do
    #       action :run
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +bash+ resource with ChefSpec.
    #
    # @example Assert that a +bash+ was run
    #   expect(chef_run).to run_bash('command')
    #
    # @example Assert that a +bash+ was run with predicate matchers
    #   expect(chef_run).to run_bash('command').with_cwd('/home')
    #
    # @example Assert that a +bash+ was run with attributes
    #   expect(chef_run).to run_bash('command').with(cwd: '/home')
    #
    # @example Assert that a +bash+ was run using a regex
    #   expect(chef_run).to run_bash('command').with(cwd: /\/(.+)/)
    #
    # @example Assert that a +bash+ was _not_ run
    #   expect(chef_run).to_not run_bash('command')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def run_bash(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:bash, :run, resource_name)
    end

    ChefSpec.define_matcher :bash

    #
    # Assert that a +csh+ resource exists in the Chef run with the
    # action +:run+. Given a Chef Recipe that runs "command" using
    # +csh+:
    #
    #     csh 'command' do
    #       action :run
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +csh+ resource with ChefSpec.
    #
    # @example Assert that a +csh+ was run
    #   expect(chef_run).to run_csh('command')
    #
    # @example Assert that a +csh+ was run with predicate matchers
    #   expect(chef_run).to run_csh('command').with_cwd('/home')
    #
    # @example Assert that a +csh+ was run with attributes
    #   expect(chef_run).to run_csh('command').with(cwd: '/home')
    #
    # @example Assert that a +csh+ was run using a regex
    #   expect(chef_run).to run_csh('command').with(cwd: /\/(.+)/)
    #
    # @example Assert that a +csh+ was _not_ run
    #   expect(chef_run).to_not run_csh('command')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def run_csh(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:csh, :run, resource_name)
    end

    ChefSpec.define_matcher :csh

    #
    # Assert that a +perl+ resource exists in the Chef run with the
    # action +:run+. Given a Chef Recipe that runs "command" using
    # +perl+:
    #
    #     perl 'command' do
    #       action :run
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +perl+ resource with ChefSpec.
    #
    # @example Assert that a +perl+ was run
    #   expect(chef_run).to run_perl('command')
    #
    # @example Assert that a +perl+ was run with predicate matchers
    #   expect(chef_run).to run_perl('command').with_cwd('/home')
    #
    # @example Assert that a +perl+ was run with attributes
    #   expect(chef_run).to run_perl('command').with(cwd: '/home')
    #
    # @example Assert that a +perl+ was run using a regex
    #   expect(chef_run).to run_perl('command').with(cwd: /\/(.+)/)
    #
    # @example Assert that a +perl+ was _not_ run
    #   expect(chef_run).to_not run_perl('command')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def run_perl(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:perl, :run, resource_name)
    end

    ChefSpec.define_matcher :perl

    #
    # Assert that a +python+ resource exists in the Chef run with the
    # action +:run+. Given a Chef Recipe that runs "command" using
    # +python+:
    #
    #     python 'command' do
    #       action :run
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +python+ resource with ChefSpec.
    #
    # @example Assert that a +python+ was run
    #   expect(chef_run).to run_python('command')
    #
    # @example Assert that a +python+ was run with predicate matchers
    #   expect(chef_run).to run_python('command').with_cwd('/home')
    #
    # @example Assert that a +python+ was run with attributes
    #   expect(chef_run).to run_python('command').with(cwd: '/home')
    #
    # @example Assert that a +python+ was run using a regex
    #   expect(chef_run).to run_python('command').with(cwd: /\/(.+)/)
    #
    # @example Assert that a +python+ was _not_ run
    #   expect(chef_run).to_not run_python('command')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def run_python(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:python, :run, resource_name)
    end

    ChefSpec.define_matcher :python

    #
    # Assert that a +ruby+ resource exists in the Chef run with the
    # action +:run+. Given a Chef Recipe that runs "command" using
    # +ruby+:
    #
    #     ruby 'command' do
    #       action :run
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +ruby+ resource with ChefSpec.
    #
    # @example Assert that a +ruby+ was run
    #   expect(chef_run).to run_ruby('command')
    #
    # @example Assert that a +ruby+ was run with predicate matchers
    #   expect(chef_run).to run_ruby('command').with_cwd('/home')
    #
    # @example Assert that a +ruby+ was run with attributes
    #   expect(chef_run).to run_ruby('command').with(cwd: '/home')
    #
    # @example Assert that a +ruby+ was run using a regex
    #   expect(chef_run).to run_ruby('command').with(cwd: /\/(.+)/)
    #
    # @example Assert that a +ruby+ was _not_ run
    #   expect(chef_run).to_not run_ruby('command')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def run_ruby(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:ruby, :run, resource_name)
    end

    ChefSpec.define_matcher :ruby

    #
    # Assert that a +script+ resource exists in the Chef run with the
    # action +:run+. Given a Chef Recipe that runs "command" using
    # +script+:
    #
    #     script 'command' do
    #       action :run
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +script+ resource with ChefSpec.
    #
    # @example Assert that a +script+ was run
    #   expect(chef_run).to run_script('command')
    #
    # @example Assert that a +script+ was run with predicate matchers
    #   expect(chef_run).to run_script('command').with_cwd('/home')
    #
    # @example Assert that a +script+ was run with attributes
    #   expect(chef_run).to run_script('command').with(cwd: '/home')
    #
    # @example Assert that a +script+ was run using a regex
    #   expect(chef_run).to run_script('command').with(cwd: /\/(.+)/)
    #
    # @example Assert that a +script+ was _not_ run
    #   expect(chef_run).to_not run_script('command')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def run_script(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:script, :run, resource_name)
    end


    ChefSpec.define_matcher :script
  end
end
