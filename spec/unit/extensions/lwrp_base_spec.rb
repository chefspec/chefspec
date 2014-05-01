require 'spec_helper'

# Don't run this test on older versions of Chef
if Chef::VERSION >= '11.0.0'

  module ChefSpec
    module Extensions
      describe :LWRPBase do
        describe '#remove_existing_lwrp' do
          before do
            Chef::Provider::MysqlDatabase = nil
            Chef::Resource::MysqlDatabase = Class.new(Chef::Resource)
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
            let!(:resource_class) { Chef::Resource::MysqlDatabase }

            before do
              Chef::Resource::LWRPBase.remove_existing_lwrp('MysqlDatabase')
            end

            it 'removes the resource if it already exists' do
              expect(Chef::Resource.constants).to_not include(:MysqlDatabase)
            end

            if Chef::Resource.respond_to?(:resource_classes)
              it 'removes the resource from Chef::Resource.resource_classes' do
                expect(Chef::Resource.resource_classes).to_not include(resource_class)
              end
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
        let(:args){ %w{mycookbook thisfile context} }

        shared_context "wrapping" do
          it 'wraps the existing chef build_from_file method' do
            klass = mod::LWRPBase
            allow(klass).to receive(:build_from_file_without_removal)
            expect(klass).to receive(:build_from_file_without_removal).with(*args)
            klass.build_from_file(*args)
          end
        end

        context Chef::Provider do
          let(:mod){ Chef::Provider }
          include_context "wrapping"
        end

        context Chef::Resource do
          let(:mod){ Chef::Resource }
          include_context "wrapping"
        end
      end
    end
  end
end
