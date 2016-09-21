module ChefSpec::API
  # @since 3.0.0
  module YumRepositoryMatchers
    ChefSpec.define_matcher :yum_repository

    #
    # Assert that a +yum_repository+ resource exists in the Chef run with the
    # action +:create+. Given a Chef Recipe that creates "epel" as an
    # +yum_repository+:
    #
    #     yum_repository 'epel' do
    #       baseurl "http://mirrors.fedoraproject.org/mirrorlist?repo=epel-#{node['platform_version'].to_i}&arch=$basearch"
    #       description 'Extra Packages for $releasever - $basearch'
    #       action :create
    #     end
    #
    # The Examples section demonstrates the different ways to test an
    # +yum_repository+ resource with ChefSpec.
    #
    # @example Assert that an +yum_repository+ was created
    #   expect(chef_run).to create_yum_repository('epel')
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]

    def create_yum_repository(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:yum_repository, :create,
                                              resource_name)
    end

    #
    # Assert that a +yum_repository+ resource exists in the Chef run with the
    # action +:add+. Given a Chef Recipe that adds "epel" as an
    # +yum_repository+:
    #
    #     yum_repository 'epel' do
    #       baseurl "http://mirrors.fedoraproject.org/mirrorlist?repo=epel-#{node['platform_version'].to_i}&arch=$basearch"
    #       description 'Extra Packages for $releasever - $basearch'
    #       action :add
    #     end
    #
    # The Examples section demonstrates the different ways to test an
    # +yum_repository+ resource with ChefSpec.
    #
    # @example Assert that an +yum_repository+ was added
    #   expect(chef_run).to add_yum_repository('epel')
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]

    def add_yum_repository(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:yum_repository, :add,
                                              resource_name)
    end

    #
    # Assert that a +yum_repository+ resource exists in the Chef run with the
    # action +:delete+. Given a Chef Recipe that deletes "epel" as an
    # +yum_repository+:
    #
    #     yum_repository 'epel' do
    #       action :delete
    #     end
    #
    # The Examples section demonstrates the different ways to test an
    # +yum_repository+ resource with ChefSpec.
    #
    # @example Assert that an +yum_repository+ was deleted
    #   expect(chef_run).to delete_yum_repository('epel')
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]

    def delete_yum_repository(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:yum_repository, :delete,
                                              resource_name)
    end

    #
    # Assert that a +yum_repository+ resource exists in the Chef run with the
    # action +:remove+. Given a Chef Recipe that removes "epel" as an
    # +yum_repository+:
    #
    #     yum_repository 'epel' do
    #       action :remove
    #     end
    #
    # The Examples section demonstrates the different ways to test an
    # +yum_repository+ resource with ChefSpec.
    #
    # @example Assert that an +yum_repository+ was removed
    #   expect(chef_run).to remove_yum_repository('epel')
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]

    def remove_yum_repository(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:yum_repository, :remove,
                                              resource_name)
    end

    #
    # Assert that a +yum_repository+ resource exists in the Chef run with the
    # action +:makecache+. Given a Chef Recipe that makes cache for "epel" as
    # a +yum_repository+:
    #
    #     yum_repository 'epel' do
    #       action :makecache
    #     end
    #
    # The Examples section demonstrates the different ways to test an
    # +yum_repository+ resource with ChefSpec.
    #
    # @example Assert that an +yum_repository+ was make cache'd
    #   expect(chef_run).to makecache_yum_repository('epel')
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]

    def makecache_yum_repository(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:yum_repository, :makecache,
                                              resource_name)
    end
  end
end
