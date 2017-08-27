require 'chef/cookbook/gem_installer'

class Chef
  class Cookbook
    class GemInstaller
      # Installs the gems into the omnibus gemset.
      def install
        cookbook_gems = Hash.new { |h, k| h[k] = [] }

        cookbook_collection.each do |cookbook_name, cookbook_version|
          cookbook_version.metadata.gems.each do |args|
            cookbook_gems[args.first] += args[1..-1]
          end
        end

        events.cookbook_gem_start(cookbook_gems)
        cookbook_gems.each { |gem_name, gem_requirements| locate_gem(gem_name, gem_requirements) }
        events.cookbook_gem_finished
      end

      private

      def locate_gem(gem_name, gem_requirements)
        ::Gem::Specification::find_by_name(gem_name, gem_requirements)
      rescue ::Gem::MissingSpecError
        gem_cmd = "gem install #{gem_name} --version '#{gem_requirements.join(', ')}'"
        gemfile_line = "gem '#{[gem_name, *gem_requirements].join('\', \'')}'"
        warn "No matching version found for '#{gem_name}' in your gem environment.\n" \
             " - if you are using ChefDK, run the following command: \"chef #{gem_cmd}\"\n" \
             " - if you are using bundler, append \"#{gemfile_line}\" to your Gemfile and run \"bundle install\"\n" \
             " - otherwise run: \"#{gem_cmd}\""
      end
    end
  end
end
