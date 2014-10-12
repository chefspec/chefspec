module ChefSpec::API
  # @since 3.0.0
  module HttpRequestMatchers
    ChefSpec.define_matcher :http_request

    #
    # Assert that an +http_request+ resource exists in the Chef run with the
    # action +:delete+. Given a Chef Recipe that deletes "apache2" as an
    # +http_request+:
    #
    #     http_request 'apache2' do
    #       action :delete
    #     end
    #
    # The Examples section demonstrates the different ways to test an
    # +http_request+ resource with ChefSpec.
    #
    # @example Assert that an +http_request+ was DELETE
    #   expect(chef_run).to delete_http_request('apache2')
    #
    # @example Assert that an +http_request+ was DELETE with predicate matchers
    #   expect(chef_run).to delete_http_request('apache2').with_message('hello')
    #
    # @example Assert that an +http_request+ was DELETE with attributes
    #   expect(chef_run).to delete_http_request('apache2').with(message: 'hello')
    #
    # @example Assert that an +http_request+ was DELETE using a regex
    #   expect(chef_run).to delete_http_request('apache2').with(message: /he(.+)/)
    #
    # @example Assert that an +http_request+ was _not_ DELETE
    #   expect(chef_run).to_not delete_http_request('apache2')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def delete_http_request(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:http_request, :delete, resource_name)
    end

    #
    # Assert that an +http_request+ resource exists in the Chef run with the
    # action +:get+. Given a Chef Recipe that gets "apache2" as an
    # +http_request+:
    #
    #     http_request 'apache2' do
    #       action :get
    #     end
    #
    # The Examples section demonstrates the different ways to test an
    # +http_request+ resource with ChefSpec.
    #
    # @example Assert that an +http_request+ was GET
    #   expect(chef_run).to get_http_request('apache2')
    #
    # @example Assert that an +http_request+ was GET with predicate matchers
    #   expect(chef_run).to get_http_request('apache2').with_message('hello')
    #
    # @example Assert that an +http_request+ was GET with attributes
    #   expect(chef_run).to get_http_request('apache2').with(message: 'hello')
    #
    # @example Assert that an +http_request+ was GET using a regex
    #   expect(chef_run).to get_http_request('apache2').with(message: /he(.+)/)
    #
    # @example Assert that an +http_request+ was _not_ GET
    #   expect(chef_run).to_not get_http_request('apache2')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def get_http_request(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:http_request, :get, resource_name)
    end

    #
    # Assert that an +http_request+ resource exists in the Chef run with the
    # action +:head+. Given a Chef Recipe that heads "apache2" as an
    # +http_request+:
    #
    #     http_request 'apache2' do
    #       action :head
    #     end
    #
    # The Examples section demonstrates the different ways to test an
    # +http_request+ resource with ChefSpec.
    #
    # @example Assert that an +http_request+ was HEAD
    #   expect(chef_run).to head_http_request('apache2')
    #
    # @example Assert that an +http_request+ was HEAD with predicate matchers
    #   expect(chef_run).to head_http_request('apache2').with_message('hello')
    #
    # @example Assert that an +http_request+ was HEAD with attributes
    #   expect(chef_run).to head_http_request('apache2').with(message: 'hello')
    #
    # @example Assert that an +http_request+ was HEAD using a regex
    #   expect(chef_run).to head_http_request('apache2').with(message: /he(.+)/)
    #
    # @example Assert that an +http_request+ was _not_ HEAD
    #   expect(chef_run).to_not head_http_request('apache2')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def head_http_request(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:http_request, :head, resource_name)
    end

    #
    # Assert that an +http_request+ resource exists in the Chef run with the
    # action +:options+. Given a Chef Recipe that optionss "apache2" as an
    # +http_request+:
    #
    #     http_request 'apache2' do
    #       action :options
    #     end
    #
    # The Examples section demonstrates the different ways to test an
    # +http_request+ resource with ChefSpec.
    #
    # @example Assert that an +http_request+ was OPTIONS
    #   expect(chef_run).to options_http_request('apache2')
    #
    # @example Assert that an +http_request+ was OPTIONS with predicate matchers
    #   expect(chef_run).to options_http_request('apache2').with_message('hello')
    #
    # @example Assert that an +http_request+ was OPTIONS with attributes
    #   expect(chef_run).to options_http_request('apache2').with(message: 'hello')
    #
    # @example Assert that an +http_request+ was OPTIONS using a regex
    #   expect(chef_run).to options_http_request('apache2').with(message: /he(.+)/)
    #
    # @example Assert that an +http_request+ was _not_ OPTIONS
    #   expect(chef_run).to_not options_http_request('apache2')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def options_http_request(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:http_request, :options, resource_name)
    end

    #
    # Assert that an +http_request+ resource exists in the Chef run with the
    # action +:post+. Given a Chef Recipe that posts "apache2" as an
    # +http_request+:
    #
    #     http_request 'apache2' do
    #       action :post
    #     end
    #
    # The Examples section demonstrates the different ways to test an
    # +http_request+ resource with ChefSpec.
    #
    # @example Assert that an +http_request+ was POST
    #   expect(chef_run).to post_http_request('apache2')
    #
    # @example Assert that an +http_request+ was POST with predicate matchers
    #   expect(chef_run).to post_http_request('apache2').with_message('hello')
    #
    # @example Assert that an +http_request+ was POST with attributes
    #   expect(chef_run).to post_http_request('apache2').with(message: 'hello')
    #
    # @example Assert that an +http_request+ was POST using a regex
    #   expect(chef_run).to post_http_request('apache2').with(message: /he(.+)/)
    #
    # @example Assert that an +http_request+ was _not_ POST
    #   expect(chef_run).to_not post_http_request('apache2')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def post_http_request(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:http_request, :post, resource_name)
    end

    #
    # Assert that an +http_request+ resource exists in the Chef run with the
    # action +:put+. Given a Chef Recipe that puts "apache2" as an
    # +http_request+:
    #
    #     http_request 'apache2' do
    #       action :put
    #     end
    #
    # The Examples section demonstrates the different ways to test an
    # +http_request+ resource with ChefSpec.
    #
    # @example Assert that an +http_request+ was PUT
    #   expect(chef_run).to put_http_request('apache2')
    #
    # @example Assert that an +http_request+ was PUT with predicate matchers
    #   expect(chef_run).to put_http_request('apache2').with_message('hello')
    #
    # @example Assert that an +http_request+ was PUT with attributes
    #   expect(chef_run).to put_http_request('apache2').with(message: 'hello')
    #
    # @example Assert that an +http_request+ was PUT using a regex
    #   expect(chef_run).to put_http_request('apache2').with(message: /he(.+)/)
    #
    # @example Assert that an +http_request+ was _not_ PUT
    #   expect(chef_run).to_not put_http_request('apache2')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def put_http_request(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:http_request, :put, resource_name)
    end
  end
end
