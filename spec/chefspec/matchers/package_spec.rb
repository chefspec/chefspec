require 'spec_helper'

module ChefSpec
  module Matchers
    describe :install_package_at_version do
      describe "#match" do
        it "should not match when no resources exist" do
          matcher = install_package_at_version('foo', '1.2.3')
          chef_run = {:resources => []}
          matcher.matches?(chef_run).should be false
        end
        it "should not match when there are no packages" do
          matcher = install_package_at_version('foo', '1.2.3')
          chef_run = {:resources => [{:resource_name => 'template', :path => '/tmp/config.conf',
            :source => 'config.conf.erb'}]}
          matcher.matches?(chef_run).should be false
        end
        it "should not match if is a different package and an unspecified version" do
          matcher = install_package_at_version('foo', '1.2.3')
          chef_run = {:resources => [{:resource_name => 'package', :package_name => 'bar', :version => nil,
            :action => :install}]}
          matcher.matches?(chef_run).should be false
        end
        it "should not match if it is the same package and version but a different action" do
          matcher = install_package_at_version('foo', '1.2.3')
          chef_run = {:resources => [{:resource_name => 'package', :package_name => 'foo', :version => '1.2.3',
            :action => :upgrade}]}
          matcher.matches?(chef_run).should be false
        end
        it "should match if is the same package, the correct version and the install action" do
          matcher = install_package_at_version('foo', '1.2.3')
          chef_run = {:resources => [{:resource_name => 'package', :package_name => 'foo', :version => '1.2.3',
            :action => :install}]}
          matcher.matches?(chef_run).should be true
        end
      end
    end
  end
end