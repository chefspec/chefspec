require 'spec_helper'

# Don't run this test on older versions of Chef
if Chef::VERSION >= '11.0.0'

  module ChefSpec
    module MonkeyPatches
      describe :LWRPBase do
        describe '#remove_existing_lwrp' do
          it 'removes the provider if it already exists' do
            Chef::Provider::LWRPBase.const_set(:MysqlDatabase, nil)
            Chef::Provider::LWRPBase.remove_existing_lwrp('MysqlDatabase')
            expect(Chef::Provider::LWRPBase.constants).to_not include(:MysqlDatabase)
          end

          it 'removes the resource if it already exists' do
            Chef::Resource::LWRPBase.const_set(:MysqlDatabase, nil)
            Chef::Provider::LWRPBase.remove_existing_lwrp('MysqlDatabase')
            expect(Chef::Resource::LWRPBase.constants).to_not include(:MysqlDatabase)
          end

          it 'does not throw an error if the resource does not already exist' do
            expect {
              Chef::Provider::LWRPBase.remove_existing_lwrp 'Human'
            }.to_not raise_error
          end
        end
      end

      describe '#build_from_file' do
        it 'wraps the existing chef build_from_file method' do
          expect(Chef::Provider::LWRPBase.methods.map(&:to_sym)).to include(:old_build_from_file)
        end
      end
    end
  end

end
