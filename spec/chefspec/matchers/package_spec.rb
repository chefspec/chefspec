require 'spec_helper'

module ChefSpec
  module Matchers
    describe :install_package_at_version do
      describe "#match" do
        let(:matcher) { install_package_at_version('foo', '1.2.3') }
        it "should not match when no resources exist" do
          matcher.matches?({:resources => []}).should be false
        end
        it "should not match when there are no packages" do
          matcher.matches?({:resources => [{:resource_name => 'template', :path => '/tmp/config.conf',
            :source => 'config.conf.erb'}]}).should be false
        end
        it "should not match if is a different package and an unspecified version" do
          matcher.matches?({:resources => [{:resource_name => 'package', :package_name => 'bar', :version => nil, :action => :install}]}).should be false
        end
        it "should not match if it is the same package and version but a different action" do
          matcher.matches?({:resources => [{:resource_name => 'package', :package_name => 'foo', :version => '1.2.3', :action => :upgrade}]}).should be false
        end
        it "should match if is the same package, the correct version and the install action" do
          matcher.matches?({:resources => [{:resource_name => 'package', :package_name => 'foo', :version => '1.2.3', :action => :install}]}).should be true
        end
      end
    end
    describe :install_package do
      it "should match when using regexp" do
        install_package(/(ca){2}\-dev(el)?$/).matches?({:resources => [{:resource_name => 'package', :package_name => 'libcaca-devel', :version => '1.2.3', :action => :install}]}).should be true
      end
    end
    describe :remove_gem_package do
      it "should match when using regexp" do
        remove_gem_package(/([Rr]ed|[Bb]lue)\-?[Cc]loth/).matches?({:resources => [{:resource_name => 'gem_package', :package_name => 'RedCloth', :version => '1.2.3', :action => :remove}]}).should be true
      end
    end
  end
end
