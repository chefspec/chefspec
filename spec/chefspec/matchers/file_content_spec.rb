require 'spec_helper'

module ChefSpec
  module Matchers
    describe "#template_path" do
      let(:template) { double(:source => 'foo.erb', :cookbook_name => 'example', :cookbook => nil, :path => nil) }
      let(:cookbook) { Chef::CookbookVersion.new('example') }
      let(:node) { double(:platform => 'chefspec', :run_context => { :cookbook_collection => { 'example' => cookbook } }) }
      let(:source_path) { 'cookbooks/example/templates/default/foo.erb' }

      it "should determine the correct path" do
        cookbook.should_receive(:preferred_filename_on_disk_location).
          with(node, :templates, template.source).
          and_return(source_path)

        template_path(template, node).should == source_path
      end
    end
    describe :create_file_with_content do
      describe "#match with regex content" do
        let(:matcher) { create_file_with_content('/etc/config_file', /platform: chefspec/) }
        let(:canned_template){}

        it "should match a file resource with the right content regex and path" do
          matcher.matches?({:resources => [{:resource_name => 'file', :name => '/etc/config_file',
                                            :content => 'platform: chefspec', :action => :create}]}).should be true
        end

        it "should not match a file resource with the wrong content regex and right path" do
          matcher.matches?({:resources => [{:resource_name => 'file', :name => '/etc/config_file',
                                            :content => 'platform: macosx', :action => :create}]}).should be false
        end
      end

      describe "#match" do
        let(:matcher) { create_file_with_content('/etc/config_file', 'platform: chefspec') }
        it "should not match when no resources exist" do
          matcher.matches?({:resources => []}).should be false
        end
        it "should not match when there are no resources that set the file contents" do
          matcher.matches?({:resources => [{:resource_name => 'group', :name => 'admin'}]}).should be false
        end
        it "should not match a file resource with the right content and path but the wrong action" do
          matcher.matches?({:resources => [{:resource_name => 'file', :name => '/etc/another_config_file',
                                            :content => 'platform: chefspec', :action => :delete}]}).should be false
        end
        it "should not match a file resource with the right path but no content" do
          matcher.matches?({:resources => [{:resource_name => 'file', :name => '/etc/config_file',
                                            :content => nil, :action => :create}]}).should be false
        end
        it "should not match a file resource with the right content but the wrong path" do
          matcher.matches?({:resources => [{:resource_name => 'file', :name => '/etc/another_config_file',
                                            :content => 'platform: chefspec', :action => :create}]}).should be false
        end
        it "should match a file resource with the right content and path" do
          matcher.matches?({:resources => [{:resource_name => 'file', :name => '/etc/config_file',
                                            :content => 'platform: chefspec', :action => :create}]}).should be true
        end

        it "should match a file resource with the right path and content somewhere in the file" do
          matcher.matches?({:resources => [{:resource_name => 'file', :name => '/etc/config_file',
                                            :content => "fqdn: chefspec.local\nplatform: chefspec\nhostname: chefspec", :action => :create}]}).should be true
        end
        it "should match a file resource create_if_missing with the right content and path" do
          matcher.matches?({:resources => [{:resource_name => 'file', :name => '/etc/config_file',
                                            :content => 'platform: chefspec',
                                            :action => :create_if_missing}]}).should be true
        end
        it "should not match a template resource with the right path but no content" do
          matcher.stub(:render).and_return("")
          matcher.matches?({:node => {}, :run_context=>{}, :resources => [{:resource_name => 'template', :name => '/etc/config_file',
                                            :cookbook_name=>'foo', :action => :create}]}).should be false
        end
        it "should not match a template resource with the right content but the wrong path" do
          matcher.stub(:render).and_return("platform: chefspec")
          matcher.matches?({:node => {}, :resources => [{:resource_name => 'template', :name => '/etc/another_config_file',
                                            :action => :create}]}).should be false
        end
        it "should match a template resource with the right content and path" do
          matcher.stub(:render).and_return("platform: chefspec")
          matcher.matches?({:node => {}, :run_context=>{}, :resources => [{:resource_name => 'template', :name => '/etc/config_file',
                                            :cookbook_name=>'foo', :action => :create}]}).should be true
        end
        it "should match a template resource with the right path and content somewhere in the file" do
          matcher.stub(:render).and_return("fqdn: chefspec.local\nplatform: chefspec\nhostname: chefspec")
          matcher.matches?({:node => {}, :run_context=>{}, :resources => [{:resource_name => 'template', :name => '/etc/config_file',
                                            :cookbook_name=>'foo', :action => :create}]}).should be true
        end
        it "should match a template resource create_if_missing with the right content and path" do
          matcher.stub(:render).and_return("platform: chefspec")
          matcher.matches?({:node => {}, :run_context=>{}, :resources => [{:resource_name => 'template', :name => '/etc/config_file',
                                            :cookbook_name=>'foo', :action => :create_if_missing}]}).should be true
        end

        context "a cookbook_file resource" do
          let(:cookbook) { Chef::CookbookVersion.new('cookbook') }
          let(:source_path) { "cookbook/files/default/config_file" }

          before do
            cookbook.stub(:preferred_filename_on_disk_location).and_return(source_path)
          end

          it "should not match a cookbook_file resource with the right path but no content" do
            File.stub(:read).with(source_path).and_return("")
            matcher.matches?({
              :run_context => {
                :cookbook_collection => {
                  'cookbook' => cookbook
                }
              },
              :node => {
                :platform => 'chefspec',
              },
              :resources => [
                {
                  :resource_name => 'cookbook_file',
                  :name => '/etc/config_file',
                  :path => '/etc/config_file',
                  :source => 'config_file',
                  :cookbook => "cookbook",
                  :action => :create
                }
              ]
            }).should be false
          end

          it "should not match a cookbook_file resource with the right content but the wrong path" do
            File.stub(:read).with(source_path).and_return("platform: chefspec")
            matcher.matches?({
              :run_context => {
                :cookbook_collection => {
                  'cookbook' => cookbook
                }
              },
              :node => {
                :platform => 'chefspec',
              },
              :resources => [
                {
                  :resource_name => 'cookbook_file',
                  :name => '/etc/another_config_file',
                  :path => '/etc/another_config_file',
                  :source => 'config_file',
                  :cookbook => "cookbook",
                  :action => :create
                }
              ]
            }).should be false
          end

          it "should match a cookbook_file resource with the right content and path" do
            File.stub(:read).with(source_path).and_return("platform: chefspec")
            matcher.matches?({
              :run_context => {
                :cookbook_collection => {
                  'cookbook' => cookbook
                }
              },
              :node => {
                :platform => 'chefspec',
              },
              :resources => [
                {
                  :resource_name => 'cookbook_file',
                  :name => '/etc/config_file',
                  :path => '/etc/config_file',
                  :source => 'config_file',
                  :cookbook => "cookbook",
                  :action => :create
                }
              ]
            }).should be true
          end

          it "should match a cookbook_file resource with the right path and content somewhere in the file" do
            File.stub(:read).with(source_path).and_return("fqdn: chefspec.local\nplatform: chefspec\nhostname: chefspec")
            matcher.matches?({
              :run_context => {
                :cookbook_collection => {
                  'cookbook' => cookbook
                }
              },
              :node => {
                :platform => 'chefspec',
              },
              :resources => [
                {
                  :resource_name => 'cookbook_file',
                  :name => '/etc/config_file',
                  :path => '/etc/config_file',
                  :source => 'config_file',
                  :cookbook => "cookbook",
                  :action => :create
                }
              ]
            }).should be true
          end

          it "should match a cookbook_file resource create_if_missing with the right content and path" do
            File.stub(:read).with(source_path).and_return("platform: chefspec")
            matcher.matches?({
              :run_context => {
                :cookbook_collection => {
                  'cookbook' => cookbook
                }
              },
              :node => {
                :platform => 'chefspec',
              },
              :resources => [
                {
                  :resource_name => 'cookbook_file',
                  :name => '/etc/config_file',
                  :path => '/etc/config_file',
                  :source => 'config_file',
                  :cookbook => "cookbook",
                  :action => :create_if_missing
                }
              ]
            }).should be true
          end

          describe "#match with regex content" do
            let(:matcher) { create_file_with_content('/etc/config_file', /platform: chefspec/) }

            it "should match a file resource with the right content regex and path" do
              matcher.matches?({
                :resources => [
                  {
                    :resource_name => 'file',
                    :name => '/etc/config_file',
                    :content => 'platform: chefspec',
                    :action => :create
                  }
                ]
              }).should be true
            end

            it "should not match a file resource with the wrong content regex and right path" do
              matcher.matches?({
                :resources => [
                  {
                    :resource_name => 'file',
                    :name => '/etc/config_file',
                    :content => 'platform: macosx',
                    :action => :create
                  }
                ]
              }).should be false
            end
          end
        end
      end
    end
  end
end
