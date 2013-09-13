#
# Assert a given matcher behaves as expected.
#
shared_examples('a resource matcher') do |resource_name = nil, resource_action = nil|
  let(:matcher_name) { example.metadata[:example_group][:example_group][:description_args].first }
  let(:matcher) { send(matcher_name, 'resource') }
  let(:chain_matcher) { matcher.with(attribute: 'value') }
  let(:regex_matcher) { matcher.with(attribute: /val[a-z]+/) }

  before do
    @resource_action, @resource_name = matcher_name.to_s.split('_', 2)

    @resource_name   = resource_name   unless resource_name.nil?
    @resource_action = resource_action unless resource_action.nil?

    @resource_action = @resource_action.to_sym
  end

  it 'does not match when there are no resources' do
    expect(matcher).to_not be_matches({ node: {}, resources: [] })
  end

  it 'does not match when there are other types of resources' do
    expect(matcher).to_not be_matches({
      node: {},
      resources: [{
        resource_name: 'bacon',
        action:        @resource_action,
      }]
    })
  end

  it 'does not match when the resource exists but has the wrong name attribute' do
    expect(matcher).to_not be_matches({
      node: {},
      resources: [{
        resource_name: @resource_name,
        action:        @resource_action,
        identity:      'incorrect',
        name:          'incorrect',
      }]
    })
  end

  it 'matches when the resource exists' do
    expect(matcher).to be_matches({
      node: {},
      resources: [{
        resource_name: @resource_name,
        action:        @resource_action,
        identity:      'resource',
        name:          'resource',
      }]
    })
  end

  it 'does not match when the resource exists but has an incorrect attribute' do
    expect(chain_matcher).to_not be_matches({
      node: {},
      resources: [{
        resource_name: @resource_name,
        action:        @resource_action,
        identity:      'resource',
        attribute:     'incorrect',
        name:          'incorrect',
      }]
    })
  end

  it 'matches when all attributes are equal' do
    expect(chain_matcher).to be_matches({
      node: {},
      resources: [{
        resource_name: @resource_name,
        action:        @resource_action,
        identity:      'resource',
        name:          'resource',
        attribute:     'value',
      }]
    })
  end

  it 'does not match when the resource exists but has an incorrect regex attribute' do
    expect(regex_matcher).to_not be_matches({
      node: {},
      resources: [{
        resource_name: @resource_name,
        action:        @resource_action,
        identity:      'resource',
        name:          'resource',
        attribute:     'incorrect',
      }]
    })
  end

  it 'matches when all attributes match the regex' do
    expect(chain_matcher).to be_matches({
      node: {},
      resources: [{
        resource_name: @resource_name,
        action:        @resource_action,
        identity:      'resource',
        name:          'resource',
        attribute:     'value',
      }]
    })
  end

  it 'has the correct failure message for should' do
    expect(matcher.failure_message_for_should).to eq("expected '#{@resource_name}[resource]' with action ':#{@resource_action}' to be in Chef run")
  end

  it 'has the correct failure message for should_not' do
    expect(matcher.failure_message_for_should_not).to eq("expected '#{@resource_name}[resource]' matching 'resource' with action ':#{@resource_action}' to not be in Chef run")
  end
end
