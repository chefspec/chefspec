require 'spec_helper'

describe ChefSpec::API do
  before do
    module ChefSpec::API
      module CustomSubmodule
        def custom_method; end
      end
    end
  end

  subject { Class.new { include ChefSpec::API }.new }

  it 'includes all submodules in the including class' do
    expect(subject).to be_a(ChefSpec::API::CustomSubmodule)
    expect(subject).to respond_to(:custom_method)
  end
end
