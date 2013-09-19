require 'spec_helper'

module ChefSpec
  describe ChefRunner do
    describe '#initialize' do
      it 'does not change the default cookbook path if examples are nested in subdirs under /spec' do
        Chef::Config[:cookbook_path] = nil
        ChefSpec::ChefRunner.new
        expect(Chef::Config[:cookbook_path]).to include(cookbook_path)
      end
    end
  end
end
