require 'spec_helper'

# Don't run this test on older versions of Chef
if Chef::VERSION >= '11.0.0'

  module ChefSpec
    module Extensions
      describe :LWRPBase do

        describe '#remove_existing_lwrp' do
          def run_check(container, remover)
            const_name = :MysqlDatabase
            sense = container == remover ? :to_not : :to
            containing_class = Chef.const_get(container)::LWRPBase
            removing_class = Chef.const_get(remover)::LWRPBase

            containing_class.const_set(const_name, nil)
            removing_class.remove_existing_lwrp(const_name.to_s)
            expect(containing_class.constants).send(sense, include(const_name))
            containing_class.send(:remove_const, const_name) if container != remover
          end

          it 'when called in Provider, removes the provider if it already exists' do
            run_check(:Provider, :Provider)
          end

          it 'when called in Provider, does not remove resource' do
            run_check(:Resource, :Provider)
          end

          it 'when called in Resource, removes the resource if it already exists' do
            run_check(:Resource, :Resource)
          end

          it 'when called in Resource, does not remove the provider' do
            run_check(:Provider, :Resource)
          end

          it 'does not throw an error if the resource does not already exist' do
            expect {
              Chef::Provider::LWRPBase.remove_existing_lwrp 'Human'
            }.to_not raise_error
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
