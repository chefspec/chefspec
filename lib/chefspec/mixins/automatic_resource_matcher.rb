module ChefSpec
  module AutomaticResourceMatcher
    def method_missing(meth, *args, &block)
      method_name = meth.to_s
      cookbook_candidates = get_cookbook_candidates(method_name)

      cookbook_matches = find_cookbooks_with_matching_resources(cookbook_candidates, method_name)

      if cookbook_matches.length == 1
        cookbook = cookbook_matches.first
        create_matcher(args, cookbook[:name], method_name)
      else
        super
      end
    end

    private
    def cookbooks
      @cookbooks ||=
        cookbook_paths
          .map { |cookbook_path| Dir.glob("#{cookbook_path}/*") }
          .flatten
          .select { |c| File.directory? c }
          .map { |c| { :name => Pathname.new(c).basename.to_s, :path => c } }
          .flatten
    end

    def cookbook_paths
      Chef::Config[:cookbook_path]
    end

    def get_cookbook_candidates(method_name)
      cookbooks.select { |c| method_name.include? c[:name] }
    end

    def parse_lwrp(cookbook, method_name)
      parts = method_name.split("_#{cookbook}_")
      { :action => parts[0], :cookbook => cookbook, :resource_name => parts[1] }
    end

    def find_cookbooks_with_matching_resources(cookbook_candidates, method_name)
      cookbook_matches = []
      cookbook_candidates.each do |cookbook|
        resource_parts = parse_lwrp(cookbook[:name], method_name)
        cookbook_matches.push(cookbook) if cookbook_has_resource?(cookbook, resource_parts[:resource_name])
      end
      cookbook_matches
    end

    def cookbook_has_resource?(cookbook, resource_name)
      Dir.glob("#{cookbook[:path]}/resources/#{resource_name}.rb").length == 1
    end

    def create_matcher(args, cookbook, method_name)
      resource_definition = parse_lwrp(cookbook, method_name)
      ChefSpec::Matchers::ResourceMatcher.new("#{cookbook}_#{resource_definition[:resource_name]}".to_sym, resource_definition[:action].to_sym, args[0])
    end
  end
end

RSpec.configure do |c|
  c.include ChefSpec::AutomaticResourceMatcher
end