Given /^a recipe that declares a (lwrp )?resource with a (only_if|not_if) ruby guard that returns (true|false)$/ do |lwrp, guard_type, guard_result|
  guard_attribute = "#{guard_type}{ #{guard_result} }"
  if lwrp
    cookbook_with_lwrp(guard_attribute)
  else
    recipe_creates_file(guard_attribute)
  end
end

Given /^a recipe that declares a resource with a (only_if|not_if) shell guard (.*)$/ do |guard_type, guard|
  recipe_creates_file('%s "%s"' % [guard_type, guard])
end

Given /^a spec example with guards (unspecified|enabled|disabled) that stubs (.*) to return (|true|false) and expects the resource to (be declared|not be declared)$/ do |guards_enabled, stub, result, be_declared|
  spec_expects_file_with_args({
    :constructor_args => guard_constructor_args(guards_enabled),
    :expectation => rspec_expectation(be_declared),
    :be_declared => be_declared,
    :stub => stub,
    :stub_result => result
  })
end

Given /^a spec example with guards enabled without stubbing that expects the resource to (be declared|not be declared)$/ do |be_declared|
  spec_expects_file_with_args({
    :constructor_args => [[:evaluate_guards, true]],
    :expectation => rspec_expectation(be_declared),
    :be_declared => be_declared
  })
end

Given /^the recipe has a spec example with guards (unspecified|enabled|disabled) that expects the (lwrp )?resource to (be declared|not be declared)$/ do |guards_enabled, lwrp, be_declared|
  constructor_args = guard_constructor_args(guards_enabled)
  expectation = rspec_expectation(be_declared)
  if lwrp
    spec_expects_lwrp_to_greet(constructor_args, expectation)
  else
    spec_expects_file_with_args({
      :constructor_args => constructor_args,
      :expectation => expectation,
      :be_declared => be_declared
    })
  end
end

When /^the guard example is unsuccessfully run( with stub error)?$/ do |stub_error|
  expected_failures = [', 1 failure']
  if stub_error
    expected_failures << 'The following shell guard was unstubbed:'
  end
  run_examples_unsuccessfully expected_failures
end

Then 'the resource will not have been created' do

end

private

def guard_constructor_args(guards_enabled)
  case guards_enabled
    when 'unspecified' then []
    when 'disabled' then [[:evaluate_guards, false]]
    when 'enabled' then [[:evaluate_guards, true]]
  end
end

def rspec_expectation(be_declared)
  if be_declared == 'be declared'
    'to'
  else
    'not_to'
  end
end
