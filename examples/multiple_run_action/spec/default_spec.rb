require 'chefspec'

describe 'multiple_run_action::default' do
  platform 'ubuntu'

  describe 'includes the action explicitly given to the resource' do
    it { is_expected.to create_template('/tmp/resource') }
  end

  describe 'includes an action specific called in #run_action' do
    it { is_expected.to touch_template('/tmp/resource') }
  end

  describe 'does not include something random' do
    template = subject.template('/tmp/resource')
    expect(template.performed_actions).to_not include(:bacon)
  end
end
