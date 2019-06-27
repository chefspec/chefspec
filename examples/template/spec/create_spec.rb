require 'chefspec'

describe 'template::create' do
  platform 'ubuntu'

  describe 'creates a template with the default action' do
    it { is_expected.to create_template('/tmp/default_action') }
    it { is_expected.to_not create_template('/tmp/not_default_action') }
  end

  describe 'creates a template with an explicit action' do
    it { is_expected.to create_template('/tmp/explicit_action') }
  end

  describe 'creates a template with attributes' do
    it {
      is_expected.to create_template('/tmp/with_attributes').with(
        user: 'user',
        group: 'group',
        backup: false
      )
    }

    it {
      is_expected.to_not create_template('/tmp/with_attributes').with(
        user: 'bacon',
        group: 'fat',
        backup: true
      )
    }
  end

  describe 'creates a template when specifying the identity attribute' do
    it { is_expected.to create_template('/tmp/identity_attribute') }
  end
end
