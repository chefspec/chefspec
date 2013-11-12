require 'spec_helper'

# Don't run this test on older versions of Chef
if Chef::VERSION >= '11.0.0'

  module ChefSpec
    module Extensions
      describe :LWRPBase do
        describe '#remove_existing_lwrp' do
          before do
            Chef::Provider::MysqlDatabase = nil
            Chef::Resource::MysqlDatabase = nil
          end

          after do
            [Chef::Provider, Chef::Resource].each do |mod|
              next unless mod.const_defined?(:MysqlDatabase, false)
              mod.send(:remove_const, :MysqlDatabase)
            end
          end

          context Chef::Provider do
            before do
              Chef::Provider::LWRPBase.remove_existing_lwrp('MysqlDatabase')
            end

            it 'removes the provider if it already exists' do
              expect(Chef::Provider.constants).to_not include(:MysqlDatabase)
            end

            it 'does not remove resource'  do
              expect(Chef::Resource.constants).to include(:MysqlDatabase)
            end

            it 'does not throw an error if the resource does not already exist' do
              expect {
                Chef::Provider::LWRPBase.remove_existing_lwrp 'Human'
              }.to_not raise_error
            end
          end

          context Chef::Resource do
            before do
              Chef::Resource::LWRPBase.remove_existing_lwrp('MysqlDatabase')
            end

            it 'removes the resource if it already exists' do
              expect(Chef::Resource.constants).to_not include(:MysqlDatabase)
            end

            it 'does not remove the provider'  do
              Chef::Resource::LWRPBase.remove_existing_lwrp('MysqlDatabase')
              expect(Chef::Provider.constants).to include(:MysqlDatabase)
            end

            it 'does not throw an error if the resource does not already exist' do
              expect {
                Chef::Resource::LWRPBase.remove_existing_lwrp 'Human'
              }.to_not raise_error
            end
          end
        end
      end

      describe '#build_from_file' do
        %w{Resource Provider}.each do |m|
          it "in #{m}, wraps the existing chef build_from_file method" do
            args = %w{mycookbook thisfile context}
            klass = Chef.const_get(m)::LWRPBase
            allow(klass).to receive(:build_from_file_without_removal)
            expect(klass).to receive(:build_from_file_without_removal).with(*args)
            klass.build_from_file(*args)
          end
        end
      end
    end
  end

end
