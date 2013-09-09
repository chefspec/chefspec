require 'spec_helper'

module ChefSpec
  module MonkeyPatches
    describe :Hash do
      describe '#has_key?' do
        it 'allows a hash key to be referenced like a method' do
          expect({'foo' => {'bar' => 'nested_value'}}.foo.bar).to eq('nested_value')
        end

        it 'allows a hash key to be referenced like a method when a symbol' do
          expect({foo: {bar: 'nested_value'}}.foo.bar).to eq('nested_value')
        end

        it 'does not swallow errors when the key is not present' do
          expect {
            {
              foo: { not_bar: 'nested_value' }
            }.foo.bar
          }.to raise_error(NoMethodError)
        end
      end
    end
  end
end
