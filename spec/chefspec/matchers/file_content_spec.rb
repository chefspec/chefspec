require 'spec_helper'

module ChefSpec
  module Matchers
    describe "#template_path" do
      context "local to this cookbook" do
        let(:template) {{:source => 'foo.erb', :cookbook_name => 'example', :cookbook => nil}}
        it "should determine the correct path" do
          template_path(template).should == 'cookbooks/example/templates/default/foo.erb'
        end
      end
      context "from another cookbook" do
        let(:template) {{:source => 'foo.erb', :cookbook_name => 'example', :cookbook => 'another'}}
        it "should determine the correct path" do
          template_path(template).should == 'cookbooks/another/templates/default/foo.erb'
        end
      end
    end
    describe :create_file_with_content do
      describe "#match" do
        let(:matcher) { create_file_with_content('/etc/config_file', 'platform: chefspec') }
        it "should not match when no resources exist" do
          matcher.matches?({:resources => []}).should be false
        end
        it "should not match when there are no resources that set the file contents" do
          matcher.matches?({:resources => [{:resource_name => 'group', :name => 'admin'}]}).should be false
        end
        it "should not match a file resource with the right path but no content" do
          matcher.matches?({:resources => [{:resource_name => 'file', :name => '/etc/config_file',
                                            :content => nil, :action => [:create]}]}).should be false
        end
        it "should not match a file resource with the right content but the wrong path" do
          matcher.matches?({:resources => [{:resource_name => 'file', :name => '/etc/another_config_file',
                                            :content => 'platform: chefspec', :action => [:create]}]}).should be false
        end
        it "should match a file resource with the right content and path" do
          matcher.matches?({:resources => [{:resource_name => 'file', :name => '/etc/config_file',
                                            :content => 'platform: chefspec', :action => [:create]}]}).should be true
        end
        it "should match a file resource with the right path and content somewhere in the file" do
          matcher.matches?({:resources => [{:resource_name => 'file', :name => '/etc/config_file',
                                            :content => "fqdn: chefspec.local\nplatform: chefspec\nhostname: chefspec", :action => [:create]}]}).should be true
        end
        it "should match a file resource create_if_missing with the right content and path" do
          matcher.matches?({:resources => [{:resource_name => 'file', :name => '/etc/config_file',
                                            :content => 'platform: chefspec',
                                            :action => [:create_if_missing]}]}).should be true
        end
      end
    end
  end
end