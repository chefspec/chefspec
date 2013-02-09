require 'spec_helper'

# Only test this on older versions of Chef
if Chef::VERSION < '11.0.0'

  module ChefSpec
    module MonkeyPatches
      describe :Provider do
        describe "#remove_existing_lwrp" do
          it "should remove the provider if it already exists" do
            Chef::Provider.const_set(:MysqlDatabase, nil)
            Chef::Provider.remove_existing_lwrp 'MysqlDatabase'
            Chef::Provider.constants.should_not include :MysqlDatabase
          end
          it "should remove the resource if it already exists" do
            Chef::Resource.const_set(:MysqlDatabase, nil)
            Chef::Provider.remove_existing_lwrp 'MysqlDatabase'
            Chef::Resource.constants.should_not include :MysqlDatabase
          end
          it "should not throw an error if the resource does not already exist" do
            expect { Chef::Provider.remove_existing_lwrp 'Human' }.to_not raise_error
          end
        end
      end
      describe "#build_from_file" do
        it "should wrap the existing chef build_from_file method" do
          Chef::Provider.methods.map{|method| method.to_sym}.should include :old_build_from_file
        end
      end
    end
  end

end
