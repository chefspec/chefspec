module ChefSpec::API
  ChefSpec.define_matcher :user

  #
  # Assert that a +user+ resource exists in the Chef run with the
  # action +:create+. Given a Chef Recipe that creates "apache2" as a
  # +user+:
  #
  #     user 'apache2' do
  #       action :create
  #     end
  #
  # The Examples section demonstrates the different ways to test a
  # +user+ resource with ChefSpec.
  #
  # @example Assert that a +user+ was created
  #   expect(chef_run).to create_user('apache2')
  #
  # @example Assert that a +user+ was created with predicate matchers
  #   expect(chef_run).to create_user('apache2').with_uid(1234)
  #
  # @example Assert that a +user+ was created with attributes
  #   expect(chef_run).to create_user('apache2').with(uid: 1234)
  #
  # @example Assert that a +user+ was created using a regex
  #   expect(chef_run).to create_user('apache2').with(uid: /\d+/)
  #
  # @example Assert that a +user+ was _not_ created
  #   expect(chef_run).to_not create_user('apache2')
  #
  #
  # @param [String, Regex] resource_name
  #   the name of the resource to match
  #
  # @return [ChefSpec::Matchers::ResourceMatcher]
  #
  def create_user(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:user, :create, resource_name)
  end

  #
  # Assert that a +user+ resource exists in the Chef run with the
  # action +:remove+. Given a Chef Recipe that removes "apache2" as a
  # +user+:
  #
  #     user 'apache2' do
  #       action :remove
  #     end
  #
  # The Examples section demonstrates the different ways to test a
  # +user+ resource with ChefSpec.
  #
  # @example Assert that a +user+ was remove
  #   expect(chef_run).to remove_user('apache2')
  #
  # @example Assert that a +user+ was remove with predicate matchers
  #   expect(chef_run).to remove_user('apache2').with_uid(1234)
  #
  # @example Assert that a +user+ was remove with attributes
  #   expect(chef_run).to remove_user('apache2').with(uid: 1234)
  #
  # @example Assert that a +user+ was remove using a regex
  #   expect(chef_run).to remove_user('apache2').with(uid: /\d+/)
  #
  # @example Assert that a +user+ was _not_ remove
  #   expect(chef_run).to_not remove_user('apache2')
  #
  #
  # @param [String, Regex] resource_name
  #   the name of the resource to match
  #
  # @return [ChefSpec::Matchers::ResourceMatcher]
  #
  def remove_user(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:user, :remove, resource_name)
  end

  #
  # Assert that a +user+ resource exists in the Chef run with the
  # action +:modify+. Given a Chef Recipe that modifies "apache2" as a
  # +user+:
  #
  #     user 'apache2' do
  #       action :modify
  #     end
  #
  # The Examples section demonstrates the different ways to test a
  # +user+ resource with ChefSpec.
  #
  # @example Assert that a +user+ was modified
  #   expect(chef_run).to modify_user('apache2')
  #
  # @example Assert that a +user+ was modified with predicate matchers
  #   expect(chef_run).to modify_user('apache2').with_uid(1234)
  #
  # @example Assert that a +user+ was modified with attributes
  #   expect(chef_run).to modify_user('apache2').with(uid: 1234)
  #
  # @example Assert that a +user+ was modified using a regex
  #   expect(chef_run).to modify_user('apache2').with(uid: /\d+/)
  #
  # @example Assert that a +user+ was _not_ modified
  #   expect(chef_run).to_not modify_user('apache2')
  #
  #
  # @param [String, Regex] resource_name
  #   the name of the resource to match
  #
  # @return [ChefSpec::Matchers::ResourceMatcher]
  #
  def modify_user(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:user, :modify, resource_name)
  end

  #
  # Assert that a +user+ resource exists in the Chef run with the
  # action +:manage+. Given a Chef Recipe that manages "apache2" as a
  # +user+:
  #
  #     user 'apache2' do
  #       action :manage
  #     end
  #
  # The Examples section demonstrates the different ways to test a
  # +user+ resource with ChefSpec.
  #
  # @example Assert that a +user+ was managed
  #   expect(chef_run).to manage_user('apache2')
  #
  # @example Assert that a +user+ was managed with predicate matchers
  #   expect(chef_run).to manage_user('apache2').with_uid(1234)
  #
  # @example Assert that a +user+ was managed with attributes
  #   expect(chef_run).to manage_user('apache2').with(uid: 1234)
  #
  # @example Assert that a +user+ was managed using a regex
  #   expect(chef_run).to manage_user('apache2').with(uid: /\d+/)
  #
  # @example Assert that a +user+ was _not_ managed
  #   expect(chef_run).to_not manage_user('apache2')
  #
  #
  # @param [String, Regex] resource_name
  #   the name of the resource to match
  #
  # @return [ChefSpec::Matchers::ResourceMatcher]
  #
  def manage_user(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:user, :manage, resource_name)
  end

  #
  # Assert that a +user+ resource exists in the Chef run with the
  # action +:lock+. Given a Chef Recipe that locks "apache2" as a
  # +user+:
  #
  #     user 'apache2' do
  #       action :lock
  #     end
  #
  # The Examples section demonstrates the different ways to test a
  # +user+ resource with ChefSpec.
  #
  # @example Assert that a +user+ was locked
  #   expect(chef_run).to lock_user('apache2')
  #
  # @example Assert that a +user+ was locked with predicate matchers
  #   expect(chef_run).to lock_user('apache2').with_uid(1234)
  #
  # @example Assert that a +user+ was locked with attributes
  #   expect(chef_run).to lock_user('apache2').with(uid: 1234)
  #
  # @example Assert that a +user+ was locked using a regex
  #   expect(chef_run).to lock_user('apache2').with(uid: /\d+/)
  #
  # @example Assert that a +user+ was _not_ locked
  #   expect(chef_run).to_not lock_user('apache2')
  #
  #
  # @param [String, Regex] resource_name
  #   the name of the resource to match
  #
  # @return [ChefSpec::Matchers::ResourceMatcher]
  #
  def lock_user(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:user, :lock, resource_name)
  end

  #
  # Assert that a +user+ resource exists in the Chef run with the
  # action +:unlock+. Given a Chef Recipe that unlocks "apache2" as a
  # +user+:
  #
  #     user 'apache2' do
  #       action :unlock
  #     end
  #
  # The Examples section demonstrates the different ways to test a
  # +user+ resource with ChefSpec.
  #
  # @example Assert that a +user+ was unlocked
  #   expect(chef_run).to unlock_user('apache2')
  #
  # @example Assert that a +user+ was unlocked with predicate matchers
  #   expect(chef_run).to unlock_user('apache2').with_uid(1234)
  #
  # @example Assert that a +user+ was unlocked with attributes
  #   expect(chef_run).to unlock_user('apache2').with(uid: 1234)
  #
  # @example Assert that a +user+ was unlocked using a regex
  #   expect(chef_run).to unlock_user('apache2').with(uid: /\d+/)
  #
  # @example Assert that a +user+ was _not_ unlocked
  #   expect(chef_run).to_not unlock_user('apache2')
  #
  #
  # @param [String, Regex] resource_name
  #   the name of the resource to match
  #
  # @return [ChefSpec::Matchers::ResourceMatcher]
  #
  def unlock_user(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:user, :unlock, resource_name)
  end
end
