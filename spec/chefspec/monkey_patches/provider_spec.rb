require 'spec_helper'

# Only test this on older versions of Chef
if Chef::VERSION < '11.0.0'

  module ChefSpec
    module MonkeyPatches
      describe :Provider do
        describe '#remove_existing_lwrp' do
          it 'removes the provider if it already exists' do
            Chef::Provider.const_set(:MysqlDatabase, nil)
            Chef::Provider.remove_existing_lwrp('MysqlDatabase')
            expect(Chef::Provider.constants).to_not include(:MysqlDatabase)
          end

          it 'removes the resource if it already exists' do
            Chef::Resource.const_set(:MysqlDatabase, nil)
            Chef::Provider.remove_existing_lwrp('MysqlDatabase')
            expect(Chef::Resource.constants).to_not include(:MysqlDatabase)
          end

          it 'does not throw an error if the resource does not already exist' do
            expect {
              Chef::Provider.remove_existing_lwrp 'Human'
            }.to_not raise_error
          end
        end
      end

      describe '#build_from_file' do
        it 'wraps the existing chef build_from_file method' do
          expect(Chef::Provider.methods.map(&:to_sym)).to include(:old_build_from_file)
        end
      end
    end
  end

end
