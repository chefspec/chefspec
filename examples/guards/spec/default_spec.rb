require 'chefspec'

describe 'guards::default' do
  platform 'ubuntu'

  describe 'includes resource that have guards that evalute to true' do
    it { is_expected.to start_service('true_guard') }
  end

  describe 'excludes resources that have guards evaluated to false' do
    it { is_expected.to_not start_service('false_guard') }
  end

  describe 'excludes resource that have action :nothing' do
    it { is_expected.to_not start_service('action_nothing_guard') }
  end
end
